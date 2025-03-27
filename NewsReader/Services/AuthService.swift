//
//  AuthService.swift
//  Created by Zigron on 3/27/25.


import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase

//MARK: Firebase authorization to check for google auth
class AuthService: ObservableObject {
    
    @Published var user: User?
    @Published var error: Error?
    
    init() {
        _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }
    
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken?.tokenString else {
                throw AuthError.tokenError
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            self.user = result.user
            return true
        } catch {
            self.error = error
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            self.error = error
        }
    }
}

enum AuthError: Error {
    case tokenError
}
