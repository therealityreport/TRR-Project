//
//  ContentView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/9/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        Group {
            if authViewModel.isRegistered {
                MainTabView()
            } else if authViewModel.isUserAuthenticated {
                ContinueSignUpView()
                    .environmentObject(authViewModel)
            } else {
                AuthenticationView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthenticationViewModel())
    }
}





