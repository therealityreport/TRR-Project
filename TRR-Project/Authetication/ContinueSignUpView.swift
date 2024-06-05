//
//  ContinueSignUpView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/12/24.
//

import SwiftUI

struct ContinueSignUpView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var userManager: UserManager
    @State private var username: String = ""
    @State private var errorMessage: String?
    @State private var isUsernameAvailable: Bool = true
    @State private var isProcessing: Bool = false

    var body: some View {
        VStack {
            Text("Create a Username")
                .font(.title)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Sign Up") {
                checkUsernameAndSignUp()
            }
            .disabled(username.isEmpty || isProcessing)
            .padding()
        }
        .navigationTitle("Continue Sign Up")
    }

    private func checkUsernameAndSignUp() {
        isProcessing = true
        errorMessage = nil  // Clear previous error messages
        Task {
            do {
                isUsernameAvailable = await userManager.isUsernameAvailable(username)
                if isUsernameAvailable {
                    try await userManager.createFinalUser(username: username)
                    DispatchQueue.main.async {
                        // Successfully created user, update authViewModel state
                        authViewModel.isRegistered = true
                    }
                } else {
                    throw NSError(domain: "UserManagement", code: 1, userInfo: [NSLocalizedDescriptionKey: "Username is already taken"])
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    isProcessing = false
                }
            }
        }
    }
}

struct ContinueSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        ContinueSignUpView()
            .environmentObject(UserManager.shared) // Use the shared instance
            .environmentObject(AuthenticationViewModel())
    }
}

