//
//  AuthenticationManager.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/9/24.
//
import FirebaseAuth

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() {}
    
    // Function to create a user with email and password
    func createUser(email: String, password: String) async throws -> AuthDataResult {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return authResult
        } catch {
            throw error
        }
    }
    
    // Function to sign in a user with email and password
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let result = result {
                    completion(.success(result))
                } else {
                    let error = NSError(domain: "Authentication", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Function to sign out the current user
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw error
        }
    }
    
}
