import SwiftUI

// MARK: - Audio Item View
struct AudioItemView: View {
    let type: AudioType
    let isLocked: Bool
    let isSelected: Bool
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                // 状态图标
                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(width: 16)
                } else {
                    Image(systemName: isSelected ? "checkmark.circle" : type.iconName)
                        .font(.system(size: 12))
                        .foregroundColor(iconColor)
                        .frame(width: 16)
                }
                
                // 声音名称
                Text(type.displayName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(isLocked ? .secondary : .primary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 5)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.primary.opacity(0.1))
                .opacity(isSelected ? 1 : 0)
        )
    }
}

// MARK: - Music Item View
struct MusicItemView: View {
    let music: MusicType
    let isLocked: Bool
    let isSelected: Bool
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                // 状态图标
                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(width: 16)
                } else {
                    Image(systemName: isSelected ? "checkmark.circle" : music.iconName)
                        .font(.system(size: 12))
                        .foregroundColor(iconColor)
                        .frame(width: 16)
                }
                
                // 音乐名称
                Text(music.displayName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(isLocked ? .secondary : .primary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 5)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.primary.opacity(0.1))
                .opacity(isSelected ? 1 : 0)
        )
    }
}

// MARK: - Audio List View
struct AudioListView: View {
    @EnvironmentObject private var audioManager: AudioManager
    @EnvironmentObject private var storeManager: StoreManager
    @EnvironmentObject private var configManager: SavedConfigurationManager
    @Environment(\.colorScheme) private var colorScheme
    
    private let freeItemCount = 13
    
    private func isLocked(for type: AudioType) -> Bool {
        guard let index = AudioType.allCases.firstIndex(of: type) else { return false }
        return !storeManager.isPro && index >= freeItemCount
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(AudioType.allCases) { type in
                    AudioItemView(
                        type: type,
                        isLocked: isLocked(for: type),
                        isSelected: audioManager.selectedTypes.contains(type),
                        iconColor: colorScheme == .dark ? .white : .black
                    ) {
                        if isLocked(for: type) {
                            PurchaseWindowManager.shared.showPurchaseWindow(
                                storeManager: storeManager,
                                configManager: configManager
                            )
                        } else {
                            audioManager.toggleSound(type)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .frame(width: 200)
        .frame(maxHeight: 400)
    }
}

// MARK: - Music List View
struct MusicListView: View {
    @EnvironmentObject private var audioManager: AudioManager
    @EnvironmentObject private var storeManager: StoreManager
    @EnvironmentObject private var configManager: SavedConfigurationManager
    @Environment(\.colorScheme) private var colorScheme
    
    private let freeItemCount = 3
    
    private func isLocked(for music: MusicType) -> Bool {
        guard let index = MusicType.allCases.firstIndex(of: music) else { return false }
        return !storeManager.isPro && index >= freeItemCount
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(MusicType.allCases) { music in
                    MusicItemView(
                        music: music,
                        isLocked: isLocked(for: music),
                        isSelected: audioManager.selectedMusic == music,
                        iconColor: colorScheme == .dark ? .white : .black
                    ) {
                        if isLocked(for: music) {
                            PurchaseWindowManager.shared.showPurchaseWindow(
                                storeManager: storeManager,
                                configManager: configManager
                            )
                        } else {
                            audioManager.toggleMusic(music)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .frame(width: 200)
        .frame(maxHeight: 400)
    }
}
