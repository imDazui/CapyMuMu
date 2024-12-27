import SwiftUI
import ServiceManagement
import AppKit
import AVFoundation

// MARK: - Audio Models
enum AudioType: String, CaseIterable, Identifiable, Codable {
    case birds = "Birds and Crickets"
    case blizzard = "Blizzard Winter"
    case cat = "Cat Purring"
    case fire = "Fire Bonfire"
    case heartbeat = "Heartbeat"
    case ocean = "Ocean Waves"
    case rain = "Rainy Day"
    case metro = "Saint Petersburg Metro"
    case waves = "Sea Waves"
    case train = "Train Passing By"
    case rainforest = "Tropical Rainforest"
    case wind = "Wind Noise"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .birds: return "鸟鸣蟋蟀"
        case .blizzard: return "暴风雪"
        case .cat: return "猫咪呼噜"
        case .fire: return "篝火"
        case .heartbeat: return "心跳"
        case .ocean: return "海浪"
        case .rain: return "雨天"
        case .metro: return "地铁"
        case .waves: return "海浪"
        case .train: return "火车"
        case .rainforest: return "热带雨林"
        case .wind: return "风声"
        }
    }
    
    var iconName: String {
        switch self {
        case .birds: return "bird"
        case .blizzard: return "snowflake"
        case .cat: return "cat"
        case .fire: return "flame"
        case .heartbeat: return "heart"
        case .ocean: return "water.waves"
        case .rain: return "cloud.rain"
        case .metro: return "tram"
        case .waves: return "water.waves"
        case .train: return "train.side.front.car"
        case .rainforest: return "leaf"
        case .wind: return "wind"
        }
    }
}

// MARK: - Time Models
enum TimeLimit: String, CaseIterable, Identifiable, Codable {
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

// MARK: - Audio Player Pair
class AudioPlayerPair {
    private var player1: AVAudioPlayer
    private var player2: AVAudioPlayer
    private var activePlayer: Int = 1
    private var fadeTimer: Timer?
    private var fadeInOutTimer: Timer?
    private let crossfadeDuration: TimeInterval = 3.0
    private var targetVolume: Float = 0.5
    
    var volume: Float {
        get { targetVolume }
        set {
            targetVolume = newValue
            if !isInFadeTransition {
                updateVolume()
            }
        }
    }
    
    private var isInFadeTransition = false
    
    private func updateVolume() {
        if activePlayer == 1 {
            player1.volume = targetVolume
        } else {
            player2.volume = targetVolume
        }
    }
    
    var isPlaying: Bool {
        player1.isPlaying || player2.isPlaying
    }
    
    init?(url: URL) {
        guard let player1 = try? AVAudioPlayer(contentsOf: url),
              let player2 = try? AVAudioPlayer(contentsOf: url) else {
            return nil
        }
        self.player1 = player1
        self.player2 = player2
        
        // Configure both players
        player1.numberOfLoops = 0
        player2.numberOfLoops = 0
        player1.prepareToPlay()
        player2.prepareToPlay()
    }
    
    func play() {
        guard !isPlaying else { return }
        
        print("Starting playback with fade in")
        isInFadeTransition = true
        
        // 开始时将音量设为 0 并逐渐淡入
        let currentPlayer = activePlayer == 1 ? player1 : player2
        currentPlayer.volume = 0
        currentPlayer.play()
        
        performInitialFadeIn(for: currentPlayer)
    }
    
    private func performInitialFadeIn(for player: AVAudioPlayer) {
        print("Performing initial fade in")
        let fadeSteps = 60 // 增加步数使过渡更平滑
        let stepDuration = crossfadeDuration / TimeInterval(fadeSteps)
        var step = 0
        
        fadeInOutTimer?.invalidate()
        fadeInOutTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            step += 1
            let progress = Float(step) / Float(fadeSteps)
            let newVolume = self.targetVolume * progress
            player.volume = newVolume
            
            print("Fade in step \(step)/\(fadeSteps), volume: \(newVolume)")
            
            if step >= fadeSteps {
                timer.invalidate()
                self.isInFadeTransition = false
                player.volume = self.targetVolume
                print("Fade in complete, final volume: \(player.volume)")
                self.scheduleCrossfade()
            }
        }
    }
    
    func stop() {
        guard isPlaying else { return }
        
        fadeTimer?.invalidate()
        fadeTimer = nil
        
        // 执行淡出效果
        performFadeOut()
    }
    
    private func performFadeOut() {
        isInFadeTransition = true
        let fadeSteps = 50
        let stepDuration = crossfadeDuration / 2 / TimeInterval(fadeSteps) // 淡出用一半时间
        var step = 0
        
        let currentPlayer = activePlayer == 1 ? player1 : player2
        let initialVolume = currentPlayer.volume
        
        fadeInOutTimer?.invalidate()
        fadeInOutTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            step += 1
            let progress = 1 - Float(step) / Float(fadeSteps)
            currentPlayer.volume = initialVolume * progress
            
            if step >= fadeSteps {
                timer.invalidate()
                self.isInFadeTransition = false
                currentPlayer.stop()
                currentPlayer.currentTime = 0
                self.fadeInOutTimer = nil
            }
        }
    }
    
    private func scheduleCrossfade() {
        let currentPlayer = activePlayer == 1 ? player1 : player2
        let nextPlayer = activePlayer == 1 ? player2 : player1
        
        // Start the next player slightly before the current one ends
        let crossfadeStart = currentPlayer.duration - crossfadeDuration
        
        fadeTimer?.invalidate()
        fadeTimer = Timer.scheduledTimer(withTimeInterval: crossfadeStart, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            // Start the next player
            nextPlayer.currentTime = 0
            nextPlayer.volume = 0
            nextPlayer.play()
            
            // Perform the crossfade
            self.performCrossfade(fadeOut: currentPlayer, fadeIn: nextPlayer)
        }
    }
    
    private func performCrossfade(fadeOut: AVAudioPlayer, fadeIn: AVAudioPlayer) {
        isInFadeTransition = true
        let fadeSteps = 60 // 增加步数使过渡更平滑
        let stepDuration = crossfadeDuration / TimeInterval(fadeSteps)
        var step = 0
        
        fadeInOutTimer?.invalidate()
        fadeInOutTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            step += 1
            let progress = Float(step) / Float(fadeSteps)
            
            fadeOut.volume = self.targetVolume * (1 - progress)
            fadeIn.volume = self.targetVolume * progress
            
            if step >= fadeSteps {
                timer.invalidate()
                self.isInFadeTransition = false
                fadeOut.stop()
                fadeOut.currentTime = 0
                self.activePlayer = self.activePlayer == 1 ? 2 : 1
                self.scheduleCrossfade()
                self.fadeInOutTimer = nil
            }
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
    
    private var playerPairs: [AudioType: AudioPlayerPair] = [:]
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
                if let playerPair = AudioPlayerPair(url: url) {
                    playerPairs[type] = playerPair
                    volumes[type] = 0.5
                    print("Created player pair for \(type.rawValue)")
                    
                    // Test the player pair
                    playerPair.play()
                    playerPair.stop()
                    print("Player pair test successful")
                } else {
                    print("Failed to create player pair for \(type.rawValue)")
                }
            } else {
                print("Could not find audio file for \(type.rawValue)")
            }
        }
        
        print("\nTotal player pairs created: \(playerPairs.count)")
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
        guard let playerPair = playerPairs[type],
              let volume = volumes[type] else {
            print("Error: No player pair or volume setting found for \(type.rawValue)")
            return
        }
        
        playerPair.volume = volume
        if !playerPair.isPlaying {
            playerPair.play()
            print("\(type.rawValue) playback started")
        } else {
            print("\(type.rawValue) is already playing")
        }
    }
    
    func stopSound(_ type: AudioType) {
        if let playerPair = playerPairs[type] {
            playerPair.stop()
            print("Stopped playing \(type.rawValue)")
        }
    }
    
    func updateVolume(_ volume: Float, for type: AudioType) {
        volumes[type] = volume
        if let playerPair = playerPairs[type], selectedTypes.contains(type) {
            playerPair.volume = volume
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
        let count = Int.random(in: 1...3)
        let allTypes = Array(AudioType.allCases)
        let shuffled = allTypes.shuffled()
        
        // 选择并设置音量
        for type in shuffled.prefix(count) {
            selectedTypes.insert(type)
            volumes[type] = Float.random(in: 0.1...0.3)
        }
        
        // 自动开始播放
        isPlaying = true
        selectedTypes.forEach { playSound($0) }
        startTimer()
    }
    
    func loadConfiguration(_ config: SavedConfiguration) {
        // 停止当前播放
        stopAll()
        
        // 设置新的配置
        selectedTypes = Set(config.audioTypes)
        selectedTimeLimit = config.timeLimit
        
        // 为每个音频类型设置默认音量
        for type in config.audioTypes {
            if volumes[type] == nil {
                volumes[type] = 0.5
            }
        }
        
        // 开始播放
        startPlaying()
    }
    
    private func startPlaying() {
        isPlaying = true
        selectedTypes.forEach { playSound($0) }
        startTimer()
    }
}

// MARK: - Saved Configuration Model
struct SavedConfiguration: Codable, Identifiable {
    let id: UUID
    let audioTypes: [AudioType]
    let timeLimit: TimeLimit
    let timestamp: Date
    
    var formattedTime: String {
        switch timeLimit {
        case .unlimited: return "不限"
        case .minutes10: return "10分钟"
        case .minutes25: return "25分钟"
        case .hour1: return "1小时"
        case .hour2: return "2小时"
        }
    }
}

class SavedConfigurationManager: ObservableObject {
    @Published var savedConfigurations: [SavedConfiguration] = []
    private let saveKey = "savedConfigurations"
    
    init() {
        loadConfigurations()
    }
    
    func saveConfiguration(audioTypes: [AudioType], timeLimit: TimeLimit) {
        let configuration = SavedConfiguration(
            id: UUID(),
            audioTypes: audioTypes,
            timeLimit: timeLimit,
            timestamp: Date()
        )
        savedConfigurations.insert(configuration, at: 0)
        saveConfigurations()
    }
    
    func deleteConfiguration(_ config: SavedConfiguration) {
        savedConfigurations.removeAll { $0.id == config.id }
        saveConfigurations()
    }
    
    private func loadConfigurations() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([SavedConfiguration].self, from: data) {
            savedConfigurations = decoded
        }
    }
    
    private func saveConfigurations() {
        if let encoded = try? JSONEncoder().encode(savedConfigurations) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
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
        .frame(width: 200)
    }
    
    private var iconColor: Color {
        colorScheme == .dark ? .white : .black
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
        .padding(.horizontal, 18)
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
                    .font(.system(size: 10))  // 统一图标大小
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

// MARK: - Save Menu View
struct SaveMenuView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var audioManager: AudioManager
    @StateObject private var configManager = SavedConfigurationManager()
    @Environment(\.colorScheme) private var colorScheme
    @State private var hoveredConfigId: UUID? = nil
    
    private var iconColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                let audioTypes = Array(audioManager.selectedTypes)
                configManager.saveConfiguration(
                    audioTypes: audioTypes,
                    timeLimit: audioManager.selectedTimeLimit
                )
            }) {
                Label("保存", systemImage: "plus")
            }
            .buttonStyle(.plain)
            
            if !configManager.savedConfigurations.isEmpty {
                Divider()
                
                ForEach(configManager.savedConfigurations) { config in
                    HStack(spacing: 4) {
                        // 删除按钮
                        if hoveredConfigId == config.id {
                            Button(action: {
                                configManager.deleteConfiguration(config)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .imageScale(.small)
                            }
                            .buttonStyle(.plain)
                            .transition(.opacity)
                        }
                        
                        Button(action: {
                            audioManager.loadConfiguration(config)
                            isPresented = false  // 关闭菜单
                        }) {
                            HStack {
                                // 声音图标
                                HStack(spacing: 2) {
                                    ForEach(config.audioTypes, id: \.self) { type in
                                        Image(systemName: type.iconName)
                                    }
                                }
                                Spacer()
                                Text(config.formattedTime)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .onHover { isHovered in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            hoveredConfigId = isHovered ? config.id : nil
                        }
                    }
                }
            }
        }
        .padding(8)
        .frame(minWidth: 200)
    }
}

// MARK: - Sound Menu View
struct SoundMenuView: View {
    @EnvironmentObject private var audioManager: AudioManager
    @Binding var showAudioList: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    private var secondaryColor: Color {
        colorScheme == .dark ? .gray : .secondary
    }
    
    var body: some View {
        Button(action: {
            showAudioList.toggle()
        }) {
            HStack {
                Text("声音")
                    .foregroundColor(.primary)
                    .frame(alignment: .leading)
                
                Spacer()
                
                Text("\(audioManager.selectedTypes.count)/\(AudioType.allCases.count)")
                    .font(.caption)
                    .foregroundColor(secondaryColor)
                    .frame(alignment: .trailing)
                
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .background(Color.clear)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
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

// MARK: - Menu Content View
struct MenuContentView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingTimeOptions = false
    @State private var showAudioList = false
    @State private var showSaveMenu = false
    @State private var isHovering = false
    @State private var isTimerHovering = false
    @State private var isRandomSelectHovering = false
    @State private var isSaveHovering = false

    private var iconColor: Color {
        colorScheme == .dark ? .white : .black
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
                
                // 播放按钮
                Button(action: {
                    audioManager.togglePlayback()
                }) {
                    Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .aspectRatio(contentMode: .fit)
                        .font(.title2)
                        .foregroundColor(iconColor)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.primary.opacity(isHovering ? 0.1 : 0))
                        )
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isHovering = hovering
                    }
                }
                
                Spacer()
                    .frame(width: 1)
                
                // 时间选择按钮
                Button(action: {
                    showingTimeOptions.toggle()
                }) {
                    Image(systemName: "timer")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                        .font(.title2)
                        .foregroundColor(iconColor)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.primary.opacity(isTimerHovering ? 0.1 : 0))
                        )
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isTimerHovering = hovering
                    }
                }
                
                Spacer()
                    .frame(width: 1)
                
                // 倒计时显示
                Text(formatTime(audioManager.remainingTime))
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(iconColor.opacity(0.75))
                
                Spacer()

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
                        .resizable()
                        .frame(width: 14, height: 14)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                        .font(.title2)
                        .foregroundColor(iconColor)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.primary.opacity(isRandomSelectHovering ? 0.1 : 0))
                        )
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isRandomSelectHovering = hovering
                    }
                }
                Spacer()
                    .frame(width: 1)
                
                // 保存按钮
                Button(action: {
                    showSaveMenu.toggle()
                }) {
                    Image(systemName: "folder")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                        .font(.title2)
                        .foregroundColor(iconColor)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.primary.opacity(isSaveHovering ? 0.1 : 0))
                        )
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSaveHovering = hovering
                    }
                }
                .popover(isPresented: $showSaveMenu, arrowEdge: .bottom) {
                    SaveMenuView(isPresented: $showSaveMenu)
                }
                
            }
            .padding(.horizontal, 8)
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
            
            // 声音选择区域
            SoundMenuView(showAudioList: $showAudioList)
                .padding(.vertical, 5)  // 只保留垂直内边距
                .popover(isPresented: $showAudioList, arrowEdge: .bottom) {
                    AudioListView()
                }
            
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
            .padding(.bottom, 0)
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
struct CapyMuMuApp: App {
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
