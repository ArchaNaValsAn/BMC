//
//  MoviesNowViewController.swift
//  Cinelogues
//
//  Created by AJ on 18/07/25.
//

import UIKit

class MoviesNowViewController: UIViewController {

    @IBOutlet weak var popularMoviesCV: UICollectionView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    
    var movies : [Movie] = []
    var filteredMovies: [Movie] = []
    var isSearching = false
    
    var favoritedMovieIDs = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchBar()
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
    
    private func setupSearchBar() {
        movieSearchBar.barTintColor = .black
        movieSearchBar.backgroundImage = UIImage()
            
            if let textField = movieSearchBar.value(forKey: "searchField") as? UITextField {
                textField.backgroundColor = UIColor.black
                textField.textColor = .white
                textField.font = UIFont.systemFont(ofSize: 14)
                textField.attributedPlaceholder = NSAttributedString(
                    string: "Search here...",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                )
                textField.layer.cornerRadius = 10
                textField.clipsToBounds = true
            }

        movieSearchBar.setImage(UIImage(systemName: "xmark.circle"), for: .clear, state: .normal)



    }
    
    func searchMovies(with searchText: String) {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if trimmedText.isEmpty {
            isSearching = false
            filteredMovies = []
            popularMoviesCV.reloadData()
            return
        }

        isSearching = true
        filteredMovies = movies.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }.reduce(into: []) { result, movie in
            if !result.contains(where: { $0.id == movie.id }) {
                result.append(movie)
            }
        }

        if filteredMovies.isEmpty {
            showNoResultsAlert(for: searchText)
        }
        
        popularMoviesCV.reloadData()
    }
    
    private func showNoResultsAlert(for searchText: String) {
        let alert = UIAlertController(
            title: "No Results",
            message: "No movies found for \"\(searchText)\".",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }



}

extension MoviesNowViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredMovies.count : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
               fatalError("Unable to dequeue MoviesCollectionViewCell")
           }

           let movie = movies[indexPath.item]
           let isFavorited = favoritedMovieIDs.contains("\(movie.id)")
            cell.configure(with: isSearching ? filteredMovies[indexPath.row] : movie, isFavorited: isFavorited)

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MovieDetailsViewController", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            detailsVC.modalPresentationStyle = .overCurrentContext
            detailsVC.modalTransitionStyle = .crossDissolve
            self.definesPresentationContext = true
            navigationController?.setNavigationBarHidden(true, animated: false)
            detailsVC.movie = isSearching ? filteredMovies[indexPath.row] : movies[indexPath.row]
            detailsVC.favoritedMovieIDs = self.favoritedMovieIDs
            present(detailsVC, animated: true, completion: nil)
        }
    }

}

extension MoviesNowViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMovies(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredMovies.removeAll()
        popularMoviesCV.reloadData()
        searchBar.resignFirstResponder()
    }

}
