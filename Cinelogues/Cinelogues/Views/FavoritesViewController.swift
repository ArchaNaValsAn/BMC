//
//  FavoritesViewController.swift
//  Cinelogues
//
//  Created by AJ on 18/07/25.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
   // var favoriteMovies: [FavoriteMovies] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  favoriteMovies = CoreDataManager.shared.fetchFavorites()
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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
               fatalError("Unable to dequeue MoviesCollectionViewCell")
           }

//        let isFavorited = CoreDataManager.shared.isFavorited(id: "\(String(describing: favoriteMovies[indexPath.row].id))")
       // cell.configure(with: favoriteMovies[indexPath.row], isFavorited: isFavorited)

           return cell
    }
}
