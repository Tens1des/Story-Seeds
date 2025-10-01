//
//  FavoritesView.swift
//  Story Seeds
//
//  Favorites screen with saved ideas management
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var storage: StorageService
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var searchText = ""
    @State private var isEditing = false
    @Environment(\.dismiss) private var dismiss
    
    var filteredFavorites: [SeedItem] {
        if searchText.isEmpty {
            return storage.favorites
        } else {
            return storage.favorites.filter { seed in
                seed.contents.joined().localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Statistics Cards
                statisticsView
                
                // Search Bar
                searchBarView
                
                // Favorites List
                if filteredFavorites.isEmpty {
                    emptyStateView
                } else {
                    favoritesListView
                }
                
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
                
                Button(action: { isEditing.toggle() }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your saved ideas")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - Statistics View
    private var statisticsView: some View {
        HStack(spacing: 16) {
            StatCard(title: "\(storage.favorites.count)", subtitle: "Total ideas", color: .blue)
            StatCard(title: "\(wordsCount)", subtitle: "Words", color: .green)
            StatCard(title: "\(phrasesCount)", subtitle: "Phrases", color: .orange)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var wordsCount: Int {
        storage.favorites.filter { $0.category == .words }.count
    }
    
    private var phrasesCount: Int {
        storage.favorites.filter { $0.category == .phrases }.count
    }
    
    // MARK: - Search Bar
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search in favorites...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No favorites yet")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Start generating ideas and save the ones you like")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
    }
    
    // MARK: - Favorites List
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredFavorites) { seed in
                    FavoritesRowView(
                        seed: seed,
                        language: localizationManager.currentLanguage,
                        isEditing: isEditing,
                        onDelete: { deleteSeed(seed) }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Actions
    private func deleteSeed(_ seed: SeedItem) {
        storage.removeFromFavorites(seed)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

// MARK: - Favorites Row
struct FavoritesRowView: View {
    let seed: SeedItem
    let language: AppLanguage
    let isEditing: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(seed.contents.enumerated()), id: \.offset) { index, content in
                    Text(content)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                
                HStack {
                    Text(seed.category.displayName(language))
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(seed.category.color.opacity(0.2))
                        )
                        .foregroundColor(seed.category.color)
                    
                    Spacer()
                    
                    Text(timeAgoString(from: seed.createdAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if isEditing {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            } else {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Extensions
extension SeedCategory {
    var color: Color {
        switch self {
        case .words: return .blue
        case .phrases: return .green
        case .mixed: return .orange
        }
    }
}

// MARK: - Preview
#Preview {
    FavoritesView(storage: StorageService())
}
