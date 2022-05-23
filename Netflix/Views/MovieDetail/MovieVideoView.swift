//
//  MovieVideoView.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 22/05/2022.
//

import UIKit

class MovieVideoView: UIView {

    private var videos:[MovieVideoModel]?
    
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width:UIScreen.main.bounds.width - 40,height:UIScreen.main.bounds.height * 0.25)
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieVideoCellCollectionViewCell.self, forCellWithReuseIdentifier: MovieVideoCellCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }
    
    func setupLayout(){
        
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    func updateVideosCollection(_ movies:[MovieVideoModel]){
        self.videos = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}

extension MovieVideoView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieVideoCellCollectionViewCell.identifier, for: indexPath) as? MovieVideoCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let safeVideos = self.videos, indexPath.row < safeVideos.count{
            cell.updateMovieCell(safeVideos[indexPath.row])
        }
        
        return cell
    }
    
}
