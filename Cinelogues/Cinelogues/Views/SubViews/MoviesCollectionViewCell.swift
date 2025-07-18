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
    @IBOutlet weak var releaseYearLabel: UILabel!
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
        releaseYearLabel.text = movie.releaseDate
        averageRatingLabel.text = "⭐️ \(movie.voteAverage)"
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                // Load image async (simple)
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.posterImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
            
            updateFavoriteButton()
        }
    
    private func updateUIElements() {
        movieTitleLabel.textColor = .white
        releaseYearLabel.textColor = .white
        averageRatingLabel.textColor = .white
        
    }
    
    private func updateFavoriteButton() {
           let imageName = isFavorited ? "heart.fill" : "heart"
           favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
           favoriteButton.tintColor = isFavorited ? .systemRed : .lightGray
       }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        isFavorited.toggle()
        updateFavoriteButton()
        favoriteButtonTapped?(isFavorited)
    }
    
}
