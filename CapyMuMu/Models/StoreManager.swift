import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published private(set) var isPro: Bool = false
    @Published private(set) var isLoading = false
    @Published private(set) var loadError: Error?
    
    // MARK: - Constants
    private let proProductID = "com.capymumu.pro"
    private var updates: Task<Void, Never>? = nil
    
    // MARK: - Initialization
    init() {
        print("StoreManager: Initializing...")
        updates = observeTransactionUpdates()
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    // MARK: - Public Methods
    /// 清除所有购买记录（仅用于测试）
    #if DEBUG
    func clearPurchases() async {
        print("StoreManager: Clearing purchases...")
        for await verification in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(verification)
                await transaction.finish()
                print("StoreManager: Cleared transaction: \(transaction.id)")
            } catch {
                print("StoreManager: Failed to clear transaction: \(error)")
            }
        }
        purchasedProductIDs.removeAll()
        isPro = false
        print("StoreManager: All purchases cleared")
    }
    #endif
    
    /// 检查是否为 Pro 版本
    func checkProStatus() -> Bool {
        return isPro
    }
    
    /// 加载商品信息
    func loadProducts() async {
        print("StoreManager: Starting to load products...")
        isLoading = true
        loadError = nil
        
        do {
            let productIds = [proProductID]
            print("StoreManager: Requesting products for IDs: \(productIds)")
            
            #if DEBUG
            // 检查是否在使用 StoreKit 配置文件
            if let path = Bundle.main.path(forResource: "Configuration", ofType: "storekit") {
                print("StoreManager: Found StoreKit configuration at: \(path)")
            } else {
                print("StoreManager: ⚠️ No StoreKit configuration file found")
            }
            #endif
            
            products = try await Product.products(for: [proProductID])
            print("StoreManager: Successfully loaded \(products.count) products:")
            for product in products {
                print("- Product: \(product.id)")
                print("  - Name: \(product.displayName)")
                print("  - Description: \(product.description)")
                print("  - Price: \(product.displayPrice)")
            }
            
            if products.isEmpty {
                print("StoreManager: ⚠️ No products were loaded")
            }
        } catch {
            print("StoreManager: ❌ Failed to load products: \(error)")
            print("StoreManager: Error details: \(String(describing: error))")
            loadError = error
        }
        
        isLoading = false
    }
    
    /// 购买商品
    func purchase(_ product: Product) async throws {
        print("StoreManager: Starting purchase for \(product.id)...")
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            print("StoreManager: Purchase succeeded, verifying transaction...")
            // 检查交易凭证
            let transaction = try checkVerified(verification)
            
            // 更新购买状态
            await updatePurchaseState(transaction)
            print("StoreManager: Purchase state updated, isPro: \(isPro)")
            
            // 完成交易
            await transaction.finish()
            print("StoreManager: Transaction finished successfully")
            
        case .userCancelled:
            print("StoreManager: User cancelled the purchase")
            
        case .pending:
            print("StoreManager: Purchase is pending")
            
        @unknown default:
            print("StoreManager: Unknown purchase result")
            break
        }
    }
    
    /// 更新已购买商品
    func updatePurchasedProducts() async {
        print("StoreManager: Updating purchased products...")
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                await updatePurchaseState(transaction)
            } catch {
                print("StoreManager: Failed to verify transaction: \(error)")
            }
        }
        print("StoreManager: Finished updating purchased products. isPro: \(isPro)")
    }
    
    // MARK: - Private Methods
    private func updatePurchaseState(_ transaction: Transaction) async {
        if transaction.productID == proProductID {
            purchasedProductIDs.insert(transaction.productID)
            isPro = true
            print("StoreManager: Pro status updated: \(isPro)")
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            print("StoreManager: Starting transaction observation...")
            for await verification in Transaction.updates {
                do {
                    let transaction = try checkVerified(verification)
                    await updatePurchaseState(transaction)
                    await transaction.finish()
                } catch {
                    print("StoreManager: Failed to verify transaction: \(error)")
                }
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            print("StoreManager: ❌ Transaction verification failed")
            throw StoreError.failedVerification
        case .verified(let safe):
            print("StoreManager: ✅ Transaction verified")
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
