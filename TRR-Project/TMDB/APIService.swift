//
//  APIService.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/20/24.
//
import Foundation
import Combine

class APIService {
    static let shared = APIService()
    private let apiKey = "5e8c5bc6086ec860ec57199c780d53b5"
    private let baseURL = "https://api.themoviedb.org/3"

    // Fetch list details from TMDb
    func fetchListDetails(listId: String) -> AnyPublisher<TMDbList, Error> {
        guard let url = URL(string: "\(baseURL)/list/\(listId)?api_key=\(apiKey)") else {
            fatalError("Invalid URL")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: TMDbList.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Fetch show details from TMDb
    func fetchShowDetails(showId: Int) -> AnyPublisher<TVShow, Error> {
        guard let url = URL(string: "\(baseURL)/tv/\(showId)?api_key=\(apiKey)") else {
            fatalError("Invalid URL")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                // Print the raw JSON response for debugging
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print(json)
                }
                return data
            }
            .decode(type: TVShow.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Fetch show images from TMDb
    func fetchShowImages(showId: Int) -> AnyPublisher<TMDbImages, Error> {
        guard let url = URL(string: "\(baseURL)/tv/\(showId)/images?api_key=\(apiKey)") else {
            fatalError("Invalid URL")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: TMDbImages.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Fetch season details from TMDb
    func fetchSeasonDetails(showId: Int, seasonNumber: Int) -> AnyPublisher<TVSeason, Error> {
        guard let url = URL(string: "\(baseURL)/tv/\(showId)/season/\(seasonNumber)?api_key=\(apiKey)") else {
            fatalError("Invalid URL")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: TVSeason.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Fetch episode details from TMDb
    func fetchEpisodeDetails(showId: Int, seasonNumber: Int, episodeNumber: Int) -> AnyPublisher<TVEpisode, Error> {
        guard let url = URL(string: "\(baseURL)/tv/\(showId)/season/\(seasonNumber)/episode/\(episodeNumber)?api_key=\(apiKey)") else {
            fatalError("Invalid URL")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: TVEpisode.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}



