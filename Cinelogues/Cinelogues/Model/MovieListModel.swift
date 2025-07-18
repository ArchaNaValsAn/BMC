//
//  MovieListModel.swift
//  Cinelogue
//
//  Created by AJ on 17/07/25.
//

import Foundation

struct MovieListResponse: Codable {
    let dates: Dates?
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Codable {
    let maximum, minimum: String
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let backdropPath: String
    let releaseDate: String
    let voteAverage: Double
    let genreIDS: [Int]
    let originalLanguage: String

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
    }
}

import Foundation

extension Movie {
    init?(from entity: FavoriteMoviesEntity) {
        guard let idString = entity.id,
              let id = Int(idString),
              let title = entity.title,
              let overview = entity.overview,
              let posterPath = entity.posterPath,
              let backdropPath = entity.backdropPath,
              let releaseDate = entity.releaseDate,
              let originalLanguage = entity.originalLanguage else {
            return nil
        }

        let genreIDs = entity.genreIDS?
            .split(separator: ",")
            .compactMap { Int($0) } ?? []

        self.init(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: entity.voteAverage,
            genreIDS: genreIDs,
            originalLanguage: originalLanguage
        )
    }
}



