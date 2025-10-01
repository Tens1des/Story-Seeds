//
//  StorageService.swift
//  Story Seeds
//
//  UserDefaults-based storage for profile, favorites, and statistics
//

import Foundation

// MARK: - Storage Service

class StorageService: ObservableObject {
    
    // MARK: - Keys
    private enum Keys {
        static let profile = "user_profile"
        static let settings = "app_settings"
        static let favorites = "saved_seeds"
        static let stats = "usage_stats"
        static let achievements = "achievements"
        static let achievementsVersion = "achievements_version"
    }

    private let currentAchievementsVersion = 2
    
    // MARK: - Published Properties
    @Published var profile: Profile = Profile.default
    @Published var settings: AppSettings = AppSettings.default
    @Published var favorites: [SeedItem] = []
    @Published var stats: UsageStats = UsageStats()
    @Published var achievements: [Achievement] = []
    
    // MARK: - Initialization
    init() {
        loadAllData()
        migrateAchievementsIfNeeded()
    }
    
    // MARK: - Profile Management
    func updateProfile(_ newProfile: Profile) {
        profile = newProfile
        saveProfile()
    }
    
    private func saveProfile() {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: Keys.profile)
        }
    }
    
    private func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: Keys.profile),
           let loadedProfile = try? JSONDecoder().decode(Profile.self, from: data) {
            profile = loadedProfile
        }
    }
    
    // MARK: - Settings Management
    func updateSettings(_ newSettings: AppSettings) {
        settings = newSettings
        saveSettings()
    }
    
    private func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: Keys.settings)
        }
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: Keys.settings),
           let loadedSettings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = loadedSettings
        }
    }
    
    // MARK: - Favorites Management
    func addToFavorites(_ seed: SeedItem) {
        favorites.append(seed)
        saveFavorites()
        updateStats { stats in
            stats.totalSaved += 1
        }
    }
    
    func removeFromFavorites(_ seed: SeedItem) {
        favorites.removeAll { $0.id == seed.id }
        saveFavorites()
    }
    
    func clearAllFavorites() {
        favorites.removeAll()
        saveFavorites()
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: Keys.favorites)
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: Keys.favorites),
           let loadedFavorites = try? JSONDecoder().decode([SeedItem].self, from: data) {
            favorites = loadedFavorites
        }
    }
    
    // MARK: - Statistics Management
    func updateStats(_ update: (inout UsageStats) -> Void) {
        update(&stats)
        saveStats()
        checkAchievements()
    }
    
    func recordGeneration(category: SeedCategory) {
        updateStats { stats in
            stats.totalGenerated += 1
            stats.usedCategories.insert(SeedCategoryCodable(category))
        }
    }
    
    func recordSave() {
        updateStats { stats in
            stats.totalSaved += 1
            stats.streakNoSave = 0
        }
    }
    
    func recordGenerateMore() {
        updateStats { stats in
            stats.generateMoreClicks += 1
        }
    }
    
    func recordStreakNoSave() {
        updateStats { stats in
            stats.streakNoSave += 1
        }
    }
    
    private func saveStats() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: Keys.stats)
        }
    }
    
    private func loadStats() {
        if let data = UserDefaults.standard.data(forKey: Keys.stats),
           let loadedStats = try? JSONDecoder().decode(UsageStats.self, from: data) {
            stats = loadedStats
        }
    }
    
    // MARK: - Achievements Management
    private func setupDefaultAchievements() {
        achievements = [
            Achievement(id: 1, title: "First Seed", description: "Generated your first random word", iconSystemName: "target", targetValue: 1, currentValue: 0),
            Achievement(id: 2, title: "Phrase Start", description: "Generated your first starter phrase", iconSystemName: "quote.bubble", targetValue: 1, currentValue: 0),
            Achievement(id: 3, title: "Idea Collector", description: "Saved 5 ideas to Favorites", iconSystemName: "heart.fill", targetValue: 5, currentValue: 0),
            Achievement(id: 4, title: "Quick Thinker", description: "Generated 10 ideas in a row without saving", iconSystemName: "bolt.fill", targetValue: 10, currentValue: 0),
            Achievement(id: 5, title: "Category Master", description: "Used all generation categories", iconSystemName: "square.grid.3x3", targetValue: 3, currentValue: 0),
            Achievement(id: 6, title: "Creative Flash", description: "Generated 50 ideas in total", iconSystemName: "sparkles", targetValue: 50, currentValue: 0),
            Achievement(id: 7, title: "Favorite Lover", description: "Saved 20 ideas to Favorites", iconSystemName: "star.fill", targetValue: 20, currentValue: 0),
            Achievement(id: 8, title: "Regeneration", description: "Used 'Generate more' 10 times in a row", iconSystemName: "arrow.clockwise", targetValue: 10, currentValue: 0),
            Achievement(id: 9, title: "Mixed Mode", description: "Generated ideas in mixed mode", iconSystemName: "shuffle", targetValue: 1, currentValue: 0),
            Achievement(id: 10, title: "Profile Setup", description: "Created nickname and chose avatar", iconSystemName: "person.circle", targetValue: 1, currentValue: 0),
            Achievement(id: 11, title: "Real Writer", description: "Generated 100 ideas in total", iconSystemName: "book.fill", targetValue: 100, currentValue: 0),
            Achievement(id: 12, title: "Inspiration Master", description: "Generated 200 ideas or more", iconSystemName: "crown.fill", targetValue: 200, currentValue: 0)
        ]
        saveAchievements()
    }

    // MARK: - Migration
    private func migrateAchievementsIfNeeded() {
        let savedVersion = UserDefaults.standard.integer(forKey: Keys.achievementsVersion)
        let containsCyrillic = achievements.contains { ach in
            ach.title.range(of: "[А-Яа-я]", options: .regularExpression) != nil ||
            ach.description.range(of: "[А-Яа-я]", options: .regularExpression) != nil
        }
        if achievements.isEmpty || savedVersion < currentAchievementsVersion || containsCyrillic {
            setupDefaultAchievements()
            UserDefaults.standard.set(currentAchievementsVersion, forKey: Keys.achievementsVersion)
        }
    }
    
    private func saveAchievements() {
        if let data = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(data, forKey: Keys.achievements)
        }
    }
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: Keys.achievements),
           let loadedAchievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = loadedAchievements
        }
    }
    
    private func checkAchievements() {
        var updated = false
        
        for i in 0..<achievements.count {
            let achievement = achievements[i]
            var newValue = 0
            
            switch achievement.id {
            case 1: // Первый семечко - слова
                newValue = stats.totalGenerated
            case 2: // Фразовый старт - фразы
                newValue = stats.totalGenerated
            case 3: // Коллекционер идей
                newValue = stats.totalSaved
            case 4: // Быстрый мыслитель
                newValue = stats.streakNoSave
            case 5: // Мастер категорий
                newValue = stats.usedCategories.count
            case 6: // Творческая вспышка
                newValue = stats.totalGenerated
            case 7: // Любимец Избранного
                newValue = stats.totalSaved
            case 8: // Повторная генерация
                newValue = stats.generateMoreClicks
            case 9: // Смешанный режим
                newValue = stats.usedCategories.contains(SeedCategoryCodable(.mixed)) ? 1 : 0
            case 10: // Настройка профиля
                newValue = (profile.nickname != "Creative Seed" || profile.avatarId != 0) ? 1 : 0
            case 11: // Настоящий писатель
                newValue = stats.totalGenerated
            case 12: // Мастер вдохновения
                newValue = stats.totalGenerated
            default:
                break
            }
            
            if achievements[i].currentValue != newValue {
                achievements[i].currentValue = newValue
                updated = true
            }
        }
        
        if updated {
            saveAchievements()
        }
    }
    
    // MARK: - Data Loading
    private func loadAllData() {
        loadProfile()
        loadSettings()
        loadFavorites()
        loadStats()
        loadAchievements()
    }
}
