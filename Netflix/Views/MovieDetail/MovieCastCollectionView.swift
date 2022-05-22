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
        layout.itemSize = .init(width: (UIScreen.main.bounds.width - 20) * 0.3, height: UIScreen.main.bounds.height * 0.2)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MovieCastCellCollectionViewCell.self, forCellWithReuseIdentifier: MovieCastCellCollectionViewCell.identifier)
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.layer.cornerRadius = 10
        collection.backgroundView = self.blurView
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
        
//        self.backgroundColor = UIColor.green
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(self.blurView)
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
        self.setupLayout()
    }
    
    public func updateCollectionWithMovieCastCrew( _ movieCastCrew:[Crew]){
        self.movieCastCrew = movieCastCrew
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupLayout(){
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
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
