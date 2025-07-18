////
////  MoviesNowViewModel.swift
////  Cinelogues
////
////  Created by AJ on 18/07/25.
////
//import Foundation
//
//class MoviesNowViewModel {
//    
//    private(set) var popularMovies: [Movie] = []
//    private(set) var nowPlayingMovies: [Movie] = []
//    private(set) var upcomingMovies: [Movie] = []
//   
//    
//    var movies: [Movie] = []
//    
//    private var isFetching: [MovieCategory: Bool] = [
//        .popular: false,
//        .nowPlaying: false,
//        .upcoming: false
//    ]
//    
//    private var currentPage: [MovieCategory: Int] = [
//        .popular: 1,
//        .nowPlaying: 1,
//        .upcoming: 1
//    ]
//    
//    var onMoviesUpdated: ((MovieCategory) -> Void)?
//    var onError: ((MovieCategory, String) -> Void)?
//    
//    
//    func fetchMovies(for category: MovieCategory) {
//        guard isFetching[category] == false else { return }
//        
//        isFetching[category] = true
//        
//        MovieListService.shared.fetchMovies(for: category, page: currentPage[category] ?? 1) { [weak self] result in
//            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                self.isFetching[category] = false
//                
//                switch result {
//                case .success(let newMovies):
//                    switch category {
//                    case .popular:
//                        self.popularMovies += newMovies
//                    case .nowPlaying:
//                        self.nowPlayingMovies += newMovies
//                    case .upcoming:
//                        self.upcomingMovies += newMovies
//                    }
//                    
//                    self.currentPage[category, default: 1] += 1
////                    self.onMoviesUpdated?(category)
//                    
//                case .failure(let error):
//                    self.onError?(category, error.localizedDescription)
//                }
//            }
//        }
//    }
//    
//    func resetAndFetch(for category: MovieCategory) {
//        currentPage[category] = 1
//        isFetching[category] = false
//        
//        switch category {
//        case .popular: popularMovies = []
//        case .nowPlaying: nowPlayingMovies = []
//        case .upcoming: upcomingMovies = []
//        }
//        
//        fetchMovies(for: category)
//    }
//    
//}
