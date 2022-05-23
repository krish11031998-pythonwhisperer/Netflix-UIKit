//
//  MovieReviewCollectionView.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class MovieReviewCollectionView: UIView {
    
    private var reviews:[MovieReviewModel]?
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.4)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(MovieReviewCollectionViewCell.self, forCellWithReuseIdentifier: MovieReviewCollectionViewCell.identifier)
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds.inset(by: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func updateMovieReview(_ review:[MovieReviewModel]){
        self.reviews = review
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}



extension MovieReviewCollectionView:UICollectionViewDelegate,UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reviews?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieReviewCollectionViewCell.identifier, for: indexPath) as? MovieReviewCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        if let safeReviews = self.reviews, indexPath.row < safeReviews.count{
            cell.updateCellWithReview(safeReviews[indexPath.row])
        }
        
        return cell
    }
    
}
