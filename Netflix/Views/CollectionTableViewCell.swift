//
//  CollectionTableViewCell.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 09/05/2022.
//

import UIKit

enum SectionType:Int{
    case TrendingMovies = 0
    case TredningTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class CollectionTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"

    public var movies = [MovieData]()
    
    public var handleMovieSelection:((MovieData) -> Void)? = nil
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.3, height: UIScreen.main.bounds.size.height * 0.2)
        layout.sectionInset.left = 10
        layout.sectionInset.right = 10
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieCardCell.self, forCellWithReuseIdentifier: MovieCardCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    public func innerViewBuilderwithResult(result:Result<[MovieData],DataError>){
        DispatchQueue.main.async { [weak self] in
            switch result{
            case .success(let movies):
                self?.innerViewBuilderWithData(movies)
            case .failure(let error):
                let textView = UILabel()
                textView.text = "No Data : " + error.localizedDescription
                textView.font = .boldSystemFont(ofSize: 15)
                textView.textColor = .white
                self?.contentView.addSubview(textView)
            }
        }
    }
    
    public func innerViewBuilderWithData(_ movies:[MovieData]){
        self.movies = movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.contentView.bounds
    }
    
}

extension CollectionTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCardCell.identifier, for: indexPath) as? MovieCardCell else {
            return UICollectionViewCell()
        }
        if !self.movies.isEmpty{
            if let handleSelection = self.handleMovieSelection{
                cell.handleMovieSelection = handleSelection
            }
            
            cell.buildInnerView(movie: self.movies[indexPath.row])
        }
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    

}
