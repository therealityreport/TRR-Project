//
//  Games_HeaderView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/31/24.
//

import SwiftUI

struct CustomHeaderView: View {
    var bannerImageName: String
    
    var body: some View {
        HStack {
            Button(action: {
                // Navigate to Search
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Image(bannerImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 49)
            
            Spacer()
            
            Button(action: {
                // Navigate to Profile
            }) {
                Image(systemName: "person.fill")
                    .font(.title)
                    .foregroundColor(.black)
            }
        }
        .frame(height: 87)
        .padding(.horizontal)
        .background(Color.white)
    }
}

struct CustomHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CustomHeaderView(bannerImageName: "TRRQuizzes-Banner")
            .previewLayout(.sizeThatFits)
    }
}

