import SwiftUI
import StoreKit

struct PurchaseView: View {
    @StateObject private var storeManager = StoreManager()
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("升级到 Pro")
                .font(.title)
                .fontWeight(.bold)
            
            // 功能列表
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(icon: "infinity", text: "无限制使用所有环境音效")
                FeatureRow(icon: "music.note", text: "解锁所有音乐")
                FeatureRow(icon: "square.stack", text: "保存无限组合")
                FeatureRow(icon: "timer", text: "定时功能")
                FeatureRow(icon: "heart", text: "支持开发者")
            }
            .padding(.vertical)
            
            // 加载状态
            if storeManager.isLoading {
                ProgressView("正在加载商品信息...")
            } else if let error = storeManager.loadError {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title)
                        .foregroundColor(.red)
                    Text("加载失败")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button("重试") {
                        Task {
                            await storeManager.loadProducts()
                        }
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                // 商品列表
                ForEach(storeManager.products) { product in
                    Button(action: {
                        Task {
                            await purchase(product)
                        }
                    }) {
                        VStack {
                            Text("解锁 \(product.displayName)")
                                .font(.headline)
                            Text(product.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(product.displayPrice)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(isLoading)
                }
            }
            
            Spacer()
            
            // 恢复购买按钮
            Button("恢复购买") {
                Task {
                    await storeManager.updatePurchasedProducts()
                }
            }
            .disabled(isLoading)
            
            // 调试按钮
            #if DEBUG
            Button("清除购买记录") {
                Task {
                    await storeManager.clearPurchases()
                }
            }
            .disabled(isLoading)
            #endif
        }
        .padding()
        .alert("购买失败", isPresented: $showError, presenting: errorMessage) { _ in
            Button("确定", role: .cancel) {}
        } message: { error in
            Text(error)
        }
    }
    
    private func purchase(_ product: Product) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await storeManager.purchase(product)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    PurchaseView()
}
