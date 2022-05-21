//
//  SearchViewController.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 09/05/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    private var movies = [MovieData]()
    
    private let searchTableView:UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.sectionInset.left = 10
        collectionLayout.sectionInset.right = 10
        collectionLayout.itemSize = .init(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height * 0.225)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MovieCellSnapshot.self, forCellWithReuseIdentifier: MovieCellSnapshot.identifier)
        return collectionView
    }()
    
    
    private let searchBarController:UISearchController = {
        
        let searchbarControlller = UISearchController(searchResultsController: SearchResultViewController())
        searchbarControlller.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchbarControlller.searchBar.placeholder = "Search Movies"
        searchbarControlller.searchBar.searchBarStyle = .minimal
        return searchbarControlller
    }()
    
    private func searchResultVC() -> SearchResultViewController{
        let searchResultVC = SearchResultViewController()
        searchResultVC.handleMovieSelection = self.handleSelectMovie
        return searchResultVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Search"
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        if let searchResVC = self.searchBarController.searchResultsController as? SearchResultViewController{
            searchResVC.handleMovieSelection = self.handleSelectMovie(_:)
        }
        self.navigationItem.searchController = self.searchBarController
        self.view.addSubview(self.searchTableView)
        self.searchBarController.searchBar.delegate = self
        self.fetchMovies()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchTableView.frame = self.view.bounds
        self.setupLayout()
    }
    
    func fetchMovies(){
        TMDBAPI.shared.fetchPopularMovies { [weak self] result in
            switch result{
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let err):
                print("(Error) Err : ",err)
            }
        }
    }
    
    func setupLayout(){
    }

    
    func findKeywords(query:String){
        TMDBAPI.shared.fetchKeywords(query: query) { [weak self] result in
            switch result{
            case .success(let keywords):
                DispatchQueue.main.async {
                    if let searchResult = self?.navigationItem.searchController?.searchResultsController as? SearchResultViewController{
                        searchResult.updateCollection(keywords)
                    }
                }
            case .failure(let err):
                print("(DEBUG) err : ",err)
            }
        }
    }
    
    func handleSelectMovie( _ movie:MovieData){
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.updateView(movie)
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }

}


extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCellSnapshot.identifier, for: indexPath) as? MovieCellSnapshot else {
            return UICollectionViewCell()
        }
        
        if !self.movies.isEmpty{
            cell.updateCellWithMovie(self.movies[indexPath.row])
        }
        return cell
    }

}


extension SearchViewController:UISearchBarDelegate{
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        self.findKeywords(query: searchText)
        print("(DEBUG) searchText : ",searchText)
    }
    
}



