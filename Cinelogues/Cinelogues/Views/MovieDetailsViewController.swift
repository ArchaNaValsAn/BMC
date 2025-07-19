//
//  MovieDetailsViewController.swift
//  Cinelogues
//
//  Created by AJ on 18/07/25.
//

import UIKit

class MovieDetailsViewController: UIViewController {
        
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var cardStackView: UIStackView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overViewTextView: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
        
    var movie: Movie?
    private var isFavorited = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurBackground()
        setupCardStackView()
        setupDetails()
        setupAccessibilityIdentifiers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentingViewController?.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
        private func setupBlurBackground() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        blurView.addGestureRecognizer(tapGesture)
    }
    
    private func setupCardStackView() {
        baseView.layer.cornerRadius = 20
        baseView.layer.masksToBounds = true
        baseView.backgroundColor = .black
        
        baseView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        baseView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.baseView.transform = .identity
            self.baseView.alpha = 1
        }
    }
    
    private func setupDetails() {
        guard let movie = movie else { return }
        posterImageView.loadImage(from: movie.posterPath)
        movieTitleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        ratingLabel.text = "⭐️ \(movie.voteAverage)"
        overViewTextView.text = movie.overview
        
        movieTitleLabel.textColor = .white
        releaseDateLabel.textColor = .white
        ratingLabel.textColor = .white
        overViewTextView.textColor = .white
        overViewTextView.isEditable = false
        overViewTextView.isScrollEnabled = false
        overViewTextView.sizeToFit()
        
        isFavorited = FavoriteMovieManager.shared.isFavorite(movieID: String(movie.id))
        favoriteButton.updateFavoriteAppearance(isFavorited: isFavorited)
    }
    
    private func setupAccessibilityIdentifiers() {
        baseView.accessibilityIdentifier = "baseView"
        cardStackView.accessibilityIdentifier = "cardStackView"
        posterImageView.accessibilityIdentifier = "posterImageView"
        movieTitleLabel.accessibilityIdentifier = "movieTitleLabel"
        favoriteButton.accessibilityIdentifier = "detailsFavoriteButton"
        releaseDateLabel.accessibilityIdentifier = "releaseDateLabel"
        overViewTextView.accessibilityIdentifier = "overViewTextView"
        ratingLabel.accessibilityIdentifier = "ratingLabel"
    }
    
    // MARK: - Action Methods
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        guard let movie = movie else { return }

            let movieID = String(movie.id)
            isFavorited.toggle()
            favoriteButton.updateFavoriteAppearance(isFavorited: isFavorited)

            if FavoriteMovieManager.shared.isFavorite(movieID: movieID) {
                FavoriteMovieManager.shared.removeFromFavorites(movieID: movieID)
            } else {
                FavoriteMovieManager.shared.addToFavorites(movie: movie)
            }
        
            NotificationCenter.default.post(name: .favoritesUpdated, object: movieID)

            dismiss(animated: true, completion: nil)
    }
}
