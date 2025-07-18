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
    private var movies: [Movie] = []
    
    var favoriteButtonTapped: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUIElements()
      
    }
    
    func configure(with movie: Movie, isFavorited: Bool) {
            self.isFavorited = isFavorited
        movieTitleLabel.text = movie.title
        //releaseYearLabel.text = movie.releaseDate
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
    }
    
}
