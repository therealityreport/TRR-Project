//
//  ShowView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/20/24.
//

import SwiftUI

struct ShowView: View {
    @ObservedObject var viewModel: ShowViewModel
    @State private var isOverviewExpanded = false

    var body: some View {
        ScrollView {
            VStack {
                if let show = viewModel.show {
                    // Background Solid Black
                    ZStack(alignment: .top) {
                        Color.black.edgesIgnoringSafeArea(.all)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                // Show Logo
                                if let logoPath = viewModel.images?.logos.first?.filePath, let logoURL = URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)") {
                                    AsyncImage(url: logoURL) { image in
                                        image
                                            .resizable()
                                            .frame(width: 209, height: 80)
                                            .padding(.top, 60)
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 209, height: 80)
                                            .padding(.top, 60)
                                    }
                                    .padding(.leading, 16)
                                }
                                
                                Spacer()
                                
                                // Show Poster
                                if let posterPath = show.posterPath, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                                    AsyncImage(url: posterURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 126, height: 186)
                                            .cornerRadius(14)
                                            .padding(.trailing, 16)
                                            .padding(.top, 60)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color(red: 0.85, green: 0.85, blue: 0.85))
                                            .frame(width: 146, height: 196)
                                            .cornerRadius(14)
                                            .padding(.trailing, 16)
                                            .padding(.top, 60)
                                    }
                                }
                            }

                            // Show Info
                            Text("\(show.firstAirDate.prefix(4)) - \(show.numberOfSeasons) Seasons - ## Followers")
                                .font(Font.custom("Poppins", size: 12).weight(.medium))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .padding(.leading, 16)

                            // Series Overview with expand/collapse functionality
                            VStack(alignment: .leading) {
                                Text("Series Overview")
                                    .font(Font.custom("Poppins", size: 12).weight(.medium))
                                    .foregroundColor(.white)
                                    .padding(.leading, 16)
                                    .padding(.top, 10)

                                Text(show.overview)
                                    .font(Font.custom("Poppins", size: 12).weight(.regular))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .lineLimit(isOverviewExpanded ? nil : 3)
                                    .onTapGesture {
                                        withAnimation {
                                            isOverviewExpanded.toggle()
                                        }
                                    }
                                if !isOverviewExpanded {
                                    Text("... more")
                                        .font(Font.custom("Poppins", size: 12).weight(.regular))
                                        .foregroundColor(.blue)
                                        .padding(.leading, 16)
                                        .onTapGesture {
                                            withAnimation {
                                                isOverviewExpanded.toggle()
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        

                        VStack(spacing: 20) {
                            // Review Button
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 364, height: 49)
                                    .background(Color(red: 0.47, green: 0.21, blue: 0.38))
                                    .cornerRadius(12)
                                Text("REVIEW THE SERIES")
                                    .font(Font.custom("Poppins", size: 14))
                                    .tracking(1)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 364, height: 49)
                            .padding(.top, 22)

                            // Series Ratings Distribution
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 364, height: 179)
                                    .background(Color(red: 0.47, green: 0.21, blue: 0.38))
                                    .cornerRadius(12)
                                VStack {
                                    Text("SERIES RATINGS DISTRIBUTION")
                                        .font(Font.custom("Poppins", size: 14))
                                        .tracking(1)
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Spacer()
                                    Text("VIEW MORE STATS")
                                        .font(Font.custom("Poppins", size: 10))
                                        .tracking(1)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 10)
                                }
                            }
                            .frame(width: 364, height: 179)

                            // Seasons
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 364, height: 300)
                                    .background(Color(red: 0.47, green: 0.21, blue: 0.38))
                                    .cornerRadius(12)
                                VStack {
                                    HStack {
                                        Text("SEASONS")
                                            .font(Font.custom("Poppins", size: 14))
                                            .tracking(1)
                                            .foregroundColor(.white)
                                            .padding(.leading, 20)
                                        Spacer()
                                        Text("VIEW ALL >")
                                            .font(Font.custom("Poppins", size: 10))
                                            .tracking(1)
                                            .foregroundColor(.white)
                                            .padding(.trailing, 20)
                                    }
                                    .padding(.top, 10)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            // Display Season Posters
                                            ForEach(viewModel.seasons, id: \.id) { season in
                                                VStack {
                                                    if let posterPath = season.posterPath, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                                                        AsyncImage(url: posterURL) { image in
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fill)
                                                                .frame(width: 146, height: 216)
                                                                .cornerRadius(16)
                                                                .padding(.horizontal, 8)
                                                        } placeholder: {
                                                            Rectangle()
                                                                .fill(Color(red: 0.85, green: 0.85, blue: 0.85))
                                                                .frame(width: 146, height: 216)
                                                                .cornerRadius(16)
                                                                .padding(.horizontal, 8)
                                                        }
                                                    } else {
                                                        Rectangle()
                                                            .foregroundColor(.clear)
                                                            .frame(width: 146, height: 216)
                                                            .cornerRadius(18)
                                                            .padding(.horizontal, 5)
                                                            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                                            
                                                    }
                                                    Text("Season \(season.seasonNumber)")
                                                        .font(Font.custom("Poppins-Bold", size: 14))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.vertical, 10)
                                }
                            }
                            .frame(width: 364, height: 330)

                            // Tabs
                            HStack(spacing: 10) {
                                tabView(text: "Discussions")
                                tabView(text: "Lists")
                                tabView(text: "Cast")
                                tabView(text: "Polls")
                                tabView(text: "Reviews")
                            }
                            .frame(width: 359, height: 37.96)
                            .padding(.bottom, 20)
                        }
                        .padding(.top, 430) // Adjust top padding as necessary to be just below the overview
                    }
                } else {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .onAppear {
                viewModel.fetchShowDetails(showId: viewModel.show?.id ?? 0)
                viewModel.fetchShowImages(showId: viewModel.show?.id ?? 0)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    @ViewBuilder
    private func tabView(text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(text)
                .font(Font.custom("Poppins", size: 12))
                .foregroundColor(.white)
        }
        .padding(10)
        .frame(height: 34.97)
        .background(Color(red: 0.47, green: 0.21, blue: 0.38))
        .cornerRadius(8)
    }
}















