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
    
    @IBOutlet weak var moreButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUIElements()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        carouselImageView.frame = contentView.bounds
    }
    
    private func updateUIElements() {
        var config = UIButton.Configuration.borderless()
        config.attributedTitle = AttributedString(" Movies", attributes: .init([
            .font: UIFont.italicSystemFont(ofSize: 20)
        ]))
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 0
        config.baseForegroundColor = .white
        moreButton.configuration = config

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
    
    @IBAction func moreButtonAction(_ sender: Any) {
        
    }
}
