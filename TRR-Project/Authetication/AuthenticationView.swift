//
//  AuthenticationView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/9/24.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 6) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 30.0, height: 30.0)
                Image("TRR-Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350.0, height: 350.0)
                    .padding(.top, 50)
            
                NavigationLink(destination: SignInEmailView()) {
                    loginButtonContent(title: "LOG IN")
                }
                
                NavigationLink(destination: SignUpEmailView(authViewModel: authViewModel)) {
                    signupButtonContent()
                }
                
            }
            .padding(EdgeInsets(top: 285, leading: 0, bottom: 275, trailing: 0))
            .padding(.all, 7.0)
            .frame(width: 414, height: 896)
            .background(Color.black)
        }
    }

    @ViewBuilder
    private func loginButtonContent(title: String) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(Color(red: 0.91, green: 0.73, blue: 0.11))
                .cornerRadius(50)
                .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
            Text(title)
                .font(Font.custom("Poppins-Bold", size: 28))
                .foregroundColor(.white)
        }
        .frame(width: 505, height: 91)
    }

    @ViewBuilder
    private func signupButtonContent() -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("AccentBlue"))
                .background(Color.black)
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50).inset(by: 0.50).stroke(Color(red: 0.98, green: 0.94, blue: 0.88), lineWidth: 0.50))
                .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
            Text("SIGN UP")
                .font(Font.custom("Poppins-Bold", size: 28))
                .foregroundColor(Color(red: 0.98, green: 0.94, blue: 0.88))
        }
        .frame(width: 505, height: 100)
    }
}

// Preview Provider
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AuthenticationViewModel())  // Provide the necessary environment objects
            .environmentObject(UserManager.shared)  // Assuming UserManager is an ObservableObject
    }
}

