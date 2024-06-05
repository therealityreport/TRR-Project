//
//  SignInEmailView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/9/24.
//

import SwiftUI

struct SignInEmailView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Button("Continue") {
                    signInUser(email: email, password: password)
                }
                .font(Font.custom("Poppins-Bold", size: 18))
                .padding()
            }
            .navigationTitle("Log In")
        }
    }

    private func signInUser(email: String, password: String) {
        AuthenticationManager.shared.signIn(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authResult):
                    authViewModel.userDidAuthenticate(user: authResult.user)  // Ensure you call the correct function
                case .failure(let error):
                    errorMessage = "Failed to sign in: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInEmailView().environmentObject(AuthenticationViewModel())
    }
}

