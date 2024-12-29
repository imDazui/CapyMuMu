import SwiftUI


struct ActiveSoundView: View {
    let type: AudioType
    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovering = false
    
    private var iconColor: Color {
        if isHovering {
            return .red
        }
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // 声音图标/删除按钮
            Button(action: {
                if isHovering {
                    audioManager.toggleSound(type)
                }
            }) {
                Image(systemName: isHovering ? "xmark" : type.iconName)
                    .font(.system(size: 12))  // 统一图标大小
                    .foregroundColor(iconColor)
                    .frame(width: 20, height: 20)  // 固定框架大小
                    .padding(.trailing, 3)
            }
            .buttonStyle(.plain)
            
            // 声音名称
            Text(type.displayName)
            
            Spacer()
            
            // 自定义音量滑块
            CustomVolumeSlider(
                value: Binding(
                    get: { audioManager.volumes[type] ?? 0 },
                    set: { audioManager.updateVolume($0, for: type) }
                )
            )
            .frame(width: 180)
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}


// MARK: - Active Music View
struct ActiveMusicView: View {
    let music: MusicType
    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovering = false
    
    private var iconColor: Color {
        if isHovering {
            return .red
        }
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // 音乐图标/删除按钮
            Button(action: {
                if isHovering {
                    audioManager.selectedMusic = nil
                    audioManager.stopMusic()
                }
            }) {
                Image(systemName: isHovering ? "xmark" : music.iconName)
                    .font(.system(size: 12))
                    .foregroundColor(iconColor)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 3)
            }
            .buttonStyle(.plain)
            
            // 音乐名称
            Text(music.displayName)
            
            Spacer()
            
            // 音量滑块
            CustomVolumeSlider(
                value: Binding(
                    get: { audioManager.musicVolume },
                    set: { audioManager.musicVolume = $0 }
                )
            )
            .frame(width: 180)
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}



// MARK: - Custom Volume Slider
struct CustomVolumeSlider: View {
    @Binding var value: Float
    @Environment(\.colorScheme) private var colorScheme
    @GestureState private var isDragging: Bool = false
    @State private var localValue: Float
    
    private let trackHeight: CGFloat = 2
    private let thumbSize: CGFloat = 10
    
    init(value: Binding<Float>) {
        self._value = value
        self._localValue = State(initialValue: value.wrappedValue)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景线条
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: trackHeight)
                    .cornerRadius(trackHeight / 2)
                
                // 已选择部分
                Rectangle()
                    .fill(colorScheme == .dark ? .white : .blue)
                    .frame(width: max(0, min(geometry.size.width * CGFloat(localValue), geometry.size.width)), height: trackHeight)
                    .cornerRadius(trackHeight / 2)
                
                // 滑块圆点
                Circle()
                    .fill(colorScheme == .dark ? .white : .blue)
                    .frame(width: thumbSize, height: thumbSize)
                    .position(x: max(thumbSize/2, min(geometry.size.width * CGFloat(localValue), geometry.size.width - thumbSize/2)),
                            y: geometry.size.height / 2)
                    .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isDragging) { value, state, _ in
                        state = true
                    }
                    .onChanged { gesture in
                        let newValue = Float(gesture.location.x / geometry.size.width)
                        localValue = max(0, min(1, newValue))
                        value = localValue
                    }
            )
        }
        .frame(height: thumbSize)
    }
}