//
//  PopularMovieCarouselCell.swift
//  Cinelogues
//
//  Created by AJ on 17/07/25.
//

import UIKit

class PopularMovieCarouselCell: UICollectionViewCell {
    
    @IBOutlet weak var carouselImageView: UIImageView!
    static let identifier = "PopularMovieCarouselCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        carouselImageView.frame = contentView.bounds
    }
    
    
    func configure(with posterPath: String) {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        // Load image (use Kingfisher or URLSession)
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.carouselImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
}
