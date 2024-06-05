//
//  SignUpEmailView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/9/24.
//

import SwiftUI

struct SignUpEmailView: View {
    @StateObject private var viewModel: SignUpEmailViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    init(authViewModel: AuthenticationViewModel) {
        _viewModel = StateObject(wrappedValue: SignUpEmailViewModel(authViewModel: authViewModel))
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button("Continue") {
                    Task {
                        await viewModel.registerUser()
                    }
                }
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                .padding()
            }
            .navigationTitle("Create Account")
        }
    }
}



// Preview Provider
struct SignUpEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpEmailView(authViewModel: AuthenticationViewModel())
    }
}


