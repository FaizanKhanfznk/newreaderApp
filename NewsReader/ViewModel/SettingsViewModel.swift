//  Created by Faizan on 3/27/25.

import Foundation
import Combine

//MARK: Setting View Model to interact with SettingsView
class SettingsViewModel: ObservableObject {
    
    @Published var isDarkMode: Bool
    @Published var selectedCategories: [NewsCategory]
    @Published var isLoggedIn: Bool = false
    
    private let appState: AppState
    private let authService: AuthService
    
    init(appState: AppState, authService: AuthService) {
        self.appState = appState
        self.authService = authService
        self.isDarkMode = appState.isDarkMode
        self.selectedCategories = appState.selectedCategories
        self.isLoggedIn = authService.user != nil
        
        setupObservers()
    }
    
    func setupObservers() {
        authService.$user
            .receive(on: RunLoop.main)
            .map { $0 != nil }
            .assign(to: &$isLoggedIn)
    }
    
    //MARK: Switch between dark and light mode
    func toggleDarkMode() {
        isDarkMode.toggle()
        appState.isDarkMode = isDarkMode
        appState.saveUserPreferences()
    }
    
    func toggleCategory(_ category: NewsCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
        } else {
            selectedCategories.append(category)
        }
        appState.selectedCategories = selectedCategories
        appState.saveUserPreferences()
    }
    
    //MARK: to sign out from profile
    func signOut() {
        authService.signOut()
    }
}
