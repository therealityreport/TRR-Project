//
//  AuthenticationViewModel.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthenticationViewModel: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    @Published var isRegistered: Bool = false // This flag will track if the user has completed all registration steps including username
    @Published var currentUser: User?

    init() {
        checkAuthentication()
    }

    func checkAuthentication() {
        if let user = Auth.auth().currentUser {
            self.currentUser = user
            checkUserRegistration(user: user)
        } else {
            self.currentUser = nil
            isUserAuthenticated = false
            isRegistered = false
        }
    }
    
    func userDidAuthenticate(user: User) {
        self.currentUser = user
        self.isUserAuthenticated = true
        checkUserRegistration(user: user)  // Optionally check for full registration status
    }
    
    private func checkUserRegistration(user: User) {
        let docRef = Firestore.firestore().collection("users").document(user.uid)
        docRef.getDocument { document, error in
            if let doc = document, doc.exists {
                self.isRegistered = true
                self.isUserAuthenticated = true
            } else {
                self.isRegistered = false
                self.isUserAuthenticated = true // User is authenticated but not fully registered
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isUserAuthenticated = false
            isRegistered = false
            currentUser = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

        
    
    
    
    
    

