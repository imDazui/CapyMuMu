import SwiftUI
import ServiceManagement
import AppKit
import AVFoundation

// MARK: - Audio Models
enum AudioType: String, CaseIterable, Identifiable, Codable {
    case beach = "sound-audio-beach"
    case birds = "sound-audio-birds"
    case campfire = "sound-audio-campfire"
    case desert = "sound-audio-desert"
    case forest = "sound-audio-forest"
    case lake = "sound-audio-lake"
    case meadow = "sound-audio-meadow"
    case nightDeep = "sound-audio-nightdeep"
    case nightLight = "sound-audio-nightlight"
    case rain = "sound-audio-rain"
    case river = "sound-audio-river"
    case seagulls = "sound-audio-seagulls"
    case thunder = "sound-audio-thunder"
    case underwater = "sound-audio-underwater"
    case whales = "sound-audio-whales"
    case cat = "sound-audio-cat"
    case bookPageTurning = "sound-audio-bookpageturning"
    case cafe = "sound-audio-cafe"
    case ventilator = "sound-audio-ventilator"
    case vinyl = "sound-audio-vinyl"
    case windBells = "sound-audio-windbells"
    case writingWithPencil = "sound-audio-writingwithpencil"
    case train = "sound-audio-train"
    case spaceship = "sound-audio-spaceship"
    case teapotBoiling = "sound-audio-teapotboiling"
    case slime = "sound-audio-slime"
    case oldTickingClock = "sound-audio-oldtickingclock"
    case grassSprinkler = "sound-audio-grasssprinkler"
    case iceCubes = "sound-audio-icecubes"
    case keyboard = "sound-audio-keyboard"
    case fan = "sound-audio-fan"
    case fizzyDrink = "sound-audio-fizzydrink"
    case blower = "sound-audio-blower"
    case aquarium = "sound-audio-aquarium"
    case airplane = "sound-audio-airplane"
    case bubbleWrap = "sound-audio-bubblewrap"
    case walkInTheWoods = "sound-audio-walkinthewoods"
    case walkInTheWater = "sound-audio-walkinthewater"
    case walkOnLeaves = "sound-audio-walkonleaves"
    case walkOnSnow = "sound-audio-walkonsnow"
    case whiteNoise = "sound-audio-whitenoise"
    case pinkNoise = "sound-audio-pinknoise"
    case blueNoise = "sound-audio-bluenoise"
    case brownNoise = "sound-audio-brownnoise"
    case greenNoise = "sound-audio-greennoise"
    case silence = "sound-audio-silence"

    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .airplane: return "飞机"
        case .aquarium: return "水族馆"
        case .beach: return "海滩"
        case .birds: return "鸟鸣"
        case .blower: return "吹风机"
        case .blueNoise: return "蓝噪音"
        case .bookPageTurning: return "翻书声"
        case .brownNoise: return "棕噪音"
        case .bubbleWrap: return "气泡膜"
        case .cafe: return "咖啡馆"
        case .campfire: return "营火"
        case .cat: return "猫咪"
        case .desert: return "沙漠"
        case .fan: return "风扇"
        case .fizzyDrink: return "汽水"
        case .forest: return "森林"
        case .walkInTheWoods: return "树林漫步"
        case .grassSprinkler: return "洒水器"
        case .greenNoise: return "绿噪音"
        case .iceCubes: return "冰块"
        case .keyboard: return "键盘"
        case .lake: return "湖泊"
        case .river: return "河流"
        case .meadow: return "草地"
        case .nightDeep: return "深夜"
        case .nightLight: return "夜晚"
        case .oldTickingClock: return "钟表"
        case .pinkNoise: return "粉噪音"
        case .rain: return "雨声"
        case .seagulls: return "海鸥"
        case .silence: return "寂静"
        case .slime: return "史莱姆"
        case .spaceship: return "太空船"
        case .teapotBoiling: return "烧水壶"
        case .thunder: return "雷声"
        case .train: return "火车"
        case .underwater: return "水下"
        case .ventilator: return "通风扇"
        case .walkInTheWater: return "水中漫步"
        case .vinyl: return "黑胶唱片"
        case .walkOnLeaves: return "落叶漫步"
        case .walkOnSnow: return "雪地漫步"
        case .whales: return "鲸鱼"
        case .whiteNoise: return "白噪音"
        case .windBells: return "风铃"
        case .writingWithPencil: return "铅笔写字"
        }
    }
    
    var iconName: String {
        switch self {
        case .airplane: return "airplane"
        case .aquarium: return "fish"
        case .beach: return "beach.umbrella"
        case .birds: return "bird"
        case .blower: return "wind"
        case .blueNoise, .brownNoise, .greenNoise, .pinkNoise, .whiteNoise: return "waveform"
        case .bookPageTurning: return "book"
        case .bubbleWrap: return "bubble.right"
        case .cafe: return "cup.and.saucer"
        case .campfire: return "flame"
        case .cat: return "cat"
        case .desert: return "sun.max"
        case .fan, .ventilator: return "fan"
        case .fizzyDrink: return "bubbles.and.sparkles"
        case .forest: return "tree"
        case .walkInTheWoods: return "tree"
        case .grassSprinkler: return "sprinkler.and.droplets"
        case .iceCubes: return "cube"
        case .keyboard: return "keyboard"
        case .lake: return "water.waves"
        case .river: return "water.waves"
        case .meadow: return "camera.macro"
        case .nightDeep: return "moon.zzz"
        case .nightLight: return "moon.stars"
        case .oldTickingClock: return "clock"
        case .rain: return "cloud.rain"
        case .seagulls: return "bird.fill"
        case .silence: return "speaker.slash"
        case .slime: return "face.dashed"
        case .spaceship: return "globe.americas"
        case .teapotBoiling: return "humidifier"
        case .thunder: return "cloud.bolt"
        case .train: return "train.side.front.car"
        case .underwater: return "water.waves.and.arrow.trianglehead.down"
        case .walkInTheWater: return "water.waves"
        case .vinyl: return "record.circle"
        case .walkOnLeaves: return "leaf"
        case .walkOnSnow: return "snowflake"
        case .whales: return "fish"
        case .windBells: return "bell"
        case .writingWithPencil: return "pencil"
        }
    }
    
    var fileExtension: String {
        switch self {
        case .silence:
            return "mp3"
        default:
            return "m4a"
        }
    }
}

// MARK: - Music Model
enum MusicType: String, CaseIterable, Identifiable, Codable {
    case balancedbeat = "sound-music-balancedbeat"
    case blissfulbreezes = "sound-music-blissfulbreezes"
    case calmcascades = "sound-music-calmcascades"
    case clearconcentration = "sound-music-clearconcentration"
    case ephemeralease = "sound-music-ephemeralease"
    case etherealechoes = "sound-music-etherealechoes"
    case focusflow = "sound-music-focusflow"
    case gentlegossamer = "sound-music-gentlegossamer"
    case harmonichorizons = "sound-music-harmonichorizons"
    case lavenderlagoon = "sound-music-lavenderlagoon"
    case mellowmoonlight = "sound-music-mellowmoonlight"
    case mysticmist = "sound-music-mysticmist"
    case peacefulparadise = "sound-music-peacefulparadise"
    case purposefulpulse = "sound-music-purposefulpulse"
    case radiantripple = "sound-music-radiantripple"
    case seraphicsymphony = "sound-music-seraphicsymphony"
    case serenesolitude = "sound-music-serenesolitude"
    case solacesway = "sound-music-solacesway"
    case soothingserenity = "sound-music-soothingserenity"
    case steadystream = "sound-music-steadystream"
    case tranquiltwilight = "sound-music-tranquiltwilight"
    case velvetvista = "sound-music-velvetvista"
    case whisperingwaves = "sound-music-whisperingwaves"
    case zenithzone = "sound-music-zenithzone"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .balancedbeat: return "平衡节拍"
        case .blissfulbreezes: return "幸福微风"
        case .calmcascades: return "平静瀑布"
        case .clearconcentration: return "清晰专注"
        case .ephemeralease: return "短暂舒适"
        case .etherealechoes: return "空灵回响"
        case .focusflow: return "专注流"
        case .gentlegossamer: return "轻柔薄纱"
        case .harmonichorizons: return "地平线"
        case .lavenderlagoon: return "薰衣草湖"
        case .mellowmoonlight: return "柔和月光"
        case .mysticmist: return "神秘薄雾"
        case .peacefulparadise: return "宁静天堂"
        case .purposefulpulse: return "目标脉动"
        case .radiantripple: return "光芒涟漪"
        case .seraphicsymphony: return "天使交响"
        case .serenesolitude: return "静谧独处"
        case .solacesway: return "慰藉摇摆"
        case .soothingserenity: return "舒缓宁静"
        case .steadystream: return "稳定流"
        case .tranquiltwilight: return "宁静暮光"
        case .velvetvista: return "天鹅绒景"
        case .whisperingwaves: return "耳语波"
        case .zenithzone: return "天顶区"
        }
    }
    
    var iconName: String {
        "music.note"
    }
    
    var fileExtension: String {
        "m4a"
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
    private let crossfadeDuration: TimeInterval = 0.001  // 增加到 0.3 秒，使过渡更自然
    private let fadeSteps = 1  // 增加步数使过渡更平滑
    private var targetVolume: Float = 0.5  // 默认音量调整为 0.5
    
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
        
        // 开始时将音量设为 0 并逐渐淡入
        let currentPlayer = activePlayer == 1 ? player1 : player2
        currentPlayer.volume = 0
        currentPlayer.play()
        
        performInitialFadeIn(for: currentPlayer)
    }
    
    private func performInitialFadeIn(for player: AVAudioPlayer) {
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
            // 使用 easeInOut 曲线使过渡更平滑
            let smoothProgress = progress < 0.5 
                ? 2 * progress * progress 
                : -1 + (4 - 2 * progress) * progress
            let newVolume = self.targetVolume * smoothProgress
            player.volume = newVolume
            
            if step >= fadeSteps {
                timer.invalidate()
                self.isInFadeTransition = false
                player.volume = self.targetVolume
                self.scheduleCrossfade()
            }
        }
    }
    
    private func performFadeOut() {
        isInFadeTransition = true
        let stepDuration = (crossfadeDuration / 2) / TimeInterval(fadeSteps) // 淡出用一半时间
        var step = 0
        let startVolume = activePlayer == 1 ? player1.volume : player2.volume
        
        fadeInOutTimer?.invalidate()
        fadeInOutTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            step += 1
            let progress = Float(step) / Float(fadeSteps)
            // 使用 easeOut 曲线使淡出更自然
            let smoothProgress = 1 - (1 - progress) * (1 - progress)
            let newVolume = startVolume * (1 - smoothProgress)
            
            if self.activePlayer == 1 {
                self.player1.volume = newVolume
            } else {
                self.player2.volume = newVolume
            }
            
            if step >= fadeSteps {
                timer.invalidate()
                self.isInFadeTransition = false
                if self.activePlayer == 1 {
                    self.player1.stop()
                } else {
                    self.player2.stop()
                }
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
            // 使用 easeInOut 曲线使过渡更平滑
            let smoothProgress = progress < 0.5 
                ? 2 * progress * progress 
                : -1 + (4 - 2 * progress) * progress
            fadeOut.volume = self.targetVolume * (1 - smoothProgress)
            fadeIn.volume = self.targetVolume * smoothProgress
            
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
    
    func stop() {
        guard isPlaying else { return }
        
        fadeTimer?.invalidate()
        fadeTimer = nil
        
        // 执行淡出效果
        performFadeOut()
    }
}

// MARK: - Audio File Management
extension AudioManager {
    // 获取环境音频文件的 URL
    private func getAudioFileURL(_ type: AudioType) -> URL? {
        // 直接从 Resources 目录加载
        if let url = Bundle.main.url(forResource: type.rawValue, withExtension: type.fileExtension) {
            return url
        }
        print("Error: Could not find audio file: \(type.rawValue).\(type.fileExtension)")
        return nil
    }
    
    // 获取音乐文件的 URL
    private func getMusicFileURL(_ music: MusicType) -> URL? {
        // 直接从 Resources 目录加载
        if let url = Bundle.main.url(forResource: music.rawValue, withExtension: "m4a") {
            return url
        }
        print("Error: Could not find music file: \(music.rawValue).m4a")
        return nil
    }
    
    // 播放环境音效
    func playAudio(_ type: AudioType) {
        if let playerPair = playerPairs[type] {
            playerPair.play()
        }
    }
    
    func stopAudio(_ type: AudioType) {
        if let playerPair = playerPairs[type] {
            playerPair.stop()
        }
    }
    
    // 播放音乐
    func playMusic(_ music: MusicType) {
        guard let url = getMusicFileURL(music) else {
            print("Error: Could not find music file: \(music.rawValue).m4a")
            return
        }
        
        // 停止当前正在播放的音乐
        stopMusic()
        
        // 创建新的播放器并开始播放
        if let player = try? AVAudioPlayer(contentsOf: url) {
            musicPlayer = player
            selectedMusic = music
            player.numberOfLoops = -1 // 循环播放
            player.volume = musicVolume
            player.play()
            isPlaying = true
        }
    }
    
    func stopMusic() {
        if let player = musicPlayer {
            player.stop()
            musicPlayer = nil
            isMusicPlaying = false
        }
    }
    
    func stopAll() {
        selectedTypes.forEach { stopAudio($0) }
        stopMusic()
        isPlaying = false
        stopTimer()
    }
}

// MARK: - Audio Manager
class AudioManager: ObservableObject {
    @Published var selectedTypes: Set<AudioType> = []
    @Published var selectedMusic: MusicType? = nil
    @Published var volumes: [AudioType: Float] = [:]
    @Published var musicVolume: Float = 0.5 {
        didSet {
            musicPlayer?.volume = musicVolume
        }
    }
    @Published var isPlaying: Bool = false {
        didSet {
            // 同步音乐播放状态
            isMusicPlaying = isPlaying && selectedMusic != nil
        }
    }
    @Published var isMusicPlaying: Bool = false
    @Published var selectedTimeLimit: TimeLimit = .unlimited
    @Published var remainingTime: TimeInterval = 0
    
    private var playerPairs: [AudioType: AudioPlayerPair] = [:]
    private var musicPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var countdownTimer: Timer?
    
    init() {
        setupAudioPlayers()
    }
    
    private func setupAudioPlayers() {
        // 创建音频播放器
        for type in AudioType.allCases {
            if let url = getAudioFileURL(type) {
                playerPairs[type] = AudioPlayerPair(url: url)
                volumes[type] = 0.5
            }
        }
    }
    
    func toggleSound(_ type: AudioType) {
        if selectedTypes.contains(type) {
            selectedTypes.remove(type)
            stopAudio(type)
        } else {
            selectedTypes.insert(type)
            if isPlaying {
                playAudio(type)
            }
        }
        // 更新播放状态
        if selectedTypes.isEmpty && selectedMusic == nil {
            isPlaying = false
        }
    }
    
    func toggleMusic(_ music: MusicType) {
        if selectedMusic == music {
            selectedMusic = nil
            stopMusic()
        } else {
            if let _ = selectedMusic {
                stopMusic()
            }
            selectedMusic = music
            if isPlaying {
                playMusic(music)
            }
        }
        // 更新播放状态
        if selectedTypes.isEmpty && selectedMusic == nil {
            isPlaying = false
        }
    }
    
    func togglePlayback() {
        isPlaying.toggle()
        if isPlaying {
            // 播放所有选中的音频
            selectedTypes.forEach { playAudio($0) }
            // 播放选中的音乐
            if let music = selectedMusic {
                playMusic(music)
            }
            startTimer()
        } else {
            stopAll()
        }
    }
    
    func updateVolume(_ volume: Float, for type: AudioType) {
        volumes[type] = volume
        if let playerPair = playerPairs[type], selectedTypes.contains(type) {
            playerPair.volume = volume
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
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingTime = 0
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
        selectedTypes.forEach { playAudio($0) }
        startTimer()
    }
    
    func loadConfiguration(_ config: SavedConfiguration) {
        // 停止当前播放
        stopAll()
        
        // 设置新的配置
        selectedTypes = Set(config.audioTypes)
        selectedMusic = config.music
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
        selectedTypes.forEach { playAudio($0) }
        if let music = selectedMusic {
            playMusic(music)
        }
        startTimer()
    }
    
    private func cleanupMusicPlayer() {
        musicPlayer?.stop()
        musicPlayer = nil
        isMusicPlaying = false
    }
}

// MARK: - Saved Configuration Model
struct SavedConfiguration: Codable, Identifiable {
    let id: UUID
    let audioTypes: [AudioType]
    let music: MusicType?  // 添加音乐类型
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
    
    func saveConfiguration(audioTypes: [AudioType], music: MusicType? = nil, timeLimit: TimeLimit) {
        let configuration = SavedConfiguration(
            id: UUID(),
            audioTypes: audioTypes,
            music: music,
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
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
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
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
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

// MARK: - Music Menu View
struct MusicMenuView: View {
    @EnvironmentObject private var audioManager: AudioManager
    @Binding var showMusicList: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    private var secondaryColor: Color {
        colorScheme == .dark ? .gray : .secondary
    }
    
    var body: some View {
        Button(action: {
            showMusicList.toggle()
        }) {
            HStack {
                Text("音乐")
                    .foregroundColor(.primary)
                    .frame(alignment: .leading)
                
                Spacer()
                
                Text(audioManager.selectedMusic == nil ? "0/\(MusicType.allCases.count)" : "1/\(MusicType.allCases.count)")
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

// MARK: - Save Menu View
struct SaveMenuView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var audioManager: AudioManager
    @StateObject private var configManager = SavedConfigurationManager()
    @Environment(\.colorScheme) private var colorScheme
    @State private var hoveredConfigId: UUID? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.easeOut(duration: 0.2)) {
                    let audioTypes = Array(audioManager.selectedTypes)
                    let music = audioManager.selectedMusic
                    configManager.saveConfiguration(
                        audioTypes: audioTypes,
                        music: music,
                        timeLimit: audioManager.selectedTimeLimit
                    )
                }
            }) {
                Label("保存", systemImage: "plus")
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
        .drawingGroup()
    }
}

struct ConfigurationRow: View {
    let config: SavedConfiguration
    @Binding var hoveredConfigId: UUID?
    @Binding var isPresented: Bool
    @EnvironmentObject private var audioManager: AudioManager
    @EnvironmentObject private var configManager: SavedConfigurationManager
    
    var body: some View {
        HStack(spacing: 4) {
            if hoveredConfigId == config.id {
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        configManager.deleteConfiguration(config)
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .imageScale(.small)
                }
                .buttonStyle(.plain)
                .transition(.opacity)
            }
            
            Button(action: {
                withAnimation(.easeOut(duration: 0.2)) {
                    audioManager.loadConfiguration(config)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPresented = false
                    }
                }
            }) {
                HStack {
                    // 环境音图标
                    HStack(spacing: 2) {
                        ForEach(config.audioTypes, id: \.self) { type in
                            Image(systemName: type.iconName)
                                .imageScale(.small)
                        }
                    }
                    
                    Spacer()
                        .frame(width: 5)
                    
                    // 音乐图标（如果有）
                    if let music = config.music {
                        Image(systemName: music.iconName)
                            .imageScale(.small)
                    }
                    
                    Spacer()
                    
                    Text(config.formattedTime)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .onHover { isHovered in
            withAnimation(.easeInOut(duration: 0.2)) {
                hoveredConfigId = isHovered ? config.id : nil
            }
        }
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
                Text("环境音")
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

// MARK: - Menu Content View
struct MenuContentView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingTimeOptions = false
    @State private var showAudioList = false
    @State private var showMusicList = false
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
            
            if audioManager.selectedTypes.isEmpty && audioManager.selectedMusic == nil {
                Text("请添加声音")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                // 活跃的音频列表
                ScrollView {
                    VStack(spacing: 0) {
                        // 环境音列表
                        ForEach(Array(audioManager.selectedTypes).sorted(by: { $0.displayName < $1.displayName })) { type in
                            ActiveSoundView(type: type)
                        }
                        
                        // 音乐视图
                        if let selectedMusic = audioManager.selectedMusic {
                            ActiveMusicView(music: selectedMusic)
                        }
                    }
                }
            }
            
            Divider()
                .padding(.horizontal, 9)
            
            // 声音选择区域
            SoundMenuView(showAudioList: $showAudioList)
                .padding(.top, 5)
                .popover(isPresented: $showAudioList, arrowEdge: .bottom) {
                    AudioListView()
                }
            
            // 音乐选择区域
            MusicMenuView(showMusicList: $showMusicList)
                .padding(.bottom, 5)
                .popover(isPresented: $showMusicList, arrowEdge: .bottom) {
                    MusicListView()
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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // 设置日志过滤
        UserDefaults.standard.set(true, forKey: "OS_ACTIVITY_MODE")
    }
    
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

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 初始化应用
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // 清理工作
    }
}
