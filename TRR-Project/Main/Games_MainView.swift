import SwiftUI

struct Games_MainView: View {
    @State private var navigateToRealitease = false
    @State private var navigateToGame = false
    @StateObject private var realiteaseManager = RealiteaseManager()
    
    // Format current date and the previous day's date
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        return formatter.string(from: Date())
    }
    
    private var previousDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            return "Unknown"
        }
        return formatter.string(from: yesterday)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 40)
            
            CustomHeaderView(bannerImageName: "TRRGames-Banner")
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack {
                        Text("HELLO.")
                            .font(Font.custom("Poppins", size: 28).weight(.black))
                            .foregroundColor(.black)
                        
                        Text("choose a game to play.")
                            .font(Font.custom("Poppins", size: 18).weight(.medium))
                            .foregroundColor(.black)
                    }
                    .padding(.top, 1)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 1) {
                            Button(action: {
                                navigateToRealitease.toggle()
                            }) {
                                GameCardView(title: "REALITEASE", description: "GUESS THE REALITY TV STAR", date: currentDate, color: Color(red: 0.45, green: 0.66, blue: 0.73))
                            }
                            .fullScreenCover(isPresented: $navigateToRealitease) {
                                RealiteaseCoverView(navigateToRealitease: $navigateToRealitease, navigateToGame: $navigateToGame, manager: realiteaseManager)
                            }
                            .fullScreenCover(isPresented: $navigateToGame) {
                                RealiteaseGameView(manager: realiteaseManager, navigateToRealitease: $navigateToRealitease, navigateToGame: $navigateToGame)
                            }
                            PreviousGameCardView(date: previousDate)
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 1) {
                            GameCardView(title: "REALATIONS", description: "MAKE 4 GROUPS OF 4", date: currentDate, color: Color(red: 0.47, green: 0.21, blue: 0.38))
                            PreviousGameCardView(date: previousDate)
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 1) {
                            GameCardView(title: "REALIMINI", description: "SOLVE THE MINI CROSSWORD PUZZLE", date: currentDate, color: Color(red: 0.61, green: 0.60, blue: 0.09))
                            PreviousGameCardView(date: previousDate)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 30)
                }
                .padding(.vertical)
            }
        }
        .background(Color(red: 0.91, green: 0.91, blue: 0.91))
        .edgesIgnoringSafeArea(.all)
    }
}

struct GameCardView: View {
    var title: String
    var description: String
    var date: String
    var color: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(color)
                .cornerRadius(10)
                .frame(width: 359.54, height: 157)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(Font.custom("Poppins-Bold", size: 24).weight(.bold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(Font.custom("Poppins-Medium", size: 12).weight(.medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(date)
                    .font(Font.custom("Poppins", size: 20).weight(.medium))
                    .tracking(-1)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(width: 359.54, height: 147, alignment: .leading)
        }
    }
}

struct PreviousGameCardView: View {
    var date: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(Color.black)
                .cornerRadius(10)
                .frame(width: 157, height: 157)
            
            VStack {
                Text(date)
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}

struct Games_MainView_Previews: PreviewProvider {
    static var previews: some View {
        Games_MainView()
    }
}







