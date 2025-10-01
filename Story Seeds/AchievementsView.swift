//
//  AchievementsView.swift
//  Story Seeds
//
//  Achievements screen with progress tracking and rewards
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var storage: StorageService
    @State private var selectedCategory: AchievementCategory = .all
    @Environment(\.dismiss) private var dismiss
    
    enum AchievementCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case generation = "Generation"
        case collection = "Collection"
        
        var id: String { rawValue }
    }
    
    var filteredAchievements: [Achievement] {
        switch selectedCategory {
        case .all:
            return storage.achievements
        case .generation:
            return storage.achievements.filter { [1, 2, 4, 6, 8, 9, 11, 12].contains($0.id) }
        case .collection:
            return storage.achievements.filter { [3, 7, 10].contains($0.id) }
        }
    }
    
    var unlockedCount: Int {
        storage.achievements.filter { $0.isUnlocked }.count
    }
    
    var totalCount: Int {
        storage.achievements.count
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Progress Bar
                progressView
                
                // User Stats
                userStatsView
                
                // Category Selection
                categorySelectionView
                
                // Achievements List
                achievementsListView
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Achievements")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your successes and rewards")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - Progress View
    private var progressView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(unlockedCount)/\(totalCount) achievements unlocked")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            ProgressView(value: Double(unlockedCount), total: Double(totalCount))
                .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    // MARK: - User Stats
    private var userStatsView: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "\(calculateLevel())",
                subtitle: "Level",
                color: .blue
            )
            
            StatCard(
                title: "\(storage.stats.totalGenerated * 10)",
                subtitle: "Experience",
                color: .green
            )
            
            StatCard(
                title: "\(calculateXPToNext())",
                subtitle: "To Next",
                color: .orange
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    // MARK: - Category Selection
    private var categorySelectionView: some View {
        HStack(spacing: 12) {
            ForEach(AchievementCategory.allCases) { category in
                Button(action: { selectedCategory = category }) {
                    Text(category.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedCategory == category ? Color.purple : Color.gray.opacity(0.2))
                        )
                        .foregroundColor(selectedCategory == category ? .white : .primary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    // MARK: - Achievements List
    private var achievementsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredAchievements) { achievement in
                    AchievementRowView(achievement: achievement)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Helper Methods
    private func calculateLevel() -> Int {
        let xp = storage.stats.totalGenerated * 10
        return min(xp / 100 + 1, 10) // Max level 10
    }
    
    private func calculateXPToNext() -> Int {
        let currentLevel = calculateLevel()
        let currentXP = storage.stats.totalGenerated * 10
        let xpForNextLevel = currentLevel * 100
        return max(xpForNextLevel - currentXP, 0)
    }
}

// MARK: - Achievement Row
struct AchievementRowView: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: achievement.iconSystemName)
                .font(.title2)
                .foregroundColor(achievement.isUnlocked ? .purple : .gray)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(achievement.isUnlocked ? Color.purple.opacity(0.1) : Color.gray.opacity(0.1))
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(achievement.title)
                        .font(.headline)
                        .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                    
                    Spacer()
                    
                    if achievement.isUnlocked {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Progress Bar
                if !achievement.isUnlocked && achievement.targetValue > 1 {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(achievement.currentValue)/\(achievement.targetValue)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        
                        ProgressView(value: Double(achievement.currentValue), total: Double(achievement.targetValue))
                            .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                            .scaleEffect(x: 1, y: 0.5, anchor: .center)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
    }
}

// MARK: - Usage Statistics Summary
struct UsageStatsSummaryView: View {
    let stats: UsageStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Fiery Series")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "\(stats.totalGenerated)",
                    subtitle: "Ideas Created",
                    color: .red
                )
                
                StatCard(
                    title: "\(calculateActiveDays())",
                    subtitle: "Active Days",
                    color: .orange
                )
                
                StatCard(
                    title: "\(stats.totalSaved)",
                    subtitle: "In Favorites",
                    color: .pink
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private func calculateActiveDays() -> Int {
        // Simple calculation - could be more sophisticated
        return max(stats.totalGenerated / 5, 1)
    }
}

// MARK: - Preview
#Preview {
    AchievementsView(storage: StorageService())
}
