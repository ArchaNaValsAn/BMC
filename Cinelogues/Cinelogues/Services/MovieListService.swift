//
//  MovieListService.swift
//  Cinelogue
//
//  Created by AJ on 17/07/25.
//

import Foundation

enum MovieCategory: String, CaseIterable {
    case popular = "popular"
    case nowPlaying = "now_playing"
    case upcoming = "upcoming"
    
    var title: String {
        switch self {
        case .popular: return "Popular"
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}

class MovieListService {
    static let shared = MovieListService()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
     
    func fetchMovies(for category: MovieCategory, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(APIConfig.baseURL)\(category.rawValue)?api_key=\(APIConfig.apiKey)&language=en-US&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let response = try JSONDecoder().decode(MovieListResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

