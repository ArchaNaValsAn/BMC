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
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overViewTextView: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var movie: Movie?
    var favoritedMovieIDs = Set<String>()
    private var isFavorited = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurBackground()
        setupCardStackView()
        setupDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        movieTitleLabel.textColor = .white
        releaseDateLabel.text = movie.releaseDate
        releaseDateLabel.textColor = .white
        ratingLabel.text = "⭐️ \(movie.voteAverage)"
        ratingLabel.textColor = .white
        overViewTextView.text = movie.overview
        overViewTextView.textColor = .white
        overViewTextView.isEditable = false
        overViewTextView.isScrollEnabled = false
        overViewTextView.sizeToFit()
        isFavorited = favoritedMovieIDs.contains("\(movie.id)")
        favoriteButton.updateFavoriteAppearance(isFavorited: isFavorited)
        
    }
    
    
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        isFavorited.toggle()
        favoriteButton.updateFavoriteAppearance(isFavorited: isFavorited)
        
    }
    
}
