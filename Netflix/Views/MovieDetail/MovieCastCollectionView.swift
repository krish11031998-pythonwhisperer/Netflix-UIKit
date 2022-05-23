//
//  MovieCastCollectionViewController.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 21/05/2022.
//

import UIKit

class MovieCastCollectionView: UIView {

    private var movieCastCrew:[Crew]?
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (UIScreen.main.bounds.width - 20) * 0.3, height: UIScreen.main.bounds.height * 0.2 - 15)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MovieCastCellCollectionViewCell.self, forCellWithReuseIdentifier: MovieCastCellCollectionViewCell.identifier)
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.layer.cornerRadius = 10
        collection.backgroundView = self.blurView
        collection.layer.borderWidth = 1
        collection.layer.borderColor = UIColor.gray.cgColor
        return collection
    }()
    
    private let blurView:UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        return blurView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("(DEBUG) bounds : ",self.bounds)
        self.blurView.frame = self.bounds
        self.collectionView.frame = self.bounds
    }
    
    public func updateCollectionWithMovieCastCrew( _ movieCastCrew:[Crew]){
        self.movieCastCrew = movieCastCrew
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


extension  MovieCastCollectionView:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieCastCrew?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCastCellCollectionViewCell.identifier, for: indexPath) as? MovieCastCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let safeData = self.movieCastCrew,indexPath.row < safeData.count{
            cell.updateUIWithCast(safeData[indexPath.row])
        }
    
        return cell
    }

}
