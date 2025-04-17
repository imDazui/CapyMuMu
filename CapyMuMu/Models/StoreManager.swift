import Foundation
import StoreKit

// MARK: - Store Manager
@MainActor
class StoreManager: ObservableObject {
    static let shared = StoreManager()
    
    // MARK: - Published Properties
    @Published private(set) var products: [Product] = []
    @Published private(set) var isPro: Bool = true
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
            return product.displayPrice
        }
        return "[加载价格中...]"
    }
    
    var priceDescription: String {
        if let product = products.first {
            if let subscription = product.subscription {
                // 检查是否有促销优惠
                if let introductoryOffer = subscription.introductoryOffer {
                    switch introductoryOffer.type {
                    case .introductory:
                        return "首次购买优惠价 \(introductoryOffer.displayPrice)"
                    case .promotional:
                        return "限时优惠价 \(introductoryOffer.displayPrice)"
                    default:
                        return ""
                    }
                }
                
                // 检查是否有订阅优惠
                let promotionalOffers = subscription.promotionalOffers
                if !promotionalOffers.isEmpty {
                    return "特惠价 \(promotionalOffers[0].displayPrice)"
                }
            }
            return ""
        }
        return ""
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
        // 始终保持 Pro 状态为 true，无需验证购买
        isPro = true
        // 以下代码已被注释掉，以确保所有功能都可用
        /*
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == Self.productID {
                    isPro = true
                    return
                }
            }
        }
        isPro = false
        */
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
