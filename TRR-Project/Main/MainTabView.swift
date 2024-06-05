//
//  MainTabView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/10/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Games_MainView()
                .tabItem {
                    Image(systemName: "puzzlepiece.fill")
                    Text("Games")
                }
            
            // Placeholder for Stats view
            Text("Stats View")
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
            
            Quizzes_MainView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Quizzes")
                }
            
            // Placeholder for Polls view
            Text("Polls View")
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Polls")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}



