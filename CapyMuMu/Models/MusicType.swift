import Foundation

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
