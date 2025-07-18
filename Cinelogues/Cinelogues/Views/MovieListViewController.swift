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
    private let pageControl = UIPageControl()
    private var hasScrolledToInitialIndex = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.fetchAllCategories()
        
        setupCarouselView()
        setupPageControl()
        
        popularMovieCarouselCell.accessibilityIdentifier = "popularMovieCarouselCell"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !hasScrolledToInitialIndex, viewModel.itemCount() > 0 {
            DispatchQueue.main.async {
                let middleIndex = (self.viewModel.itemCount() / 2) - ((self.viewModel.itemCount() / 2) % self.viewModel.topFiveMovies.count)
                let indexPath = IndexPath(item: middleIndex, section: 0)
                self.popularMovieCarouselCell.scrollToItem(at: indexPath,
                                                           at: .centeredHorizontally,
                                                           animated: false)
                self.hasScrolledToInitialIndex = true
            }
        }
    }
    
    private func setupCarouselView() {
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
        pageControl.numberOfPages = viewModel.topFiveMovies.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: popularMovieCarouselCell.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        guard viewModel.itemCount() > 0 else { return }
        
        let middleIndex = (viewModel.itemCount() / 2) - ((viewModel.itemCount() / 2) % viewModel.topFiveMovies.count)
        let targetIndex = middleIndex + sender.currentPage
        
        viewModel.updateCurrentIndex(targetIndex)
        popularMovieCarouselCell.scrollToItem(at: IndexPath(item: targetIndex, section: 0),
                                              at: .centeredHorizontally,
                                              animated: true)
    }
    
    deinit {
        viewModel.stopAutoScroll()
    }
}

// MARK: - CollectionView Delegates and DataSource
extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.itemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = viewModel.movie(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieCarouselCell.identifier,
                                                      for: indexPath) as! PopularMovieCarouselCell
        cell.configure(with: movie)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MoviesNowViewController", bundle: nil)
        if let moviesNowVC = storyboard.instantiateViewController(withIdentifier: "MoviesNowViewController") as? MoviesNowViewController {
            moviesNowVC.movies = viewModel.allMovies
            navigationController?.pushViewController(moviesNowVC, animated: true)
        }
    }
}

// MARK: - Scrolling Implementation
extension MovieListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCenterX = scrollView.contentOffset.x + scrollView.frame.size.width / 2
        
        guard let indexPath = popularMovieCarouselCell.indexPathForItem(at: CGPoint(x: visibleCenterX,
                                                                                    y: scrollView.frame.size.height / 2)) else {
            return
        }
        
        viewModel.updateCurrentIndex(indexPath.item)
        let currentIndex = indexPath.item
        let itemCount = viewModel.itemCount()
        let threshold = viewModel.topFiveMovies.count
        
        if currentIndex < threshold || currentIndex > itemCount - threshold {
            let middleIndex = (itemCount / 2) - ((itemCount / 2) % threshold)
            popularMovieCarouselCell.scrollToItem(at: IndexPath(item: middleIndex, section: 0),
                                                  at: .centeredHorizontally,
                                                  animated: false)
            viewModel.updateCurrentIndex(middleIndex)
        }
    }
}

// MARK: - MovieListViewModelDelegate
extension MovieListViewController: MovieListViewModelDelegate {
    func didUpdateCombinedMovies(_ movies: [Movie]) {
        DispatchQueue.main.async {
            self.popularMovieCarouselCell.reloadData()
            self.pageControl.numberOfPages = self.viewModel.topFiveMovies.count
            self.pageControl.currentPage = 0
            self.hasScrolledToInitialIndex = false
        }
    }
    
    func didUpdateCurrentIndex(to index: Int) {
        pageControl.currentPage = index
    }
    
    func didRequestScrollToIndex(_ index: Int) {
        DispatchQueue.main.async {
            self.popularMovieCarouselCell.scrollToItem(at: IndexPath(item: index, section: 0),
                                                       at: .centeredHorizontally,
                                                       animated: true)
        }
    }
}

// MARK: - Handling Navigation from Cell
extension MovieListViewController: PopularMovieCarouselCellDelegate {
    func didTapMoreButton(from cell: PopularMovieCarouselCell) {
        let storyboard = UIStoryboard(name: "MoviesNowViewController", bundle: nil)
        if let moviesNowVC = storyboard.instantiateViewController(withIdentifier: "MoviesNowViewController") as? MoviesNowViewController {
            moviesNowVC.movies = viewModel.allMovies
            navigationController?.pushViewController(moviesNowVC, animated: true)
        }
    }
}

