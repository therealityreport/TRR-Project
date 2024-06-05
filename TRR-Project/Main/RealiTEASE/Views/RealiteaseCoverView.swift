//
//  RealiteaseCoverView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/31/24.
//

import SwiftUI

struct RealiteaseCoverView: View {
    @Binding var navigateToRealitease: Bool
    @Binding var navigateToGame: Bool
    @ObservedObject var manager: RealiteaseManager
    
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    navigateToRealitease = false
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.leading, 28.0)
                }
                .offset(y: -150) // Adjust the top padding to move the xmark up
                .padding(.leading, 10)
                
                Spacer()
            }
            
            Spacer()
            
            ZStack {
                Text("REALITEASE")
                    .font(Font.custom("Poppins-Black", size: 50).weight(.bold))
                    .foregroundColor(.black)
                    .offset(y: -124.50)
                
                Text("Can you guess the correct REALITY TV STAR?")
                    .font(Font.custom("Poppins", size: 20))
                    .lineSpacing(1)
                    .foregroundColor(.black)
                    .offset(y: -60.50)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    manager.fetchTodayAnswer()
                    navigateToRealitease = false
                    navigateToGame = true
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 263, height: 65)
                            .background(.black)
                            .cornerRadius(20)
                        
                        Text("PLAY")
                            .font(Font.custom("Poppins", size: 28).weight(.bold))
                            .foregroundColor(Color(red: 0.98, green: 0.94, blue: 0.88))
                    }
                    .frame(width: 263, height: 65)
                }
                .offset(y: 34.50)
                
                Text(currentDate)
                    .font(Font.custom("Poppins", size: 30).weight(.semibold))
                    .foregroundColor(.black)
                    .offset(y: 135.50)
            }
            .frame(width: 414, height: 316)
            
            Spacer()
        }
        .padding(EdgeInsets(top: 249, leading: 0, bottom: 331, trailing: 0))
        .frame(width: 414, height: 896)
        .background(Color(red: 0.45, green: 0.66, blue: 0.73))
        .edgesIgnoringSafeArea(.all)
    }
}

struct RealiteaseCoverView_Previews: PreviewProvider {
    static var previews: some View {
        RealiteaseCoverView(navigateToRealitease: .constant(true), navigateToGame: .constant(false), manager: RealiteaseManager())
    }
}






