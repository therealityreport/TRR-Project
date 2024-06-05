// RealiteaseManager.swift

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import SwiftUI

enum GameResult {
    case ongoing
    case won
    case lost
}

class RealiteaseManager: ObservableObject {
    @Published var todayAnswer: RealiteaseAnswerKey?
    @Published var correctCastInfo: RealiteaseCastInfo?
    @Published var guesses: [Guess] = []
    @Published var searchText = ""
    @Published var searchResults: [String] = []
    @Published var errorMessage: String?
    private var allCastNames: [String] = []
    private var db = Firestore.firestore()
    private var stats = GameStats()
    
    init() {
        fetchTodayAnswer()
        fetchAllCastNames()
    }
    
    func fetchTodayAnswer() {
        let todayString = getTodayString()
        db.collection("realitease_answerkey").document(todayString).getDocument { document, error in
            if let document = document, document.exists {
                do {
                    self.todayAnswer = try document.data(as: RealiteaseAnswerKey.self)
                    self.fetchCorrectCastInfo()
                } catch {
                    print("Error decoding answer key for date \(todayString): \(error)")
                }
            } else {
                print("No answer key found for today.")
            }
        }
    }
    
    func fetchAllCastNames() {
        db.collection("realitease_data").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                self.allCastNames = snapshot.documents.compactMap { document in
                    return document.data()["CastName"] as? String
                }
                self.searchResults = self.allCastNames
            }
        }
    }
    
    func fetchCorrectCastInfo() {
        guard let todayAnswer = todayAnswer else { return }
        
        db.collection("realitease_data").document("\(todayAnswer.CastID)").getDocument { document, error in
            if let document = document, document.exists {
                do {
                    self.correctCastInfo = try document.data(as: RealiteaseCastInfo.self)
                } catch {
                    print("Error decoding cast info for ID \(todayAnswer.CastID): \(error)")
                }
            }
        }
    }
    
    func searchCelebrities() {
        let searchLowercased = searchText.lowercased()
        if !searchLowercased.isEmpty {
            searchResults = allCastNames.filter { $0.lowercased().contains(searchLowercased) }
        } else {
            searchResults = allCastNames
        }
    }
    
    func submitGuess(_ guess: String, completion: @escaping (GameResult) -> Void) {
        guard let correctCastInfo = correctCastInfo else { return completion(.ongoing) }
        if let guessedCastName = searchResults.first(where: { $0 == guess }) {
            db.collection("realitease_data").whereField("CastName", isEqualTo: guessedCastName).getDocuments { snapshot, error in
                if let document = snapshot?.documents.first {
                    do {
                        let guessedCastInfo = try document.data(as: RealiteaseCastInfo.self)
                        let newGuess = Guess(name: guessedCastInfo.CastName, guessedInfo: guessedCastInfo)
                        self.guesses.append(newGuess)
                        self.searchText = "" // Clear the search text
                        self.searchResults = self.allCastNames // Reset the search results
                        // Update stats
                        self.stats.numberOfGuesses = self.guesses.count
                        self.stats.lastGuess = newGuess
                        if newGuess.guessedInfo.CastID == correctCastInfo.CastID {
                            self.stats.puzzlesWon += 1
                            self.stats.streak += 1
                            self.stats.lastGuessNumber = self.guesses.count
                            self.stats.winOrLose = "Win"
                            DispatchQueue.main.async {
                                self.objectWillChange.send() // Notify view of changes
                                completion(.won)
                            }
                        } else if self.guesses.count >= 5 {
                            self.stats.winOrLose = "Lose"
                            self.stats.streak = 0
                            DispatchQueue.main.async {
                                self.objectWillChange.send() // Notify view of changes
                                completion(.lost)
                            }
                        } else {
                            completion(.ongoing)
                        }
                    } catch {
                        print("Error decoding guessed cast info: \(error)")
                        completion(.ongoing)
                    }
                } else {
                    print("No document found for guessed cast name: \(guessedCastName)")
                    completion(.ongoing)
                }
            }
        } else {
            print("No matching cast name found for guess: \(guess)")
            completion(.ongoing)
        }
    }
    
    func getColor(for guess: Guess, category: GuessCategory) -> Color {
        guard let correctCastInfo = correctCastInfo else { return Color("AccentGray") }
        
        switch category {
        case .gender:
            return guess.guessedInfo.Gender == correctCastInfo.Gender ? Color("AccentGreen") : Color("AccentRed")
        case .zodiac:
            return guess.guessedInfo.Zodiac == correctCastInfo.Zodiac ? Color("AccentGreen") : Color("AccentRed")
        case .wwhl:
            let diff = abs(guess.guessedInfo.WWHLCount - correctCastInfo.WWHLCount)
            if diff == 0 {
                return Color("AccentGreen")
            } else if diff <= 2 {
                return Color("AccentYellow")
            } else {
                return Color("AccentRed")
            }
        case .shows:
            let diff = abs(guess.guessedInfo.ShowCount - correctCastInfo.ShowCount)
            if diff == 0 {
                return Color("AccentGreen")
            } else if diff <= 1 {
                return Color("AccentYellow")
            } else {
                return Color("AccentRed")
            }
        case .coStar:
            let commonShows = Set(guess.guessedInfo.ShowNicknames).intersection(correctCastInfo.ShowNicknames)
            if !commonShows.isEmpty {
                let sameSeason = commonShows.contains(where: {
                    correctCastInfo.Shows[$0]!.contains(guess.guessedInfo.Shows[$0]!.first!)
                })
                return sameSeason ? Color("AccentGreen") : Color("AccentYellow")
            } else {
                return Color("AccentRed")
            }
        @unknown default:
            return Color("AccentGray")
        }
    }
    
    func getZodiac(for guess: Guess) -> String {
        return guess.guessedInfo.Zodiac
    }
    
    func getCoStarDisplayText(for guess: Guess) -> String {
        guard let correctCastInfo = correctCastInfo else { return "" }
        let commonShows = Set(guess.guessedInfo.ShowNicknames).intersection(correctCastInfo.ShowNicknames)
        return commonShows.first ?? ""
    }
    
    private func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

struct RealiteaseAnswerKey: Identifiable, Codable {
    @DocumentID var id: String?
    var CastID: Int
    var CastName: String
    var Date: String
    var PuzzleNumber: Int
}

struct RealiteaseCastInfo: Identifiable, Codable {
    @DocumentID var id: String?
    var CastID: Int
    var CastName: String
    var Gender: String
    var Birthday: Date
    var ShowCount: Int
    var ShowIDs: [String]
    var ShowNicknames: [String]
    var Shows: [String: [String]]
    var WWHLCount: Int
    var Zodiac: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        let birthdate = formatter.string(from: Birthday)
        return ZodiacSign(birthdate: birthdate)
    }
    
    private func ZodiacSign(birthdate: String) -> String {
        let zodiacSigns = [
            ("Capricorn", "December 22", "January 19"),
            ("Aquarius", "January 20", "February 18"),
            ("Pisces", "February 19", "March 20"),
            ("Aries", "March 21", "April 19"),
            ("Taurus", "April 20", "May 20"),
            ("Gemini", "May 21", "June 20"),
            ("Cancer", "June 21", "July 22"),
            ("Leo", "July 23", "August 22"),
            ("Virgo", "August 23", "September 22"),
            ("Libra", "September 23", "October 22"),
            ("Scorpio", "October 23", "November 21"),
            ("Sagittarius", "November 22", "December 21")
        ]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        
        guard let birthDate = formatter.date(from: birthdate) else {
            return "Unknown"
        }
        
        for (sign, start, end) in zodiacSigns {
            if let startDate = formatter.date(from: start),
               let endDate = formatter.date(from: end) {
                if (birthDate >= startDate && birthDate <= endDate) ||
                    (sign == "Capricorn" && (birthDate >= startDate || birthDate <= endDate)) {
                    return sign
                }
            }
        }
        
        return "Unknown"
    }
}

struct Guess: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var guessedInfo: RealiteaseCastInfo
    
    static func == (lhs: Guess, rhs: Guess) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum GuessCategory {
    case name
    case gender
    case zodiac
    case wwhl
    case shows
    case coStar
}

struct GameStats {
    var numberOfGuesses: Int = 0
    var lastGuess: Guess?
    var lastGuessNumber: Int = 0
    var winOrLose: String = ""
    var puzzlesWon: Int = 0
    var streak: Int = 0
}
