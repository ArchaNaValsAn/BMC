//
//  MovieListViewModel.swift
//  Cinelogue
//
//  Created by AJ on 17/07/25.
//

import Foundation

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
//    func didUpdateMovies(for category: MovieCategory, movies: [Movie])
    func didUpdateCombinedMovies(_ movies: [Movie])
}

class MovieListViewModel {
    
    private var currentPage: [MovieCategory: Int] = [
        .popular: 1,
        .nowPlaying: 1,
        .upcoming: 1
    ]
    
    private var isFetching: [MovieCategory: Bool] = [
        .popular: false,
        .nowPlaying: false,
        .upcoming: false
    ]
    
    private(set) var popularMovies: [Movie] = []
    private(set) var nowPlayingMovies: [Movie] = []
    private(set) var upcomingMovies: [Movie] = []
    private(set) var allMovies: [Movie] = []
    
    var onMoviesUpdated: ((MovieCategory) -> Void)?
    var onError: ((MovieCategory, String) -> Void)?
    
    weak var delegate: MovieListViewModelDelegate?
    
    func fetchMovies(for category: MovieCategory) {
        guard isFetching[category] == false else { return }
        
        isFetching[category] = true
        
        MovieListService.shared.fetchMovies(for: category, page: currentPage[category] ?? 1) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isFetching[category] = false
                
                switch result {
                case .success(let newMovies):
                    switch category {
                    case .popular:
                        self.popularMovies += newMovies
                    case .nowPlaying:
                        self.nowPlayingMovies += newMovies
                    case .upcoming:
                        self.upcomingMovies += newMovies
                    }
                    
                    self.currentPage[category, default: 1] += 1
                    self.onMoviesUpdated?(category)
                   // self.delegate?.didUpdateMovies(for: category, movies: newMovies)
                    
                case .failure(let error):
                    self.onError?(category, error.localizedDescription)
                }
            }
        }
    }
    
    func fetchAllCategories() {
            let group = DispatchGroup()
            var allMovies: [Movie] = []

            let categories: [MovieCategory] = [.popular, .nowPlaying, .upcoming]

            for category in categories {
                group.enter()
                MovieListService.shared.fetchMovies(for: category) { result in
                    switch result {
                    case .success(let movies):
                        allMovies += movies
                    case .failure(let error):
                        print("Error fetching \(category): \(error)")
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.allMovies = allMovies
                self.delegate?.didUpdateCombinedMovies(allMovies)
            }
        }
    
    func resetAndFetch(for category: MovieCategory) {
        currentPage[category] = 1
        isFetching[category] = false
        
        switch category {
        case .popular: popularMovies = []
        case .nowPlaying: nowPlayingMovies = []
        case .upcoming: upcomingMovies = []
        }
        
        fetchMovies(for: category)
    }
}



