//
//  MoviesCollectionViewCell.swift
//  Cinelogues
//
//  Created by AJ on 18/07/25.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MoviesCollectionViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var isFavorited = false
    private var movie: Movie?
    
    var favoriteButtonTapped: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUIElements()
        
        posterImageView.accessibilityIdentifier = "posterImageView"
        movieTitleLabel.accessibilityIdentifier = "movieTitleLabel"
        averageRatingLabel.accessibilityIdentifier = "averageRatingLabel"
        favoriteButton.accessibilityIdentifier = "favoriteButton"
        
    }
    
    func configure(with movie: Movie, isFavorited: Bool) {
        self.isFavorited = isFavorited
        self.movie = movie
        movieTitleLabel.text = movie.title
        averageRatingLabel.text = "⭐️ \(movie.voteAverage)"
        
        posterImageView.loadImage(from: movie.posterPath)
        favoriteButton.updateFavoriteAppearance(isFavorited: isFavorited)
        
    }
    
    func updateFavoriteState(isFavorited: Bool) {
        self.isFavorited = isFavorited
        favoriteButton.updateFavoriteAppearance(isFavorited: isFavorited)
    }
    
    private func updateUIElements() {
        movieTitleLabel.textColor = .white
        averageRatingLabel.textColor = .white
        
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        isFavorited.toggle()
        favoriteButton.updateFavoriteAppearance(isFavorited: isFavorited)
        
        guard let movie = movie else { return }
        let movieID = String(movie.id)
        
        if isFavorited {
            FavoriteMovieManager.shared.addToFavorites(movie: movie)
        } else {
            FavoriteMovieManager.shared.removeFromFavorites(movieID: movieID)
        }
        NotificationCenter.default.post(name: .favoritesUpdated, object: movieID)
        
        favoriteButtonTapped?(isFavorited)
    }
    
}
