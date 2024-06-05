//
//  Realitease_FirestoreService.swift
//  TRR-Project
//
//  Created by thomas hulihan on 6/1/24.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Realitease_FirestoreService {
    func fetchTodayAnswer(completion: @escaping (RealiteaseAnswerKey?) -> Void) {
        let db = Firestore.firestore()
        let todayString = getTodayString()
        db.collection("realitease_answerkey").document(todayString).getDocument { document, error in
            if let document = document, document.exists {
                do {
                    let answerKey = try document.data(as: RealiteaseAnswerKey.self)
                    completion(answerKey)
                } catch {
                    print("Error decoding answer key for date \(todayString): \(error)")
                    completion(nil)
                }
            } else {
                print("No answer key found for today.")
                completion(nil)
            }
        }
    }

    func fetchAllCastNames(completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        db.collection("realitease_data").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                let castNames = snapshot.documents.compactMap { document in
                    return document.data()["CastName"] as? String
                }
                completion(castNames)
            }
        }
    }

    func fetchCorrectCastInfo(castID: Int, completion: @escaping (RealiteaseCastInfo?) -> Void) {
        let db = Firestore.firestore()
        db.collection("realitease_data").document("\(castID)").getDocument { document, error in
            if let document = document, document.exists {
                do {
                    let castInfo = try document.data(as: RealiteaseCastInfo.self)
                    completion(castInfo)
                } catch {
                    print("Error decoding cast info for ID \(castID): \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }

    func submitGuess(_ guess: String, correctCastInfo: RealiteaseCastInfo, searchResults: [String], completion: @escaping (GameResult, Guess?) -> Void) {
        let db = Firestore.firestore()
        if let guessedCastName = searchResults.first(where: { $0 == guess }) {
            db.collection("realitease_data").whereField("CastName", isEqualTo: guessedCastName).getDocuments { snapshot, error in
                if let document = snapshot?.documents.first {
                    do {
                        let guessedCastInfo = try document.data(as: RealiteaseCastInfo.self)
                        let newGuess = Guess(name: guessedCastInfo.CastName, guessedInfo: guessedCastInfo)
                        if newGuess.guessedInfo.CastID == correctCastInfo.CastID {
                            completion(.won, newGuess)
                        } else if searchResults.count >= 5 {
                            completion(.lost, newGuess)
                        } else {
                            completion(.ongoing, newGuess)
                        }
                    } catch {
                        print("Error decoding guessed cast info: \(error)")
                        completion(.ongoing, nil)
                    }
                } else {
                    print("No document found for guessed cast name: \(guessedCastName)")
                    completion(.ongoing, nil)
                }
            }
        } else {
            print("No matching cast name found for guess: \(guess)")
            completion(.ongoing, nil)
        }
    }

    private func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}


