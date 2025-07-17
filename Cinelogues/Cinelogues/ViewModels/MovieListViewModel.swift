//
//  MovieListViewModel.swift
//  Cinelogue
//
//  Created by AJ on 17/07/25.
//

import Foundation

class MovieListViewModel {
    
    
    private(set) var movies: [Movie] = []
    private var currentPage = 1
    private var isFetching = false
    var onMoviesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchMovies() {
        guard !isFetching else { return }
        
        isFetching = true
        MovieListService.shared.fetchPopularMovies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isFetching = false
                switch result {
                case .success(let newMovies):
                    self.movies += newMovies
                    self.currentPage += 1
                    self.onMoviesUpdated?()
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchNextPage() {
        currentPage = 1
        movies = []
        fetchMovies()
    }
}


