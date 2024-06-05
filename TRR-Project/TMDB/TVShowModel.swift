//
//  TVShowModel.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/20/24.
//

import Foundation

struct TVShow: Codable, Identifiable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Float
    let genres: [Genre]
    let firstAirDate: String
    let lastAirDate: String?
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let originalLanguage: String
    let originalName: String
    let status: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case genres
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case status
        case type
    }
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct TVSeason: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let seasonNumber: Int
    let episodes: [TVEpisode]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case episodes
    }
}

struct TVEpisode: Codable, Identifiable {
    let id: Int
    let name: String
    let episodeNumber: Int
    let overview: String
    let airDate: String
    let stillPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case episodeNumber = "episode_number"
        case overview
        case airDate = "air_date"
        case stillPath = "still_path"
    }
}

struct TMDbImages: Codable {
    let logos: [ImageData]
    let backdrops: [ImageData]
    let posters: [ImageData]
}

struct ImageData: Codable {
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}



