//
//  MoviesNowViewController.swift
//  Cinelogues
//
//  Created by AJ on 18/07/25.
//

import UIKit

class MoviesNowViewController: UIViewController {

    @IBOutlet weak var popularMoviesCV: UICollectionView!
    @IBOutlet weak var NowPlayingMoviesCV: UICollectionView!
    @IBOutlet weak var upcomingMoviesCV: UICollectionView!
    
    var movies : [Movie] = []
    
    var favoritedMovieIDs = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "MoviesCollectionViewCell", bundle: nil)
        popularMoviesCV.register(nib, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        popularMoviesCV.delegate = self
        popularMoviesCV.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemWidth = (view.frame.width - 12 * 3) / 2  // Two items per row with spacing
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        
        popularMoviesCV.collectionViewLayout = layout
    }

}

extension MoviesNowViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
               fatalError("Unable to dequeue MoviesCollectionViewCell")
           }

           let movie = movies[indexPath.item]
           let isFavorited = favoritedMovieIDs.contains("\(movie.id)")
           cell.configure(with: movie, isFavorited: isFavorited)

           cell.favoriteButtonTapped = { [weak self] isNowFavorited in
               guard let self = self else { return }
               if isNowFavorited {
                   self.favoritedMovieIDs.insert("\(movie.id)")
               } else {
                   self.favoritedMovieIDs.remove("\(movie.id)")
               }
           }

           return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 16 // Set the vertical space between rows
//    }


}
