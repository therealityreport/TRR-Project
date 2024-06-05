//
//  TMDbListViewModel.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/20/24.
//

import Foundation
import Combine

class ListViewModel: ObservableObject {
    @Published var shows: [TMDbShow] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchListDetails(listId: String) {
        APIService.shared.fetchListDetails(listId: listId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching list details: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] list in
                self?.shows = list.items
            })
            .store(in: &cancellables)
    }
}
