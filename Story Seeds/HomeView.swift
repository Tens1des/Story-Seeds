//
//  HomeView.swift
//  Story Seeds
//
//  Main generation screen with categories and generate button
//

import SwiftUI

struct HomeView: View {
    @StateObject private var generator = SeedGenerator()
    @EnvironmentObject private var storage: StorageService
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var selectedCategory: SeedCategory = .words
    @State private var currentSeeds: SeedItem?
    @State private var showingFavorites = false
    @State private var isGenerating = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                headerView
                
                // App Title
                titleView
                
                // Category Selection
                categorySelectionView
                
                // Generate Button
                generateButtonView
                
                // Results
                if let seeds = currentSeeds {
                    resultsView(seeds: seeds)
                } else {
                    emptyStateView
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .gradientBackground()
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingFavorites) {
            FavoritesView(storage: storage)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("home.greeting".localized(localizationManager.currentLanguage))
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button(action: { showingFavorites = true }) {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(.pink)
            }
        }
    }
    
    // MARK: - Title View
    private var titleView: some View {
        VStack(spacing: 8) {
            Text("home.title".localized(localizationManager.currentLanguage))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("home.subtitle".localized(localizationManager.currentLanguage))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Category Selection
    private var categorySelectionView: some View {
        HStack(spacing: 12) {
            ForEach(SeedCategory.allCases) { category in
                Button(action: { selectedCategory = category }) {
                    Text(category.displayName(localizationManager.currentLanguage))
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
    }
    
    // MARK: - Generate Button
    private var generateButtonView: some View {
        Button(action: generateSeeds) {
            HStack(spacing: 8) {
                if isGenerating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "sparkles")
                        .font(.title2)
                }
                
                Text(isGenerating ? "home.generating".localized(localizationManager.currentLanguage) : "home.generate".localized(localizationManager.currentLanguage))
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                Color.primaryGradient
            )
            .cornerRadius(25)
            .glowEffect(color: .pink, radius: 8)
        }
        .bounceEffect()
        .disabled(isGenerating)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "target")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("home.ready".localized(localizationManager.currentLanguage))
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("home.ready_description".localized(localizationManager.currentLanguage))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
    }
    
    // MARK: - Results View
    private func resultsView(seeds: SeedItem) -> some View {
        VStack(spacing: 16) {
            // Results Header
            HStack {
                Text("home.results".localized(localizationManager.currentLanguage))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    storage.recordGenerateMore()
                    generateSeeds()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                        Text("home.generate_more".localized(localizationManager.currentLanguage))
                    }
                    .font(.subheadline)
                    .foregroundColor(.purple)
                }
            }
            
            // Results List
            VStack(spacing: 12) {
                ForEach(Array(seeds.contents.enumerated()), id: \.offset) { index, content in
                    HStack {
                        Text(content)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Button(action: { saveToFavorites(content: content, category: seeds.category) }) {
                            Image(systemName: "heart")
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
            }
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - Actions
    private func generateSeeds() {
        guard !isGenerating else { return }
        
        isGenerating = true
        
        // Simulate generation delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newSeeds = generator.generateSeeds(for: selectedCategory)
            
            withAnimation(.springBounce) {
                currentSeeds = newSeeds
            }
            
            // Update statistics
            storage.recordGeneration(category: selectedCategory)
            if currentSeeds == nil {
                storage.recordStreakNoSave()
            }
            
            // Add haptic feedback
            HapticFeedback.medium()
            
            isGenerating = false
        }
    }
    
    private func saveToFavorites(content: String, category: SeedCategory) {
        let single = SeedItem(category: category, contents: [content])
        withAnimation(.springBounce) {
            storage.addToFavorites(single)
            storage.recordSave()
        }
        
        // Add haptic feedback
        HapticFeedback.success()
    }
}

// MARK: - Extensions
extension SeedCategory {
    func displayName(_ language: AppLanguage = .en) -> String {
        switch self {
        case .words: return "category.words".localized(language)
        case .phrases: return "category.phrases".localized(language)
        case .mixed: return "category.mixed".localized(language)
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
