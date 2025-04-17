# 项目说明

CapyMuMu - 让自然的低语 成为你的心灵伴侣

![image](https://s2.loli.net/2024/12/27/RjbUyG2iJE1BCQ8.png)

倾听森林晨光中的鸟鸣、雨天屋檐下的禅意、咖啡厅的轻声喧哗，或夏日海滩边的潮声涌动。CapyMuMu 的沉浸式声音设计，帮助你摆脱现代生活的喧嚣，随时随地开启属于自己的听觉旅程。

CapyMuMu 是一款为 macOS 精心打造的优雅白噪音播放器，用声音为你营造专注与平静的空间。

无论是为了隔绝外界杂音、专注工作、放松身心，还是缓解压力、提高睡眠质量，CapyMuMu 都是你的贴心助手。它将自然的纯粹声音带到你的耳边，陪伴你度过高效的一天，或让你在忙碌中找到片刻宁静。

![image](https://s2.loli.net/2024/12/27/wyHSxD9og8zVfNu.png)

## 主要功能与体验

随声音开启一场心灵旅行

倾听森林晨光中的鸟鸣、雨天屋檐下的禅意、咖啡厅的轻声喧哗，或夏日海滩边的潮声涌动。CapyMuMu 的沉浸式声音设计，帮助你摆脱现代生活的喧嚣，随时随地开启属于自己的听觉旅程。

帮助你成为更好的自己

CapyMuMu 提供均匀分布的白噪音，屏蔽外界干扰，提升专注力，同时舒缓压力、焦虑与烦躁情绪。无论是工作、学习、冥想，还是亲子陪伴与氛围营造，CapyMuMu 都能为你的每一天增添从容与舒适。

## 适用人群：

- 需要在嘈杂环境中专注工作的人
- 受压力和焦虑困扰的人
- 创意工作者与需要灵感的设计师
- 想提升睡眠质量或抚慰宝宝的家庭
- 冥想爱好者与在意身心健康的人
- 喜欢自然氛围与白噪音的听众

## 项目结构

```
CapyMuMu/
├── Models/                    # 数据模型
│   ├── AudioType.swift       # 音频类型定义
│   ├── MusicType.swift       # 音乐类型定义
│   └── StoreManager.swift    # 应用内购买管理
├── Views/                    # 视图组件
│   ├── ActivView.swift       # 激活视图
│   ├── ListView.swift        # 列表视图
│   ├── PurchaseView.swift    # 购买视图
│   └── SaveMenuView.swift    # 保存菜单视图
├── Resources/                # 资源文件
│   ├── sound-audio-*.m4a    # 环境音效文件
│   └── sound-music-*.m4a    # 音乐文件
├── CapyMuMuApp.swift        # 应用主入口
└── ContentView.swift         # 主视图

Tests/                       # 测试文件
├── CapyMuMuTests/          # 单元测试
└── CapyMuMuUITests/        # UI测试
```

## 技术架构

CapyMuMu 采用了现代 SwiftUI 架构设计：

- **UI 框架**：使用 SwiftUI 构建原生 macOS 界面
- **应用扩展**：通过 MenuBarExtra 实现菜单栏功能
- **状态管理**：采用 SwiftUI 的原生状态管理
- **音频处理**：使用 AVFoundation 处理音频播放
- **持久化**：使用 UserDefaults 存储用户设置
- **内购系统**：集成 StoreKit 2 实现应用内购买

## 开发环境要求

- macOS 13.0 或更高版本
- Xcode 14.0 或更高版本
- Swift 5.7 或更高版本

## 化繁为简，回归声音本质

- 无干扰设计：静默运行于菜单栏，不占用屏幕空间。
- 便捷混音：拖拽调整音量，轻松搭配专属的声音组合。
- 智能定时器：支持番茄钟、休息计时，温柔提醒每个重要时刻。
- 快捷键支持：轻松操作播放、暂停、音量调整等功能。
- 适配系统主题：自动随 macOS 深浅主题切换，保持界面优雅一致。

此外，你还可以将 CapyMuMu 与音乐类 App 一起播放，调节音量实现无缝混音，为喜欢的音乐增添自然氛围。

CapyMuMu，将为你持续推出更多声音场景与实用功能，陪伴你的每一个宁静时刻。

## 技术栈

这款小工具不涉及窗口，仅通过 MenuBarExtra 对 macos 系统菜单栏进行扩展。
作为一款 menu bar app，它可以在任何时候启动，不会影响系统的使用体验。

- macOS
- Swift
- SwiftUI
- SwiftUI MenuBarExtra
- SF Symbols 