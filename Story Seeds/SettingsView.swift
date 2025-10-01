//
//  SettingsView.swift
//  Story Seeds
//
//  Settings screen with language, theme, nickname and avatar selection
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var storage: StorageService
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingProfileEditor = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Profile Section
                    profileSection
                    
                    // Interface Section
                    interfaceSection
                    
                    // Favorites Management
                    favoritesSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .gradientBackground()
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingProfileEditor) {
            ProfileEditorView(storage: storage)
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
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("App personalization")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            profileHeader
            VStack(spacing: 20) {
                avatarSelectionCard
                usernameCard
            }
        }
    }
    
    private var profileHeader: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundColor(.purple)
            Text("Profile")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
    }
    
    private var avatarSelectionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Avatar")
                .font(.headline)
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<SeedData.avatarOptions.count, id: \.self) { index in
                        avatarButton(for: index)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private func avatarButton(for index: Int) -> some View {
        Button(action: { 
            withAnimation(.springBounce) {
                updateAvatar(index)
            }
        }) {
            Image(systemName: SeedData.avatarOptions[index])
                .font(.title2)
                .foregroundColor(storage.profile.avatarId == index ? .white : .primary)
                .frame(width: 60, height: 60)
                .background(avatarBackground(for: index))
                .overlay(avatarOverlay(for: index))
                .scaleEffect(storage.profile.avatarId == index ? 1.1 : 1.0)
        }
        .bounceEffect()
    }
    
    private func avatarBackground(for index: Int) -> some View {
        Circle()
            .fill(storage.profile.avatarId == index ?
                  Color.purple :
                  Color.gray.opacity(0.15))
    }
    
    private func avatarOverlay(for index: Int) -> some View {
        Circle()
            .stroke(storage.profile.avatarId == index ? 
                   Color.purple : Color.clear, lineWidth: 3)
    }
    
    private var usernameCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Username")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                usernameTextField
                editButton
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private var usernameTextField: some View {
        TextField("Enter username", text: Binding(
            get: { storage.profile.nickname },
            set: { updateNickname($0) }
        ))
        .textFieldStyle(PlainTextFieldStyle())
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var editButton: some View {
        Button(action: { showingProfileEditor = true }) {
            Text("Edit")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.primaryGradient)
                .cornerRadius(12)
        }
        .bounceEffect()
    }
    
    // MARK: - Interface Section
    private var interfaceSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            interfaceHeader
            VStack(spacing: 20) {
                appearanceCard
                languageCard
                soundEffectsCard
            }
        }
    }
    
    private var interfaceHeader: some View {
        HStack {
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundColor(.blue)
            Text("Interface")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
    }
    
    private var appearanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Appearance")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                ForEach(AppTheme.allCases) { theme in
                    themeButton(for: theme)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private func themeButton(for theme: AppTheme) -> some View {
        Button(action: { 
            withAnimation(.springBounce) {
                updateTheme(theme)
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: theme == .light ? "sun.max.fill" : "moon.fill")
                    .font(.subheadline)
                Text(theme.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(themeButtonBackground(for: theme))
            .foregroundColor(storage.settings.theme == theme ? .white : .primary)
            .overlay(themeButtonOverlay(for: theme))
        }
        .bounceEffect()
    }
    
    private func themeButtonBackground(for theme: AppTheme) -> some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(storage.settings.theme == theme ?
                  Color.purple :
                  Color.gray.opacity(0.15))
    }
    
    private func themeButtonOverlay(for theme: AppTheme) -> some View {
        RoundedRectangle(cornerRadius: 25)
            .stroke(storage.settings.theme == theme ? 
                   Color.clear : Color.purple.opacity(0.3), lineWidth: 1)
    }
    
    private var languageCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Language")
                .font(.headline)
                .foregroundColor(.primary)
            
            languageMenu
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private var languageMenu: some View {
        Menu {
            ForEach(AppLanguage.allCases) { language in
                Button(action: { 
                    withAnimation(.springBounce) {
                        updateLanguage(language)
                    }
                }) {
                    HStack {
                        Text(language.displayName)
                        if storage.settings.language == language {
                            Image(systemName: "checkmark")
                                .foregroundColor(.purple)
                        }
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.purple)
                Text(storage.settings.language.displayName)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(languageMenuBackground)
        }
    }
    
    private var languageMenuBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var soundEffectsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.orange)
                Text("Sound Effects")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                soundToggle
            }
            
            Text("Sounds during generation and saving")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .cardStyle()
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private var soundToggle: some View {
        Toggle("", isOn: Binding<Bool>(
            get: { storage.settings.soundsEnabled },
            set: { newValue in
                withAnimation(.springBounce) {
                    updateSoundEffects(newValue)
                }
            }
        ))
        .tint(.purple)
        .scaleEffect(1.1)
    }
    
    // MARK: - Favorites Section
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(.red)
                Text("Favorites Management")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            VStack(spacing: 16) {
                Button(action: clearAllFavorites) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.white)
                        Text("Clear All Favorites")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(storage.favorites.count)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.2))
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color.red, Color.pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .glowEffect(color: .red, radius: 8)
                }
                .bounceEffect()
            }
        }
    }
    
    // MARK: - Actions
    private func updateAvatar(_ avatarId: Int) {
        var newProfile = storage.profile
        newProfile.avatarId = avatarId
        storage.updateProfile(newProfile)
    }
    
    private func updateNickname(_ nickname: String) {
        var newProfile = storage.profile
        newProfile.nickname = nickname
        storage.updateProfile(newProfile)
    }
    
    private func updateTheme(_ theme: AppTheme) {
        var newSettings = storage.settings
        newSettings.theme = theme
        storage.updateSettings(newSettings)
        themeManager.setTheme(theme)
    }
    
    private func updateLanguage(_ language: AppLanguage) {
        var newSettings = storage.settings
        newSettings.language = language
        storage.updateSettings(newSettings)
        localizationManager.setLanguage(language)
    }
    
    private func updateSoundEffects(_ enabled: Bool) {
        var newSettings = storage.settings
        newSettings.soundsEnabled = enabled
        storage.updateSettings(newSettings)
    }
    
    private func clearAllFavorites() {
        storage.clearAllFavorites()
    }
}

// MARK: - Profile Editor
struct ProfileEditorView: View {
    @ObservedObject var storage: StorageService
    @State private var tempNickname: String
    @State private var tempAvatarId: Int
    @Environment(\.dismiss) private var dismiss
    
    init(storage: StorageService) {
        self.storage = storage
        self._tempNickname = State(initialValue: storage.profile.nickname)
        self._tempAvatarId = State(initialValue: storage.profile.avatarId)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Avatar Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    ForEach(0..<SeedData.avatarOptions.count, id: \.self) { index in
                        Button(action: { tempAvatarId = index }) {
                            Image(systemName: SeedData.avatarOptions[index])
                                .font(.title)
                                .foregroundColor(tempAvatarId == index ? .white : .primary)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(tempAvatarId == index ? Color.purple : Color.gray.opacity(0.2))
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Username Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .font(.headline)
                    
                    TextField("Enter username", text: $tempNickname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func saveProfile() {
        var newProfile = storage.profile
        newProfile.nickname = tempNickname
        newProfile.avatarId = tempAvatarId
        storage.updateProfile(newProfile)
        dismiss()
    }
}

// MARK: - Extensions
extension AppTheme {
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

extension AppLanguage {
    var displayName: String {
        switch self {
        case .en: return "English"
        case .ru: return "Русский"
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView(storage: StorageService())
}
