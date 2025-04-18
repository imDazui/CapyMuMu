import SwiftUI

// MARK: - Save Menu ViewSavedConfigurationManager
struct SaveMenuView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var audioManager: AudioManager
    @EnvironmentObject private var storeManager: StoreManager
    @StateObject private var configManager = SavedConfigurationManager()
    @Environment(\.colorScheme) private var colorScheme
    @State private var hoveredConfigId: UUID? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: handleSave) {
                Label("保存", systemImage: storeManager.isPro ? "plus" : "lock.fill")
                    .foregroundColor(.primary)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 4)
            
            if !configManager.savedConfigurations.isEmpty {
                Divider()
                
                ForEach(configManager.savedConfigurations) { config in
                    ConfigurationRow(config: config, hoveredConfigId: $hoveredConfigId, isPresented: $isPresented)
                        .environmentObject(audioManager)
                        .environmentObject(configManager)
                }
            }
        }
        .padding(8)
        .frame(minWidth: 200)
    }
    
    private func handleSave() {
        if storeManager.isPro {
            // 使用 DispatchQueue.main.async 来避免布局递归
            DispatchQueue.main.async {
                let audioTypes = Array(audioManager.selectedTypes)
                let music = audioManager.selectedMusic
                configManager.saveConfiguration(
                    audioTypes: audioTypes,
                    music: music,
                    timeLimit: audioManager.selectedTimeLimit
                )
            }
        } else {
            PurchaseWindowManager.shared.showPurchaseWindow(
                storeManager: storeManager,
                configManager: configManager
            )
        }
    }
}