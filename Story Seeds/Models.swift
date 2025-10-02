//
//  Models.swift
//  Story Seeds
//
//  Core domain models for the app (SwiftUI, offline-only).
//

import Foundation

// MARK: - Generation Categories

enum SeedCategory: String, Codable, CaseIterable, Identifiable {
    case words
    case phrases
    case mixed

    var id: String { rawValue }
}

// MARK: - Seed Item (generated or saved idea)

struct SeedItem: Identifiable, Codable, Equatable {
    let id: UUID
    let createdAt: Date
    let category: SeedCategory
    let contents: [String]

    init(id: UUID = UUID(), createdAt: Date = Date(), category: SeedCategory, contents: [String]) {
        self.id = id
        self.createdAt = createdAt
        self.category = category
        self.contents = contents
    }
}

// MARK: - Profile & Settings

enum AppTheme: String, Codable, CaseIterable, Identifiable {
    case light
    case dark

    var id: String { rawValue }
}

enum AppLanguage: String, Codable, CaseIterable, Identifiable {
    case en
    case ru

    var id: String { rawValue }
}

struct Profile: Codable, Equatable {
    var nickname: String
    var avatarId: Int

    static let `default` = Profile(nickname: "Creative Seed", avatarId: 0)
}

struct AppSettings: Codable, Equatable {
    var language: AppLanguage
    var theme: AppTheme
    var soundsEnabled: Bool

    static let `default` = AppSettings(language: .en, theme: .light, soundsEnabled: true)
}

// MARK: - Achievements

struct Achievement: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let description: String
    let iconSystemName: String

    // Progress tracking
    var targetValue: Int
    var currentValue: Int

    var isUnlocked: Bool { currentValue >= targetValue }
}

// MARK: - Stats (for achievements and analytics)

struct UsageStats: Codable, Equatable {
    var totalGenerated: Int
    var totalSaved: Int
    var streakNoSave: Int
    var usedCategories: Set<SeedCategoryCodable>
    var generateMoreClicks: Int

    init(totalGenerated: Int = 0,
         totalSaved: Int = 0,
         streakNoSave: Int = 0,
         usedCategories: Set<SeedCategoryCodable> = [],
         generateMoreClicks: Int = 0) {
        self.totalGenerated = totalGenerated
        self.totalSaved = totalSaved
        self.streakNoSave = streakNoSave
        self.usedCategories = usedCategories
        self.generateMoreClicks = generateMoreClicks
    }
}

// Wrapper to store Set<SeedCategory> in Codable
struct SeedCategoryCodable: Codable, Hashable {
    let raw: SeedCategory
    init(_ raw: SeedCategory) { self.raw = raw }
}



