//
//  MovieListService.swift
//  Cinelogue
//
//  Created by AJ on 17/07/25.
//

import Foundation


class MovieListService {
    
    static let shared = MovieListService()
    init(){}
     
    func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
            let endpoint = "\(APIConfig.baseURL)/movie/popular"
            guard var components = URLComponents(string: endpoint) else {
                completion(.failure(URLError(.badURL)))
                return
            }

            components.queryItems = [
                URLQueryItem(name: "api_key", value: APIConfig.apiKey),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)")
            ]

            guard let url = components.url else {
                completion(.failure(URLError(.badURL)))
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
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
