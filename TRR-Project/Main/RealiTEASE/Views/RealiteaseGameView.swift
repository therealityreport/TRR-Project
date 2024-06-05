// RealiteaseGameView.swift
// TRR-Project
//
// Created by thomas hulihan on 5/31/24.
//
import SwiftUI
import Firebase

struct RealiteaseGameView: View {
    @ObservedObject var manager: RealiteaseManager
    @Binding var navigateToRealitease: Bool
    @Binding var navigateToGame: Bool
    @FocusState private var isSearchFocused: Bool
    @State private var showWinnerView = false
    @State private var showLoserView = false
    @State private var showInstructions = false
    @State private var showFeedback = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    navigateToRealitease = false // Navigate back to main view
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
                
                VStack {
                    Image("Realitease-Banner")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    
                    Text("\(getCurrentDate()) - No. \(manager.todayAnswer?.PuzzleNumber ?? 0)")
                        .font(Font.custom("Poppins", size: 14).weight(.medium))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        showInstructions.toggle()
                    }) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.black)
                            .padding()
                    }
                    .sheet(isPresented: $showInstructions) {
                        InstructionView()
                    }
                    
                    Button(action: {
                        showFeedback.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.black)
                            .padding()
                    }
                    .sheet(isPresented: $showFeedback) {
                        FeedbackView()
                    }
                }
            }
            .padding()

            VStack(spacing: 0) {
                SearchBar(text: $manager.searchText)
                    .padding(.vertical, 20)
                    .focused($isSearchFocused)
                    .onChange(of: manager.searchText) { newValue in
                        manager.searchCelebrities()
                    }
                
                if isSearchFocused && !manager.searchResults.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(manager.searchResults.prefix(3), id: \.self) { celebrity in
                            Text(celebrity)
                                .foregroundColor(.black) // Set text color to black
                                .padding()
                                .background(Color.white)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    manager.searchText = celebrity
                                    isSearchFocused = false
                                }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
            }
            .zIndex(1)

            ScrollView {
                VStack(spacing: 0) {
                    HStack(spacing: 8) { // Decreased spacing between columns
                        Text("GUESS")
                            .font(Font.custom("Poppins", size: 11).weight(.medium)) // Increased size by 1
                            .foregroundColor(.black)
                            .frame(width: 76, alignment: .center) // Fixed width and centered
                        
                        Text("GENDER")
                            .font(Font.custom("Poppins", size: 11).weight(.medium)) // Increased size by 1
                            .foregroundColor(.black)
                            .frame(width: 45, alignment: .center) // Fixed width and centered
                        
                        Text("ZODIAC")
                            .font(Font.custom("Poppins", size: 11).weight(.medium)) // Increased size by 1
                            .foregroundColor(.black)
                            .frame(width: 52, alignment: .center) // Fixed width and centered
                        
                        Text("WWHL")
                            .font(Font.custom("Poppins", size: 11).weight(.medium)) // Increased size by 1
                            .foregroundColor(.black)
                            .frame(width: 45, alignment: .center) // Fixed width and centered
                        
                        Text("SHOWS")
                            .font(Font.custom("Poppins", size: 11).weight(.medium)) // Increased size by 1
                            .foregroundColor(.black)
                            .frame(width: 46, alignment: .center) // Fixed width and centered
                        
                        Text("CO-STAR")
                            .font(Font.custom("Poppins", size: 11).weight(.medium)) // Increased size by 1
                            .foregroundColor(.black)
                            .frame(width: 76, alignment: .center) // Fixed width and centered
                    }
                    .padding(.horizontal)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(manager.guesses, id: \.self) { guess in
                            HStack(spacing: 8) {
                                Text(guess.guessedInfo.CastName)
                                    .font(Font.custom("Poppins-Medium", size: 14))
                                    .foregroundColor(.white)
                                    .frame(width: 76, height: 60)
                                    .background(Color("AccentBlue"))
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.center)
                                
                                Text(guess.guessedInfo.Gender == "Male" ? "M" : "F")
                                    .font(Font.custom("Poppins-Light", size: 11))
                                    .foregroundColor(.white)
                                    .frame(width: 45, height: 60)
                                    .background(manager.getColor(for: guess, category: .gender))
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.center)
                                
                                Text(manager.getZodiac(for: guess))
                                    .font(Font.custom("Poppins-Light", size: 11))
                                    .foregroundColor(.white)
                                    .frame(width: 52, height: 60)
                                    .background(manager.getColor(for: guess, category: .zodiac))
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.center)
                                
                                Text("\(guess.guessedInfo.WWHLCount)")
                                    .font(Font.custom("Poppins-Light", size: 11))
                                    .foregroundColor(.white)
                                    .frame(width: 45, height: 60)
                                    .background(manager.getColor(for: guess, category: .wwhl))
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.center)
                                
                                Text("\(guess.guessedInfo.ShowCount)")
                                    .font(Font.custom("Poppins-Light", size: 11))
                                    .foregroundColor(.white)
                                    .frame(width: 46, height: 60)
                                    .background(manager.getColor(for: guess, category: .shows))
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.center)
                                
                                Text(manager.getCoStarDisplayText(for: guess))
                                    .font(Font.custom("Poppins-Light", size: 11))
                                    .foregroundColor(.white)
                                    .frame(width: 76, height: 60)
                                    .background(manager.getColor(for: guess, category: .coStar))
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            
            Button(action: {
                if manager.guesses.contains(where: { $0.guessedInfo.CastName == manager.searchText }) {
                    manager.errorMessage = "Already Guessed"
                } else {
                    manager.submitGuess(manager.searchText) { result in
                        if result == .won {
                            showWinnerView = true
                        } else if result == .lost {
                            showLoserView = true
                        }
                    }
                }
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 318.86, height: 60)
                        .background(Color(red: 0.45, green: 0.66, blue: 0.73))
                        .cornerRadius(18)
                    Text("ENTER")
                        .font(Font.custom("Poppins", size: 18).weight(.bold))
                        .foregroundColor(Color(red: 0.98, green: 0.94, blue: 0.88))
                }
            }
            .padding(.bottom, 10) // Decreased padding for space for error message
            
            if let errorMessage = manager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(Font.custom("Poppins", size: 12).weight(.medium))
                    .padding(.bottom, 20)
            }
        }
        .padding()
        .background(Color.white)
        .onAppear {
            manager.fetchTodayAnswer()
        }
        .sheet(isPresented: $showWinnerView) {
            RealiteaseWinnerView()
        }
        .sheet(isPresented: $showLoserView) {
            RealiteaseLoserView(correctAnswer: manager.correctCastInfo?.CastName ?? "")
        }
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }
}

struct RealiteaseGameView_Previews: PreviewProvider {
    static var previews: some View {
        RealiteaseGameView(manager: RealiteaseManager(), navigateToRealitease: .constant(false), navigateToGame: .constant(true))
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 361.72, height: 55)
                .background(Color(red: 0.68, green: 0.68, blue: 0.68).opacity(0.40))
                .cornerRadius(12)
            TextField("TYPE GUEST HERE", text: $text)
                .font(Font.custom("Poppins", size: 16).weight(.medium))
                .padding(.leading, 15)
                .foregroundColor(.black) // Set text color to black
        }
        .frame(width: 361.72, height: 55)
    }
}

struct InstructionView: View {
    var body: some View {
        VStack {
            Text("Instructions")
                .font(Font.custom("Poppins-Black", size: 20))
                .padding()
            Text("Here are the instructions for the game...")
                .font(Font.custom("Poppins", size: 16))
                .padding()
            Button(action: {
                // Dismiss the view
            }) {
                Text("Close")
                    .font(Font.custom("Poppins", size: 18).weight(.bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct FeedbackView: View {
    var body: some View {
        VStack {
            Text("Feedback and Report a Bug")
                .font(Font.custom("Poppins-Black", size: 20))
                .padding()
            Text("Please provide your feedback or report a bug...")
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


