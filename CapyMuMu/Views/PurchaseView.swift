import SwiftUI
import StoreKit

// MARK: - Purchase Window Manager
class PurchaseWindowManager: ObservableObject {
    static let shared = PurchaseWindowManager()
    private var purchaseWindow: NSWindow?
    
    // 保存环境对象的引用
    private var storeManager: StoreManager?
    private var configManager: SavedConfigurationManager?
    
    private init() {}
    
    func showPurchaseWindow(storeManager: StoreManager, configManager: SavedConfigurationManager) {
        // 保存环境对象
        self.storeManager = storeManager
        self.configManager = configManager
        
        // 如果窗口已经存在，就显示它
        if let window = purchaseWindow {
            window.orderFrontRegardless()
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // 创建新窗口
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 350),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "CapyMuMu"
        window.center()
        
        // 设置窗口层级和行为
        window.level = .floating
        window.isReleasedWhenClosed = false
        
        // 设置窗口内容
        let purchaseView = PurchaseView()
            .environmentObject(storeManager)
            .environmentObject(configManager)
        
        window.contentView = NSHostingView(rootView: purchaseView)
        
        // 保存窗口引用
        purchaseWindow = window
        
        // 设置窗口关闭时的回调
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            self?.purchaseWindow = nil
            self?.storeManager = nil
            self?.configManager = nil
        }
        
        // 显示窗口并激活应用
        window.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
            Text(text)
        }
    }
}

// MARK: - Purchase View
struct PurchaseView: View {
    @EnvironmentObject private var storeManager: StoreManager
    @EnvironmentObject private var configManager: SavedConfigurationManager
    
    private var productName: String { storeManager.productName }
    private var productDescription: String { storeManager.productDescription }
    private var price: String { storeManager.price }
    private var priceDescription: String { storeManager.priceDescription }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(productName)
                .font(.title2)
                .bold()
            
            Text(productDescription)
                .padding(.horizontal)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 10) {
                FeatureRow(icon: "waveform", text: "解锁所有环境音")
                FeatureRow(icon: "music.note", text: "解锁所有音乐")
                FeatureRow(icon: "bookmark", text: "解锁保存功能")
            }
            .padding(.vertical)
            
            if storeManager.isLoading {
                ProgressView()
                    .controlSize(.large)
            } else if storeManager.isPro {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("已购买")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .disabled(true)
            } else {
                VStack(spacing: 4) {
                    Button(action: {
                        Task {
                            await storeManager.purchase()
                        }
                    }) {
                        Text(price)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .disabled(storeManager.isLoading)
                    
                    if !priceDescription.isEmpty {
                        Text(priceDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button(action: {
                    Task {
                        await storeManager.restorePurchases()
                    }
                }) {
                    Text("恢复购买")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .disabled(storeManager.isLoading)
            }
            
            if let error = storeManager.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(25)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PurchaseView()
        .environmentObject(StoreManager())
        .environmentObject(SavedConfigurationManager())
}
