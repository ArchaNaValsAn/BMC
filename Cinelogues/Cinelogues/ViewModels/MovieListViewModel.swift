//
//  MovieListViewModel.swift
//  Cinelogue
//
//  Created by AJ on 17/07/25.
//

import Foundation
import UIKit

protocol MovieListViewModelDelegate: AnyObject {
    func didUpdateCombinedMovies(_ movies: [Movie])
    func didUpdateCurrentIndex(to index: Int)
    func didRequestScrollToIndex(_ index: Int)
    func didFailToLoadMovies()  // Added for alert navigation
}

class MovieListViewModel {
    
    // MARK: - Properties
    
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
    
    weak var delegate: MovieListViewModelDelegate?
    
    private var autoScrollTimer: Timer?
    private var currentCarouselIndex = 0
    
    var topFiveMovies: [Movie] {
        Array(allMovies.prefix(5))
    }
    
    var repeatedMovies: [Movie] {
        guard !topFiveMovies.isEmpty else { return [] }
        return Array(repeating: topFiveMovies, count: 1000).flatMap { $0 }
    }
    
    // MARK: - Public Accessors
    
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
    
    // MARK: - Fetching Movies with Error/Empty Handling
    
    func fetchAllCategories() {
        let group = DispatchGroup()
        var combinedMovies: [Movie] = []
        var encounteredError: Error?
        
        let categories: [MovieCategory] = [.popular, .nowPlaying, .upcoming]
        
        for category in categories {
            group.enter()
            MovieListService.shared.fetchMovies(for: category) { result in
                defer { group.leave() }
                switch result {
                case .success(let movies):
                    combinedMovies += movies
                case .failure(let error):
                    print("Error fetching \(category): \(error)")
                    encounteredError = error
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            if combinedMovies.isEmpty {
                if let error = encounteredError {
                    self.presentAlert(message: "Failed to load movies: \(error.localizedDescription)")
                } else {
                    self.presentAlert(message: "No movies found. Please try again later.")
                }
                return
            }
            
            self.allMovies = combinedMovies
            self.delegate?.didUpdateCombinedMovies(combinedMovies)
            self.resetCurrentIndex()
            self.startAutoScroll()
        }
    }
    
    // MARK: - Timer
    
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
    
    // MARK: - Alert Handling
    
    private func presentAlert(message: String) {
        DispatchQueue.main.async {
            if let topVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.delegate?.didFailToLoadMovies()
                }))
                topVC.present(alert, animated: true, completion: nil)
            }
        }
    }
}



