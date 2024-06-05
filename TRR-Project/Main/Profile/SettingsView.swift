//
//  SettingsView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/10/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button("Reset Password") {
                    // Placeholder for actual functionality
                    print("Reset password tapped")
                }

                Button("Log Out") {
                    authViewModel.signOut()
                }
                .foregroundColor(.red)

            }
            .padding()
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

// For testing and preview purposes
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(AuthenticationViewModel())
    }
}






