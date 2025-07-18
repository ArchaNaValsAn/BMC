//
//  FavoritesViewController.swift
//  Cinelogues
//
//  Created by AJ on 18/07/25.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    private var favoriteMovies: [Movie] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated(_:)), name: .favoritesUpdated, object: nil)
    }
    
    @objc private func favoritesUpdated(_ notification: Notification) {
        let entities = FavoriteMovieManager.shared.fetchAllFavorites()
        favoriteMovies = entities.compactMap { Movie(from: $0) }
        favoritesCollectionView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let entities = FavoriteMovieManager.shared.fetchAllFavorites()
        favoriteMovies = entities.compactMap { Movie(from: $0) }
        favoritesCollectionView.reloadData()
    }
    
    @objc private func refreshFavorites() {
        let favorites = FavoriteMovieManager.shared.fetchAllFavorites()
            favoriteMovies = favorites.compactMap { Movie(from: $0) }
            favoritesCollectionView.reloadData()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "MoviesCollectionViewCell", bundle: nil)
        favoritesCollectionView.register(nib, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemWidth = (view.frame.width - 12 * 3) / 2  // Two items per row with spacing
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        
        favoritesCollectionView.collectionViewLayout = layout
    }
    
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviesCollectionViewCell.identifier,
            for: indexPath
        ) as? MoviesCollectionViewCell else {
            fatalError("Unable to dequeue MoviesCollectionViewCell")
        }
        
        let movie = favoriteMovies[indexPath.item]
        cell.configure(with: movie, isFavorited: true)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MovieDetailsViewController", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            detailsVC.modalPresentationStyle = .overCurrentContext
            detailsVC.modalTransitionStyle = .crossDissolve
            self.definesPresentationContext = true
            navigationController?.setNavigationBarHidden(true, animated: false)
            detailsVC.movie = favoriteMovies[indexPath.row]
            present(detailsVC, animated: true, completion: nil)
        }
    }
}
