//
//  RealiteaseLoserView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 6/1/24.
//

import SwiftUI

struct RealiteaseLoserView: View {
    var correctAnswer: String = ""
    
    var body: some View {
        VStack {
            Text("The correct answer was \(correctAnswer).")
                .font(Font.custom("Poppins", size: 16))
                .padding()
            Button(action: {
                // Dismiss the view
            }) {
                Text("Close")
                    .font(Font.custom("Poppins", size: 18).weight(.bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    RealiteaseLoserView()
}
