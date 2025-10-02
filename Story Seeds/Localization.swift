//
//  Localization.swift
//  Story Seeds
//
//  Localization support for English and Russian
//

import Foundation

// MARK: - Localization Manager

class LocalizationManager: ObservableObject {
    @Published var currentLanguage: AppLanguage = .en
    
    init() {
        // Load language from UserDefaults
        if let savedLanguage = UserDefaults.standard.string(forKey: "app_language"),
           let language = AppLanguage(rawValue: savedLanguage) {
            currentLanguage = language
        }
    }
    
    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "app_language")
    }
    
    func localizedString(_ key: String) -> String {
        return LocalizedStrings.string(for: key, language: currentLanguage)
    }
}

// MARK: - Localized Strings

struct LocalizedStrings {
    static func string(for key: String, language: AppLanguage) -> String {
        switch language {
        case .en:
            return englishStrings[key] ?? key
        case .ru:
            return russianStrings[key] ?? key
        }
    }
    
    private static let englishStrings: [String: String] = [
        // Navigation
        "nav.home": "Home",
        "nav.favorites": "Favorites",
        "nav.achievements": "Achievements",
        "nav.settings": "Settings",
        
        // Home Screen
        "home.greeting": "Hello! Creative genius",
        "home.title": "Story Seeds",
        "home.subtitle": "Creative idea generator",
        "home.generate": "Generate ideas",
        "home.generating": "Generating...",
        "home.ready": "Ready for inspiration?",
        "home.ready_description": "Press the button above to get new creative ideas",
        "home.results": "Generated Ideas",
        "home.generate_more": "Generate more",
        
        // Categories
        "category.words": "Words",
        "category.phrases": "Phrases",
        "category.mixed": "Mix",
        
        // Favorites Screen
        "favorites.title": "Favorites",
        "favorites.subtitle": "Your saved ideas",
        "favorites.edit": "Edit",
        "favorites.done": "Done",
        "favorites.search": "Search in favorites...",
        "favorites.empty": "No favorites yet",
        "favorites.empty_description": "Start generating ideas and save the ones you like",
        "favorites.total_ideas": "Total ideas",
        "favorites.words": "Words",
        "favorites.phrases": "Phrases",
        
        // Settings Screen
        "settings.title": "Settings",
        "settings.subtitle": "App personalization",
        "settings.profile": "Profile",
        "settings.interface": "Interface",
        "settings.avatar": "Avatar",
        "settings.username": "Username",
        "settings.theme": "Theme",
        "settings.language": "Interface Language",
        "settings.sound_effects": "Sound Effects",
        "settings.sound_description": "Sounds during generation and saving",
        "settings.favorites_management": "Favorites Management",
        "settings.clear_all": "Clear All Favorites",
        "settings.light": "Light",
        "settings.dark": "Dark",
        "settings.english": "English",
        "settings.russian": "Русский",
        
        // Achievements Screen
        "achievements.title": "Achievements",
        "achievements.subtitle": "Your successes and rewards",
        "achievements.unlocked": "achievements unlocked",
        "achievements.level": "Level",
        "achievements.experience": "Experience",
        "achievements.to_next": "To Next",
        "achievements.all": "All",
        "achievements.generation": "Generation",
        "achievements.collection": "Collection",
        "achievements.fiery_series": "Fiery Series",
        "achievements.ideas_created": "Ideas Created",
        "achievements.active_days": "Active Days",
        "achievements.in_favorites": "In Favorites",
        
        // Achievement Names
        "achievement.first_seed": "First Seed",
        "achievement.phrase_start": "Phrase Start",
        "achievement.idea_collector": "Idea Collector",
        "achievement.quick_thinker": "Quick Thinker",
        "achievement.category_master": "Category Master",
        "achievement.creative_flash": "Creative Flash",
        "achievement.favorite_lover": "Favorite Lover",
        "achievement.regeneration": "Regeneration",
        "achievement.mixed_mode": "Mixed Mode",
        "achievement.profile_setup": "Profile Setup",
        "achievement.real_writer": "Real Writer",
        "achievement.inspiration_master": "Inspiration Master",
        
        // Achievement Descriptions
        "achievement.first_seed_desc": "Generated your first random word",
        "achievement.phrase_start_desc": "Generated your first starter phrase",
        "achievement.idea_collector_desc": "Saved 5 ideas to Favorites",
        "achievement.quick_thinker_desc": "Generated 10 ideas in a row without saving",
        "achievement.category_master_desc": "Used all generation categories",
        "achievement.creative_flash_desc": "Generated 50 ideas in total",
        "achievement.favorite_lover_desc": "Saved 20 ideas to Favorites",
        "achievement.regeneration_desc": "Used 'Generate more' button 10 times in a row",
        "achievement.mixed_mode_desc": "Generated ideas in mixed mode",
        "achievement.profile_setup_desc": "Created nickname and chose avatar",
        "achievement.real_writer_desc": "Generated 100 ideas in total",
        "achievement.inspiration_master_desc": "Generated 200 ideas or more",
        
        // Common
        "common.cancel": "Cancel",
        "common.save": "Save",
        "common.edit": "Edit",
        "common.delete": "Delete",
        "common.done": "Done",
        "common.back": "Back"
    ]
    
    private static let russianStrings: [String: String] = [
        // Navigation
        "nav.home": "Главная",
        "nav.favorites": "Избранное",
        "nav.achievements": "Достижения",
        "nav.settings": "Настройки",
        
        // Home Screen
        "home.greeting": "Привет! Креативный гений",
        "home.title": "Story Seeds",
        "home.subtitle": "Генератор креативных идей",
        "home.generate": "Сгенерировать идеи",
        "home.generating": "Генерируем...",
        "home.ready": "Готовы к вдохновению?",
        "home.ready_description": "Нажмите кнопку выше, чтобы получить новые креативные идеи",
        "home.results": "Сгенерированные идеи",
        "home.generate_more": "Сгенерировать ещё",
        
        // Categories
        "category.words": "Слова",
        "category.phrases": "Фразы",
        "category.mixed": "Микс",
        
        // Favorites Screen
        "favorites.title": "Избранное",
        "favorites.subtitle": "Ваши сохранённые идеи",
        "favorites.edit": "Править",
        "favorites.done": "Готово",
        "favorites.search": "Поиск по избранному...",
        "favorites.empty": "Пока нет избранного",
        "favorites.empty_description": "Начните генерировать идеи и сохраняйте понравившиеся",
        "favorites.total_ideas": "Всего идей",
        "favorites.words": "Слов",
        "favorites.phrases": "Фраз",
        
        // Settings Screen
        "settings.title": "Настройки",
        "settings.subtitle": "Персонализация приложения",
        "settings.profile": "Профиль",
        "settings.interface": "Интерфейс",
        "settings.avatar": "Аватар",
        "settings.username": "Имя пользователя",
        "settings.theme": "Тема оформления",
        "settings.language": "Язык интерфейса",
        "settings.sound_effects": "Звуковые эффекты",
        "settings.sound_description": "Звуки при генерации и сохранении",
        "settings.favorites_management": "Управление избранным",
        "settings.clear_all": "Очистить всё",
        "settings.light": "Светлая",
        "settings.dark": "Тёмная",
        "settings.english": "English",
        "settings.russian": "Русский",
        
        // Achievements Screen
        "achievements.title": "Достижения",
        "achievements.subtitle": "Ваши успехи и награды",
        "achievements.unlocked": "достижений получено",
        "achievements.level": "Уровень",
        "achievements.experience": "Очки опыта",
        "achievements.to_next": "До следующего",
        "achievements.all": "Все",
        "achievements.generation": "Генерация",
        "achievements.collection": "Коллекция",
        "achievements.fiery_series": "Огненная серия",
        "achievements.ideas_created": "Идей создано",
        "achievements.active_days": "Дней активности",
        "achievements.in_favorites": "В избранном",
        
        // Achievement Names
        "achievement.first_seed": "Первый семечко",
        "achievement.phrase_start": "Фразовый старт",
        "achievement.idea_collector": "Коллекционер идей",
        "achievement.quick_thinker": "Быстрый мыслитель",
        "achievement.category_master": "Мастер категорий",
        "achievement.creative_flash": "Творческая вспышка",
        "achievement.favorite_lover": "Любимец Избранного",
        "achievement.regeneration": "Повторная генерация",
        "achievement.mixed_mode": "Смешанный режим",
        "achievement.profile_setup": "Настройка профиля",
        "achievement.real_writer": "Настоящий писатель",
        "achievement.inspiration_master": "Мастер вдохновения",
        
        // Achievement Descriptions
        "achievement.first_seed_desc": "Сгенерировал своё первое случайное слово",
        "achievement.phrase_start_desc": "Сгенерировал первую стартовую фразу",
        "achievement.idea_collector_desc": "Сохранил 5 идей в Избранное",
        "achievement.quick_thinker_desc": "Сгенерировал 10 идей подряд без сохранения",
        "achievement.category_master_desc": "Использовал все категории генерации",
        "achievement.creative_flash_desc": "Сгенерировал 50 идей в общей сложности",
        "achievement.favorite_lover_desc": "Сохранил 20 идей в Избранное",
        "achievement.regeneration_desc": "Использовал кнопку «Сгенерировать ещё» 10 раз подряд",
        "achievement.mixed_mode_desc": "Сгенерировал идеи в смешанном режиме",
        "achievement.profile_setup_desc": "Придумал ник и выбрал аватар",
        "achievement.real_writer_desc": "Сгенерировал 100 идей в общей сложности",
        "achievement.inspiration_master_desc": "Сгенерировал 200 идей или больше",
        
        // Common
        "common.cancel": "Отмена",
        "common.save": "Сохранить",
        "common.edit": "Править",
        "common.delete": "Удалить",
        "common.done": "Готово",
        "common.back": "Назад"
    ]
}

// MARK: - Localized String Extension

extension String {
    func localized(_ language: AppLanguage = .en) -> String {
        return LocalizedStrings.string(for: self, language: language)
    }
}

