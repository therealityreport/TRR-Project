//
//  SignUpEmailViewModel.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/12/24.
//

import SwiftUI
import FirebaseAuth

final class SignUpEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isRegistered = false // Tracks if user has registered
    @Published var errorMessage: String?

    var authViewModel: AuthenticationViewModel

    init(authViewModel: AuthenticationViewModel) {
        self.authViewModel = authViewModel
    }

    func registerUser() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }

        do {
            let userData = try await AuthenticationManager.shared.createUser(email: email, password: password)
            await MainActor.run {
                self.authViewModel.userDidAuthenticate(user: userData.user)
                self.isRegistered = true // Indicate that the user is registered
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to register: \(error.localizedDescription)"
            }
        }
    }
}


