//
//  ContentView.swift
//  NewsReader
//  Created by Faizan on 3/27/25.

import SwiftUI

//MARK: Main Home Screen
struct ContentView: View {
    
    @EnvironmentObject private var appState: AppState
    @State private var selectedTab: Tab = .news
    @State private var showSettings = false
    @State private var showTextDetection = false
    
    enum Tab {
        case news, search
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                NewsListView()
                    .navigationTitle("News")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button {
                                showTextDetection = true
                            } label: {
                                Image(systemName: "camera.viewfinder")
                            }
                            
                            Button {
                                showSettings = true
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                    }
            }
            .tabItem {
                Label("News", systemImage: "newspaper")
            }
            .tag(Tab.news)
            
            NavigationStack {
                SearchView()
                    .navigationTitle("Search")
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(
                appState: appState,
                authService: AuthService()
            )
        }
        .sheet(isPresented: $showTextDetection) {
            TextDetectionView()
        }
    }
}

//MARK: Preview of home screen
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
