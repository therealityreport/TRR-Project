//
//  TMDbListModel.swift
//  TRR-Project
//
//  Created by thomas hulihan on 5/20/24.
//

import Foundation

struct TMDbList: Codable {
    let id: Int
    let name: String
    let items: [TMDbShow]
}

struct TMDbShow: Codable, Identifiable {
    let id: Int
    let name: String
    let backdropPath: String?
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case backdropPath = "backdrop_path"
        case overview
    }
}

