//
//  ViewController.swift
//  Cinelogues
//
//  Created by AJ on 17/07/25.
//

import UIKit

class MovieListViewController: UIViewController {
    
    
    @IBOutlet weak var popularMovieCarouselCell: UICollectionView!
    
    private let viewModel = MovieListViewModel()
    private var movies: [Movie] = []
    private var category: MovieCategory = .popular
    private var hasScrolledToInitialIndex = false
    private let pageControl = UIPageControl()
    private var topFiveMovies: [Movie] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchAllCategories()
        //viewModel.fetchMovies(for: category)
        setupCarouselView()
        setupPageControl()
        
    }
    
   

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !hasScrolledToInitialIndex, topFiveMovies.count > 0 {
            DispatchQueue.main.async {
                if self.topFiveMovies.count > 0 {
                    self.popularMovieCarouselCell.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                    self.hasScrolledToInitialIndex = true
                }
            }
        }
    }

    
    func setupCarouselView() {
        let layout = CoverFlowLayout()
        popularMovieCarouselCell.collectionViewLayout = layout
        
        let nib = UINib(nibName: "PopularMovieCarouselCell", bundle: nil)
        popularMovieCarouselCell.register(nib, forCellWithReuseIdentifier: PopularMovieCarouselCell.identifier)
        
        popularMovieCarouselCell.dataSource = self
        popularMovieCarouselCell.delegate = self
        
        popularMovieCarouselCell.decelerationRate = .fast
        popularMovieCarouselCell.showsHorizontalScrollIndicator = false
        popularMovieCarouselCell.isPagingEnabled = false
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = movies.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: popularMovieCarouselCell.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topFiveMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieCarouselCell.identifier,for: indexPath) as! PopularMovieCarouselCell
        cell.configure(with: movies[indexPath.item])
        cell.delegate = self
        return cell
    }
}

extension MovieListViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        guard let layout = popularMovieCarouselCell.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCenter = scrollView.contentOffset.x + scrollView.frame.size.width / 2
           guard let indexPath = popularMovieCarouselCell.indexPathForItem(at: CGPoint(x: visibleCenter, y: scrollView.frame.size.height / 2)) else {
               return
           }
           pageControl.currentPage = indexPath.item
    }

}


extension MovieListViewController: MovieListViewModelDelegate {
   
    func didUpdateCombinedMovies(_ movies: [Movie]) {
        self.movies = movies
        
        self.topFiveMovies = Array(movies.prefix(5))
        
        DispatchQueue.main.async {
            self.popularMovieCarouselCell.reloadData()
            self.pageControl.numberOfPages = self.topFiveMovies.count
            self.pageControl.currentPage = 0
        }
    }
}

extension MovieListViewController: PopularMovieCarouselCellDelegate {
    func didTapMoreButton(from cell: PopularMovieCarouselCell) {
        let storyboard = UIStoryboard(name: "MoviesNowViewController", bundle: nil)
        if let moviesNowVC = storyboard.instantiateViewController(withIdentifier: "MoviesNowViewController") as? MoviesNowViewController {
            moviesNowVC.movies = self.movies
            self.navigationController?.pushViewController(moviesNowVC, animated: true)
        }

    }
}


