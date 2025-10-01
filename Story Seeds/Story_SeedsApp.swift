//
//  Story_SeedsApp.swift
//  Story Seeds
//
//  Created by Рома Котов on 01.10.2025.
//

import SwiftUI

@main
struct Story_SeedsApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var storage = StorageService()
    @StateObject private var localizationManager = LocalizationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(storage)
                .environmentObject(localizationManager)
                .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
        }
    }
}
