//
//  PopularMovieCarouselCell.swift
//  Cinelogues
//
//  Created by AJ on 17/07/25.
//

import UIKit

protocol PopularMovieCarouselCellDelegate: AnyObject {
    func didTapMoreButton(from cell: PopularMovieCarouselCell)
}

class PopularMovieCarouselCell: UICollectionViewCell {
    
    @IBOutlet private weak var carouselImageView: UIImageView!
    @IBOutlet private weak var moreButton: UIButton!
    
    static let identifier = "PopularMovieCarouselCell"
    weak var delegate: PopularMovieCarouselCellDelegate?
    
    private var movie: Movie?
    private var dataTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        
        carouselImageView.accessibilityIdentifier = "carouselImageView"
        moreButton.accessibilityIdentifier = "moreButton"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        carouselImageView.image = nil
        dataTask?.cancel()
        dataTask = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        carouselImageView.frame = contentView.bounds
    }
    
    // MARK: - Button Configuration
    private func configureUI() {
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
    
    // MARK: -Fetching PosterImage
    func configure(with movie: Movie) {
        self.movie = movie
        let posterPath = movie.posterPath
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else {
            carouselImageView.image = nil
            return
        }
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil,
                  let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.carouselImageView.image = image
            }
        }
        dataTask?.resume()
    }
    
    // MARK: - Action Method
    @IBAction private func moreButtonAction(_ sender: Any) {
        delegate?.didTapMoreButton(from: self)
    }
}
