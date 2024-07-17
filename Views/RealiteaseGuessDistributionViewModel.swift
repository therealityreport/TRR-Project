import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class RealiteaseGuessDistributionViewModel: ObservableObject {
    @Published var guessDistribution: [Int: Int] = [:]
    @Published var recentGuessNumberSolved: Int?
    private var db = Firestore.firestore()
    
    func fetchGuessDistribution() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let collectionRef = db.collection("user_analytics").document(userId).collection("realitease_guessDistribution")
        
        collectionRef.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents found: \(String(describing: error?.localizedDescription))")
                return
            }
            
            var tempGuessDistribution: [Int: Int] = [:]
            let todayDateString = self.getTodayDateString()
            
            for document in documents {
                if let guessNumber = Int(document.documentID), let guessCount = document.data()["guessCount"] as? Int {
                    tempGuessDistribution[guessNumber] = guessCount
                }
            }
            
            // Fetch the recent guess number solved for today
            let userStatsCollectionRef = self.db.collection("user_analytics").document(userId).collection("realitease_userstats")
            userStatsCollectionRef.whereField("puzzleDate", isEqualTo: todayDateString).getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No user stats documents found for today: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                var tempRecentGuessNumberSolved: Int?
                for document in documents {
                    if let guessNumberSolved = document.data()["guessNumberSolved"] as? Int, document.data()["win"] as? Bool == true {
                        tempRecentGuessNumberSolved = guessNumberSolved
                    }
                }
                
                DispatchQueue.main.async {
                    self.guessDistribution = tempGuessDistribution
                    self.recentGuessNumberSolved = tempRecentGuessNumberSolved
                    print("Fetched guess distribution: \(self.guessDistribution)")
                    print("Recent guess number solved: \(String(describing: self.recentGuessNumberSolved))")
                }
            }
        }
    }
    
    private func getTodayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: Date())
    }
}
