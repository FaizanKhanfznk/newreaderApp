
//  Created by Faizan on 3/27/25.

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(appState: AppState, authService: AuthService) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(
            appState: appState,
            authService: authService
        ))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
                }
                
                Section("News Categories") {
                    ForEach(NewsCategory.allCases) { category in
                        Toggle(
                            category.displayName,
                            isOn: Binding(
                                get: { viewModel.selectedCategories.contains(category) },
                                set: { _ in viewModel.toggleCategory(category) }
                            )
                        )
                    }
                }
                
                Section("Account") {
                    if viewModel.isLoggedIn {
                        Button("Sign Out", role: .destructive) {
                            viewModel.signOut()
                            dismiss()
                        }
                    } else {
                        NavigationLink {
                            AuthenticationView()
                        } label: {
                            Text("Sign In with Google")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
