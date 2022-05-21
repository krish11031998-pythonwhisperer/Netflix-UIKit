//
//  SearchMovieViewController.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 19/05/2022.
//

import UIKit

class SearchResultMovieView: UIView {
    
    private var movies = [MovieData]()
    
    
    public var handleMovieSelection:((MovieData) -> Void) = { _ in
        print("Dummy Fucntion")
    }
    
    private let collectionView:UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.itemSize = .init(width: UIScreen.main.bounds.size.width * 0.3, height: UIScreen.main.bounds.size.height * 0.225)
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.sectionInset.left = 10
        collectionLayout.sectionInset.right = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.register(MovieCardCell.self, forCellWithReuseIdentifier: MovieCardCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }
    
    public func updateMovieResultCollection(_ movies:[MovieData]){
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    
}


extension SearchResultMovieView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCardCell.identifier, for: indexPath) as? MovieCardCell else {
            return UICollectionViewCell()
        }
        if indexPath.row < self.movies.count{
            cell.buildInnerView(movie: self.movies[indexPath.row])
            cell.handleMovieSelection = self.handleMovieSelection
        }
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
}


