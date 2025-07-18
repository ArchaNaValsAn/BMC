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
      
    }
    
    func configure(with movie: Movie, isFavorited: Bool) {
        self.isFavorited = isFavorited
        self.movie = movie
        movieTitleLabel.text = movie.title
        averageRatingLabel.text = "⭐️ \(movie.voteAverage)"
        
        posterImageView.loadImage(from: movie.posterPath)
        favoriteButton.updateFavoriteAppearance(isFavorited: isFavorited)
        
    }
    
    private func updateUIElements() {
        movieTitleLabel.textColor = .white
        averageRatingLabel.textColor = .white
        
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        isFavorited.toggle()
        favoriteButton.updateFavoriteAppearance(isFavorited: isFavorited)
        favoriteButtonTapped?(isFavorited)
        guard let movie = movie else { return }
        let movieID = String(movie.id)
           if FavoriteMovieManager.shared.isFavorite(movieID: movieID) {
               FavoriteMovieManager.shared.removeFromFavorites(movieID: movieID)
           } else {
               FavoriteMovieManager.shared.addToFavorites(movie: movie)
           }
    }
    
}
