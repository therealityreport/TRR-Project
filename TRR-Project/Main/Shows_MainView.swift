//
//  Shows_MainView.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/9/24.
//

import SwiftUI
import Combine

struct Shows_MainView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var selectedCategory: Category = categories.first!

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)  // Background color
                VStack {
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(red: 0.9137, green: 0.7333, blue: 0.1098, opacity: 1.0))
                            .edgesIgnoringSafeArea(.all)  // This will make the rectangle extend to the edges
                            .frame(height: 227)
                            .offset(y: -20)
                        VStack {
                            Spacer()
                                .frame(width: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            header
                            searchBar
                            Spacer()
                                .frame(height: 20.0)
                        }
                    }

                    categoryTabs
                    Spacer()
                        .frame(height: 10.0)
                    showCards
                }
            }
            .navigationBarHidden(true)
        }
        .accentColor(.yellow)  // Highlight color for the tab bar items, if needed
    }

    var header: some View {
        Text("Home.")
            .font(.custom("Poppins-Bold", size: 40))
            .lineSpacing(1.44)
            .foregroundColor(Color(red: 0.98, green: 0.94, blue: 0.88))
            .tracking(-2)
            .padding([.top, .trailing], 41.0)
            .padding(.trailing, 180.0)
            .offset(y: 5)
    }

    var searchBar: some View {
        TextField("Search", text: .constant(""))
            .font(.custom("Poppins-Light", size: 18))
            .padding(EdgeInsets(top: 8, leading: 30, bottom: 8, trailing: 30))
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 25.0)
            .offset(y: -20)
    }

    var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories) { category in
                    CategoryTab(title: category.title, isSelected: category.id == selectedCategory.id) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    var showCards: some View {
        ShowListView(listId: selectedCategory.listId)
    }

    struct CategoryTab: View {
        var title: String
        var isSelected: Bool
        var action: () -> Void

        var body: some View {
            Text(title)
                .font(.custom("Poppins-Semibold", size: 16))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(isSelected ? Color("AccentPurple") : Color.gray)
                .cornerRadius(8)
                .foregroundColor(.white)
                .onTapGesture {
                    action()
                }
        }
    }
}

// Define ShowCard to take a show object
struct ShowCard: View {
    var show: TMDbShow

    var body: some View {
        NavigationLink(destination: ShowView(viewModel: ShowViewModel(showId: show.id))) {
            ZStack(alignment: .bottomLeading) {
                if let backdropPath = show.backdropPath {
                    let backdropURL = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
                    AsyncImage(url: backdropURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 305, height: 164)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 305, height: 154)
                    }

                    Text(show.name)
                        .font(.custom("Poppins-Black", size: 18))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.6), radius: 8, x: 2, y: 2)
                        .padding([.bottom, .leading], 10.0)
                        .frame(width: 305 - 20, alignment: .leading) // Ensure text stays within the padding
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 305, height: 154)
                    ProgressView()
                        .frame(width: 305, height: 154)
                }
            }
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
}

// Define ShowListView to fetch and display shows based on the list ID
struct ShowListView: View {
    @ObservedObject private var listViewModel: ListViewModel

    init(listId: String) {
        listViewModel = ListViewModel()
        listViewModel.fetchListDetails(listId: listId)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                ForEach(listViewModel.shows) { show in
                    ShowCard(show: show)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}




// Define Show struct here, including id only
struct Category: Identifiable {
    let id = UUID()
    let title: String
    let listId: String
}

let categories = [
    Category(title: "Airing Now", listId: "8300965"),
    Category(title: "Real Housewives", listId: "8300956")
]



// Preview Provider
struct Shows_MainView_Previews: PreviewProvider {
    static var previews: some View {
        Shows_MainView().environmentObject(AuthenticationViewModel())
    }
}





