//
//  Created by Faizan on 3/27/25.

import Combine
import Foundation

final class AppState: ObservableObject {
    @Published var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    @Published var isAuthenticated: Bool = false
    @Published var selectedCategories: [NewsCategory] = NewsCategory.defaultCategories
    
    init() {
        loadUserPreferences()
    }
    
    private func loadUserPreferences() {
        if let data = UserDefaults.standard.data(forKey: "selectedCategories") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([NewsCategory].self, from: data) {
                selectedCategories = decoded
            }
        }
    }
    
    func saveUserPreferences() {
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(selectedCategories) {
            UserDefaults.standard.set(encoded, forKey: "selectedCategories")
        }
    }
}
