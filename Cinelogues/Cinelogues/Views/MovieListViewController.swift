//
//  ViewController.swift
//  Cinelogues
//
//  Created by AJ on 17/07/25.
//

import UIKit

class MovieListViewController: UIViewController {
    
    private let viewModel = MovieListViewModel()
    private var movies: [Movie] = []
    private var category: MovieCategory = .popular

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchMovies(for: category)
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    func didUpdateMovies(for category: MovieCategory, movies: [Movie]) {
        self.movies = movies
        self.category = category
    }
    
    
}

