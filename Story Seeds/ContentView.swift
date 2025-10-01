//
//  ContentView.swift
//  Story Seeds
//
//  Created by Рома Котов on 01.10.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var storage: StorageService
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            FavoritesView(storage: storage)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(1)
            
            AchievementsView(storage: storage)
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Achievements")
                }
                .tag(2)
            
            SettingsView(storage: storage)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView()
}
