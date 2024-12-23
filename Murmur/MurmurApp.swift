import SwiftUI
import ServiceManagement
import AppKit
import AVFoundation

// MARK: - Audio Models
enum AudioType: String, CaseIterable, Identifiable {
    case beach = "Beach"
    case birds = "Birds"
    case dryer = "Dryer"
    case fire = "Fire"
    case forest_waterfall = "Forest_waterfall"
    case humans = "Humans"
    case ocean = "Ocean"
    case rain = "Rain"
    case storm = "Storm"
    case stream = "Stream"
    case thunder = "Thunder"
    case underwater = "Underwater"
    case waves = "Waves"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .beach: return "海滩"
        case .birds: return "鸟鸣"
        case .dryer: return "烘干机"
        case .fire: return "火焰"
        case .forest_waterfall: return "森林瀑布"
        case .humans: return "人声"
        case .ocean: return "海洋"
        case .rain: return "下雨"
        case .storm: return "暴风雨"
        case .stream: return "溪流"
        case .thunder: return "雷声"
        case .underwater: return "水下"
        case .waves: return "海浪"
        }
    }
}

// MARK: - Time Models
enum TimeLimit: String, CaseIterable, Identifiable {
    case unlimited = "不限"
    case minutes10 = "10分钟"
    case minutes25 = "25分钟"
    case hour1 = "1小时"
    case hour2 = "2小时"
    
    var id: String { rawValue }
    
    var seconds: TimeInterval {
        switch self {
        case .unlimited: return .infinity
        case .minutes10: return 10 * 60
        case .minutes25: return 25 * 60
        case .hour1: return 60 * 60
        case .hour2: return 2 * 60 * 60
        }
    }
}

// MARK: - Audio Manager
class AudioManager: ObservableObject {
    @Published var selectedTypes: Set<AudioType> = []
    @Published var volumes: [AudioType: Float] = [:]
    @Published var isPlaying: Bool = false
    @Published var selectedTimeLimit: TimeLimit = .unlimited
    @Published var remainingTime: TimeInterval = 0
    
    private var players: [AudioType: AVAudioPlayer] = [:]
    private var timer: Timer?
    private var countdownTimer: Timer?
    
    init() {
        setupAudioPlayers()
    }
    
    private func setupAudioPlayers() {
        print("\n=== Setting up Audio Players ===")
        print("Bundle path: \(Bundle.main.bundlePath)")
        
        for type in AudioType.allCases {
            print("\nSetting up player for \(type.rawValue)")
            
            // 尝试多个可能的路径
            var audioURL: URL?
            
            // 1. 尝试直接从 Bundle 加载
            if let url1 = Bundle.main.url(forResource: type.rawValue, withExtension: "mp3") {
                audioURL = url1
                print("Found audio file in bundle root: \(url1.path)")
            }
            // 2. 尝试从 Resources/Audio 目录加载
            else if let url2 = Bundle.main.url(forResource: type.rawValue,
                                             withExtension: "mp3",
                                             subdirectory: "Resources/Audio") {
                audioURL = url2
                print("Found audio file in Resources/Audio: \(url2.path)")
            }
            // 3. 尝试从 Audio 目录加载
            else if let url3 = Bundle.main.url(forResource: type.rawValue,
                                             withExtension: "mp3",
                                             subdirectory: "Audio") {
                audioURL = url3
                print("Found audio file in Audio: \(url3.path)")
            }
            
            if let url = audioURL {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    print("Created player for \(type.rawValue)")
                    print("Player duration: \(player.duration) seconds")
                    
                    player.numberOfLoops = -1
                    player.prepareToPlay()
                    players[type] = player
                    volumes[type] = 0.5
                    
                    // 测试播放器是否正常工作
                    player.play()
                    player.stop()
                    print("Player test successful")
                } catch {
                    print("Failed to create player for \(type.rawValue): \(error)")
                }
            } else {
                print("Could not find audio file for \(type.rawValue)")
            }
        }
        
        print("\nTotal players created: \(players.count)")
    }
    
    func toggleSound(_ type: AudioType) {
        print("\nToggling sound for \(type.rawValue)")
        if selectedTypes.contains(type) {
            print("Removing \(type.rawValue) from selection")
            selectedTypes.remove(type)
            stopSound(type)
            isPlaying = !selectedTypes.isEmpty
        } else {
            print("Adding \(type.rawValue) to selection")
            selectedTypes.insert(type)
            playSound(type)
            isPlaying = true
        }
        print("Current playing state: \(isPlaying)")
    }
    
    func playSound(_ type: AudioType) {
        print("\nAttempting to play \(type.rawValue)")
        guard let player = players[type] else {
            print("Error: No player found for \(type.rawValue)")
            return
        }
        
        guard let volume = volumes[type] else {
            print("Error: No volume setting for \(type.rawValue)")
            return
        }
        
        player.volume = volume
        if !player.isPlaying {
            player.currentTime = 0
            let success = player.play()
            print("\(type.rawValue) playback started: \(success)")
            print("Player state - isPlaying: \(player.isPlaying), volume: \(player.volume), currentTime: \(player.currentTime)")
        } else {
            print("\(type.rawValue) is already playing")
        }
    }
    
    func stopSound(_ type: AudioType) {
        if let player = players[type] {
            player.stop()
            player.currentTime = 0
            print("Stopped playing \(type.rawValue)")
        }
    }
    
    func updateVolume(_ volume: Float, for type: AudioType) {
        volumes[type] = volume
        if let player = players[type], selectedTypes.contains(type) {
            player.volume = volume
            print("Updated volume for \(type.rawValue): \(volume)")
        }
    }
    
    func togglePlayback() {
        isPlaying.toggle()
        if isPlaying {
            selectedTypes.forEach { playSound($0) }
            startTimer()
            print("Started playing all selected sounds")
        } else {
            stopAll()
            print("Stopped all sounds")
        }
    }
    
    func startTimer() {
        stopTimer()
        
        guard selectedTimeLimit != .unlimited else {
            remainingTime = 0
            return
        }
        
        remainingTime = selectedTimeLimit.seconds
        
        // 倒计时更新
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            }
        }
        
        // 停止计时器
        timer = Timer.scheduledTimer(withTimeInterval: selectedTimeLimit.seconds, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.stopAll()
            }
        }
        
        print("Starting timer for \(selectedTimeLimit.rawValue)")
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingTime = 0
    }
    
    func stopAll() {
        isPlaying = false
        selectedTypes.forEach { stopSound($0) }
        stopTimer()
    }
    
    // 简化的随机选择方法
    func randomSelectAndPlay() {
        // 停止当前播放
        stopAll()
        selectedTypes.removeAll()
        
        // 随机选择2-5个声音
        let count = Int.random(in: 2...5)
        let allTypes = Array(AudioType.allCases)
        let shuffled = allTypes.shuffled()
        
        // 选择并设置音量
        for type in shuffled.prefix(count) {
            selectedTypes.insert(type)
            volumes[type] = Float.random(in: 0.3...0.7)
        }
        
        // 自动开始播放
        isPlaying = true
        selectedTypes.forEach { playSound($0) }
        startTimer()
    }
}

// MARK: - Menu Views
struct AudioListView: View {
    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(AudioType.allCases) { type in
                Button(action: {
                    audioManager.toggleSound(type)
                }) {
                    HStack(spacing: 8) {
                        // 状态图标
                        Image(systemName: audioManager.selectedTypes.contains(type) ? "checkmark.circle" : "circle")
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
                .padding(.horizontal, 5)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.primary.opacity(0.1))
                        .opacity(audioManager.selectedTypes.contains(type) ? 1 : 0)
                )
            }
        }
        .padding(.vertical, 4)
    }
    
    private var iconColor: Color {
        colorScheme == .dark ? .white : .blue
    }
}

struct ActiveSoundView: View {
    let type: AudioType
    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovering = false
    
    private var iconColor: Color {
        if isHovering {
            return .red
        }
        return colorScheme == .dark ? .white : .blue
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // 声音图标/删除按钮
            Button(action: {
                if isHovering {
                    audioManager.toggleSound(type)
                }
            }) {
                Image(systemName: isHovering ? "xmark" : "music.note")
                    .foregroundColor(iconColor)
                    .frame(width: 20)
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

struct MenuItemView: View {
    let title: String
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 5)
        .padding(.horizontal, 19)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue.opacity(isHovering ? 0.8 : 0))
        )
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

struct MenuToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button(action: {
            isOn.toggle()
            action()
        }) {
            HStack {
                Image(systemName: isOn ? "checkmark" : "")
                    .foregroundColor(.primary)
                    .frame(width: 0)  // 恢复合理的宽度
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue.opacity(isHovering ? 0.8 : 0))
        )
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
                    .fill(colorScheme == .dark ? Color.white : Color.blue)
                    .frame(width: max(0, min(geometry.size.width * CGFloat(localValue), geometry.size.width)), height: trackHeight)
                    .cornerRadius(trackHeight / 2)
                
                // 滑块圆点
                Circle()
                    .fill(colorScheme == .dark ? Color.white : Color.blue)
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

// MARK: - Menu Content View
struct MenuContentView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingTimeOptions = false
    
    private var iconColor: Color {
        colorScheme == .dark ? .white : .blue
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        if seconds <= 0 {
            return ""
        }
        
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d:%02d", hours, minutes, secs)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // 标题和播放控制
            HStack {
                Text("Murmur")
                    .font(.headline)
                
                Spacer()
                
                // 倒计时显示
                Text(formatTime(audioManager.remainingTime))
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(iconColor)
                
                // 时间选择按钮
                Button(action: {
                    showingTimeOptions.toggle()
                }) {
                    Image(systemName: "timer")
                        .font(.title2)
                        .foregroundColor(iconColor)
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showingTimeOptions, arrowEdge: .bottom) {
                    VStack(spacing: 8) {
                        ForEach(TimeLimit.allCases) { limit in
                            Button(action: {
                                audioManager.selectedTimeLimit = limit
                                if audioManager.isPlaying {
                                    audioManager.startTimer()
                                }
                                showingTimeOptions = false
                            }) {
                                Text(limit.rawValue)
                                    .frame(width: 80)
                            }
                            .buttonStyle(.plain)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.primary.opacity(
                                        audioManager.selectedTimeLimit == limit ? 0.1 : 0
                                    ))
                            )
                        }
                    }
                    .padding(8)
                }
                
                // 随机按钮
                Button(action: {
                    audioManager.randomSelectAndPlay()
                }) {
                    Image(systemName: "shuffle")
                        .font(.title2)
                        .foregroundColor(iconColor)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    audioManager.togglePlayback()
                }) {
                    Image(systemName: audioManager.isPlaying ? "pause" : "play")
                        .font(.title2)
                        .foregroundColor(iconColor)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Divider()
                .padding(.horizontal, 9)
            
            if audioManager.selectedTypes.isEmpty {
                Text("请添加声音")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                // 活跃的音频列表
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(audioManager.selectedTypes).sorted(by: { $0.displayName < $1.displayName })) { type in
                            ActiveSoundView(type: type)
                        }
                    }
                }
            }
            
            Divider()
                .padding(.horizontal, 9)
            
            // 声音选择菜单
            Menu {
                AudioListView()
            } label: {
                HStack {
                    Text("声音")
                    Spacer()
                }
            }
            .menuStyle(.borderlessButton)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal, 9)
            
            // 底部菜单区域
            VStack(spacing: 0) {
                MenuToggleView(
                    title: "开机启动",
                    isOn: $appState.launchAtLogin,
                    action: {
                        appState.toggleLaunchAtLogin()
                    }
                )
                
                MenuItemView(
                    title: "退出",
                    action: {
                        NSApplication.shared.terminate(nil)
                    }
                )
            }
            .padding(.bottom, 8)
        }
        .frame(width: 300)
        .padding(5)
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var launchAtLogin: Bool = false
    
    init() {
        // 检查是否开机启动
        launchAtLogin = SMAppService.mainApp.status == .enabled
    }
    
    func toggleLaunchAtLogin() {
        do {
            if launchAtLogin {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to set launch at login: \(error)")
        }
    }
}

// MARK: - App
@main
struct MurmurApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var audioManager = AudioManager()
    
    var body: some Scene {
        MenuBarExtra {
            MenuContentView()
                .environmentObject(appState)
                .environmentObject(audioManager)
        } label: {
            Image(systemName: audioManager.isPlaying ? "waveform.circle.fill" : "waveform")
                .symbolRenderingMode(.hierarchical)
        }
        .menuBarExtraStyle(.window)
    }
}
