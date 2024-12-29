import Foundation
import StoreKit

// MARK: - Store Manager
@MainActor
class StoreManager: ObservableObject {
    static let shared = StoreManager()
    
    // MARK: - Published Properties
    @Published private(set) var products: [Product] = []
    @Published private(set) var isPro: Bool = false
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    // MARK: - Constants
    private static let productID = "com.capymumu.pro"
    private var updateListenerTask: Task<Void, Error>?
    
    // MARK: - Initialization
    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Public Properties
    var productName: String {
        if let product = products.first {
            return product.displayName
        }
        return "[加载商品名称中...]"
    }
    
    var productDescription: String {
        if let product = products.first {
            return product.description
        }
        return "[加载商品描述中...]"
    }
    
    var price: String {
        if let product = products.first {
            // 使用系统的价格格式化器
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceFormatStyle.locale
            
            if let formattedPrice = formatter.string(from: NSDecimalNumber(decimal: product.price)) {
                return formattedPrice
            }
            return product.displayPrice
        }
        return "[加载价格中...]"
    }
    
    // MARK: - Public Methods
    /// 加载商品信息
    func loadProducts() async {
        isLoading = true
        error = nil
        
        do {
            let storeProducts = try await Product.products(for: [Self.productID])
            products = storeProducts
            print("StoreManager: Successfully loaded \(storeProducts.count) products:")
            for product in storeProducts {
                print("- Product: \(product.id)")
                print("  - Name: \(product.displayName)")
                print("  - Description: \(product.description)")
                print("  - Price: \(product.displayPrice)")
            }
        } catch {
            print("StoreManager: Failed to load products:", error)
            self.error = "无法加载商品信息"
        }
        
        isLoading = false
    }
    
    /// 购买商品
    func purchase() async {
        guard let product = products.first else {
            error = "商品信息未加载"
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(_):
                print("StoreManager: Purchase succeeded")
                await updatePurchasedProducts()
                
            case .userCancelled:
                print("StoreManager: Purchase cancelled by user")
                
            case .pending:
                print("StoreManager: Purchase pending")
                error = "购买正在处理中"
                
            default:
                print("StoreManager: Purchase failed")
                error = "购买失败"
            }
        } catch {
            print("StoreManager: Purchase error:", error)
            self.error = "购买时出现错误"
        }
        
        isLoading = false
    }
    
    /// 更新已购买商品
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == Self.productID {
                    isPro = true
                    return
                }
            }
        }
        isPro = false
    }
    
    /// 恢复购买
    func restorePurchases() async {
        isLoading = true
        error = nil
        
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            print("StoreManager: Restore purchases error:", error)
            self.error = "恢复购买失败"
        }
        
        isLoading = false
    }
    
    // MARK: - Private Methods
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            print("StoreManager: Starting transaction observation...")
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                }
            }
        }
    }
}
