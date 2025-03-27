//  Created by Faizan on 3/27/25.

import SwiftUI
import GoogleSignIn

struct AuthenticationView: View {
    
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authService = AuthService()
    @State private var error: Error?
    
    var body: some View {
        
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "newspaper")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
            
            Text("News Reader")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                Task {
                    do {
                        let success = await authService.signInWithGoogle()
                        if success {
                            appState.isAuthenticated = true
                            dismiss()
                        }
                    }
                }
            } label: {
                HStack {
                    Image("Google") // Add Google logo asset
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Sign in with Google")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            
            if let error = error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}
