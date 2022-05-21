//
//  CollectionCellView.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 16/05/2022.
//

import UIKit

class MovieCardCell:UICollectionViewCell {
    
    
    public var titleView:UILabel = .init()
    public var subTitleView:UILabel = .init()
    private var movie:MovieData?
    
    public var handleMovieSelection:((MovieData) -> Void)? = nil
    
    static let identifier = "movieCell"
    
    private var gradientLayer:CAGradientLayer = {
       var gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        return gradientLayer
    }()
    
    private var movieImageView:UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = .init(named: "placeHolder")
        return imageView
    }()
    
    
    private func textViewBuilder(text:String,size:CGFloat,weight:UIFont.Weight) -> UILabel{
        let labelView = UILabel()
        labelView.text = text
        labelView.textColor = .white
        labelView.numberOfLines = 2
        labelView.font = .systemFont(ofSize: size, weight: weight)
        labelView.backgroundColor = .clear
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }
    
    
    func initializeView(){
        self.titleView = self.textViewBuilder(text: "", size: 15, weight: .semibold)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.initializeView()
        self.addSubViews()
        self.layer.cornerRadius = 8
        self.layer.borderColor = .init(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        self.layer.borderWidth = 0.75
    }
    
    public func buildInnerView(movie:MovieData){
        self.movie = movie

        if let safeTitle = movie.title ?? movie.name ?? movie.original_name{
            self.titleView.text = safeTitle
        }
        
        if let safePoster = movie.posterPath{
            TMDBAPI.shared.loadImage(posterPath: "https://image.tmdb.org/t/p/w500\(safePoster)") { [weak self] result in
                switch result{
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.movieImageView.image = image
                    }
                case .failure(let err):
                    print("Error while fetching the image : ",err)
                }
                
            }
        }
    }
    
    func addSubViews(){
        self.movieImageView.layer.addSublayer(self.gradientLayer)
        self.addSubview(self.movieImageView)
        self.addSubview(titleView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.movieImageView.frame = self.bounds
        self.gradientLayer.frame = self.bounds
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        self.titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.titleView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        
        self.movieImageView.layer.cornerRadius = self.layer.cornerRadius
    }
    
    @objc func handleTap(){
        if let handleSelection = self.handleMovieSelection,let safeMovie = self.movie{
            handleSelection(safeMovie)
        }
    }
    
}
