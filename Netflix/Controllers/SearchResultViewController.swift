//
//  SearchResultViewController.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 19/05/2022.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    private var keywordResult = [KeywordData]()
    
    public var handleMovieSelection:((MovieData) -> Void)?
    
    private let collectionView:UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.itemSize = .init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.045)
        collectionLayout.sectionInset.left = 10
        collectionLayout.sectionInset.right = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.register(SerachResultCollectionCell.self, forCellWithReuseIdentifier: SerachResultCollectionCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    public func updateCollection(_ keywords:[KeywordData]){
        self.keywordResult = keywords
        self.collectionView.reloadData()
        
    }
    
    public func fetchMoviesForKeywords(_ keywords_id:String){
        print("(DEBUG) Clicked keyword : ",keywords_id)
        TMDBAPI.shared.fetchMoviesForKeyword(keyword_id: keywords_id) { result in
            switch result{
                case .success(let movies):
                    DispatchQueue.main.async { [weak self] in
                        let movieResultCollection = SearchResultMovieView()
                        self?.view.addSubview(movieResultCollection)
                        if let handler = self?.handleMovieSelection{
                            movieResultCollection.handleMovieSelection = handler
                        }
                        movieResultCollection.updateMovieResultCollection(movies)
                        movieResultCollection.frame = self?.view.bounds ?? .zero 
                    }
                case .failure(let err):
                    print("(Error) error : ",err.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = self.view.bounds
    }

}

extension SearchResultViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keywordResult.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SerachResultCollectionCell.identifier, for: indexPath) as? SerachResultCollectionCell else {
            return UICollectionViewCell()
        }
        if !self.keywordResult.isEmpty{
            cell.handleKeywordSelection = self.fetchMoviesForKeywords(_:)
            cell.updateKeyword(self.keywordResult[indexPath.row])
        }
        return cell
    }
    
}


