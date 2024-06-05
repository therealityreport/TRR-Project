//
//  ShowViewModel.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/20/24.
//
import Foundation
import Combine

class ShowViewModel: ObservableObject {
    @Published var show: TVShow?
    @Published var images: TMDbImages?
    @Published var seasons: [TVSeason] = []

    private var cancellables = Set<AnyCancellable>()

    init(showId: Int) {
        fetchShowDetails(showId: showId)
        fetchShowImages(showId: showId)
    }

    func fetchShowDetails(showId: Int) {
        APIService.shared.fetchShowDetails(showId: showId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching show details: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] show in
                self?.show = show
                self?.fetchAllSeasonDetails(showId: show.id)
            })
            .store(in: &cancellables)
    }

    func fetchShowImages(showId: Int) {
        APIService.shared.fetchShowImages(showId: showId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching show images: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] images in
                self?.images = images
            })
            .store(in: &cancellables)
    }

    func fetchAllSeasonDetails(showId: Int) {
            guard let show = show else { return }
            let seasonFetchers = (1...show.numberOfSeasons).map { seasonNumber in
                APIService.shared.fetchSeasonDetails(showId: showId, seasonNumber: seasonNumber)
            }
            
            Publishers.MergeMany(seasonFetchers)
                .collect()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching season details: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] seasons in
                    self?.seasons = seasons.sorted { $0.seasonNumber < $1.seasonNumber }
                })
                .store(in: &cancellables)
        }
    }




