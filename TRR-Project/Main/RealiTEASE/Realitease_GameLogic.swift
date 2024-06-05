//
//  Realitease_GameLogic.swift
//  TRR-Project
//
//  Created by thomas hulihan on 6/1/24.
//
import SwiftUI

class Realitease_GameLogic {
    func searchCelebrities(searchText: String, allCastNames: [String]) -> [String] {
        let searchLowercased = searchText.lowercased()
        if !searchLowercased.isEmpty {
            return allCastNames.filter { $0.lowercased().contains(searchLowercased) }
        } else {
            return allCastNames
        }
    }

    func getColor(for guess: Guess, category: GuessCategory, correctCastInfo: RealiteaseCastInfo?) -> Color {
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
                return Color("AccentGreen")
            } else if commonShows.isEmpty {
                return Color("AccentRed")
            } else {
                return Color("AccentYellow")
            }
        @unknown default:
            return Color("AccentGray")
        }
    }

    func getZodiac(for guess: Guess) -> String {
        return guess.guessedInfo.Zodiac
    }

    func getCoStarDisplayText(for guess: Guess, correctCastInfo: RealiteaseCastInfo?) -> String {
        guard let correctCastInfo = correctCastInfo else { return "" }
        let commonShows = Set(guess.guessedInfo.ShowNicknames).intersection(correctCastInfo.ShowNicknames)
        return commonShows.first ?? ""
    }
}


