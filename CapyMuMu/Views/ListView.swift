import SwiftUI



// MARK: - Menu Views
struct AudioListView: View {
    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(AudioType.allCases) { type in
                    Button(action: {
                        audioManager.toggleSound(type)
                    }) {
                        HStack(spacing: 8) {
                            // 状态图标
                            Image(systemName: audioManager.selectedTypes.contains(type) ? "checkmark.circle" : type.iconName)
                                .font(.system(size: 12))
                                .foregroundColor(iconColor)
                                .frame(width: 16)
                            
                            // 声音名称
                            Text(type.displayName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.primary.opacity(0.1))
                            .opacity(audioManager.selectedTypes.contains(type) ? 1 : 0)
                    )
                }
            }
            .padding(.vertical, 4)
        }
        .frame(width: 200)
        .frame(maxHeight: 400)
    }
    
    private var iconColor: Color {
        colorScheme == .dark ? .white : .black
    }
}

// MARK: - Music List View
struct MusicListView: View {
    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(MusicType.allCases) { music in
                    Button(action: {
                        audioManager.toggleMusic(music)
                    }) {
                        HStack(spacing: 8) {
                            // 状态图标
                            Image(systemName: audioManager.selectedMusic == music ? "checkmark.circle" : music.iconName)
                                .font(.system(size: 12))
                                .foregroundColor(iconColor)
                                .frame(width: 16)
                            
                            // 音乐名称
                            Text(music.displayName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.primary.opacity(0.1))
                            .opacity(audioManager.selectedMusic == music ? 1 : 0)
                    )
                }
            }
        }
        .padding(.vertical, 4)
        .frame(width: 200)
        .frame(maxHeight: 400)
    }
    
    private var iconColor: Color {
        colorScheme == .dark ? .white : .black
    }
}
