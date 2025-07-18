//
//  MovieListViewModel.swift
//  Cinelogue
//
//  Created by AJ on 17/07/25.
//

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    func didUpdateCombinedMovies(_ movies: [Movie])
    func didUpdateCurrentIndex(to index: Int)
    func didRequestScrollToIndex(_ index: Int)  // NEW
}


class MovieListViewModel {
    
    // Pagination state per category
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
    
    // Delegate
    weak var delegate: MovieListViewModelDelegate?
    
    // Timer and carousel control
    private var autoScrollTimer: Timer?
    private var currentCarouselIndex = 0
    
    // To limit the carousel to top 5 movies
    var topFiveMovies: [Movie] {
        Array(allMovies.prefix(5))
    }
    
    // Repeat movies many times to simulate infinite scroll
    var repeatedMovies: [Movie] {
        guard !topFiveMovies.isEmpty else { return [] }
        return Array(repeating: topFiveMovies, count: 1000).flatMap { $0 }
    }
    
    // Public accessors for view controller
    
    func itemCount() -> Int {
        repeatedMovies.count
    }
    
    func movie(at index: Int) -> Movie {
        repeatedMovies[index]
    }
    
    func currentIndex() -> Int {
        currentCarouselIndex
    }
    
    func resetCurrentIndex() {
        currentCarouselIndex = (repeatedMovies.count / 2) - ((repeatedMovies.count / 2) % topFiveMovies.count)
        delegate?.didUpdateCurrentIndex(to: currentCarouselIndex % topFiveMovies.count)
    }
    
    func updateCurrentIndex(_ index: Int) {
        currentCarouselIndex = index
        delegate?.didUpdateCurrentIndex(to: currentCarouselIndex % topFiveMovies.count)
    }
    
    // Fetch movies from service and notify VC
    func fetchAllCategories() {
        let group = DispatchGroup()
        var combinedMovies: [Movie] = []
        
        let categories: [MovieCategory] = [.popular, .nowPlaying, .upcoming]
        
        for category in categories {
            group.enter()
            MovieListService.shared.fetchMovies(for: category) { [weak self] result in
                defer { group.leave() }
                switch result {
                case .success(let movies):
                    combinedMovies += movies
                case .failure(let error):
                    print("Error fetching \(category): \(error)")
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.allMovies = combinedMovies
            self.delegate?.didUpdateCombinedMovies(combinedMovies)
            self.resetCurrentIndex()
            self.startAutoScroll()
        }
    }
    
    // Timer control
    
    func startAutoScroll() {
        stopAutoScroll()
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                               target: self,
                                               selector: #selector(autoScrollToNext),
                                               userInfo: nil,
                                               repeats: true)
    }
    
    func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    @objc private func autoScrollToNext() {
        guard !repeatedMovies.isEmpty else { return }
        currentCarouselIndex += 1

        if currentCarouselIndex >= repeatedMovies.count - topFiveMovies.count {
            resetCurrentIndex()
        }
        
        delegate?.didRequestScrollToIndex(currentCarouselIndex)
        delegate?.didUpdateCurrentIndex(to: currentCarouselIndex % topFiveMovies.count)
    }

    
    deinit {
        stopAutoScroll()
    }
}



