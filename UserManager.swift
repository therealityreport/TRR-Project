//
//  UserManager.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/10/24.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class UserManager: ObservableObject {
    static let shared = UserManager()
    private init() {} // Singleton to manage user data across the app.

    /// Checks if the specified username is available in Firestore.
    func isUsernameAvailable(_ username: String) async -> Bool {
        do {
            let querySnapshot = try await Firestore.firestore()
                .collection("users")
                .whereField("username", isEqualTo: username)
                .getDocuments()
            
            // If there are no documents, the username is available.
            return querySnapshot.documents.isEmpty
        } catch {
            print("Failed to query for username availability: \(error.localizedDescription)")
            return false
        }
    }

    /// Saves initial user data to Firestore when signing up.
    func saveUserData(username: String, email: String, for userID: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(userID)
        let userData = ["username": username, "email": email, "userID": userID]

        do {
            try await userRef.setData(userData, merge: true)
            print("User data saved successfully")
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
            throw error
        }
    }

    /// Finalizes user creation by saving complete user details in Firestore after all checks pass.
    func createFinalUser(username: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(domain: "UserManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user available."])
        }
        
        let userData = ["username": username, "email": currentUser.email ?? "", "uid": currentUser.uid]
        let userRef = Firestore.firestore().collection("users").document(currentUser.uid)
        
        do {
            try await userRef.setData(userData, merge: true)
            print("Final user data saved successfully.")
        } catch let error {
            print("Failed to save user data: \(error)")
            throw error
        }
    }
}












