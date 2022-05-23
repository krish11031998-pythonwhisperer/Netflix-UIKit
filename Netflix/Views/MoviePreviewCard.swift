//
//  MoviePreviewcard.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 17/05/2022.
//

import UIKit

class MoviePreviewCard: UITableViewCell {
    
    
    static var identifier = "MoviewPreviewCard"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleView.text = ""
        self.yearView.text = ""
        self.overviewView.text = ""
        self.movieImage.image = .init(named: "placeHolder")
        self.movieBackDropImage.image = .init(named: "placeHolder")
    }
    
    private var titleView:UILabel = {
        let textView = UILabel()
        textView.text = "Title"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15, weight: .semibold)
        textView.textColor = .white
        return textView
    }()
    
    private var yearView:UILabel = {
        let textView = UILabel()
        textView.text = "SubTitle"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 11, weight: .semibold)
        textView.textColor = .white
        return textView
    }()
    
    private var overviewView:UILabel = {
       let labelView = UILabel()
        labelView.text = ""
        labelView.numberOfLines = 3
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.font = .systemFont(ofSize: 13, weight: .medium)
        labelView.textColor = .white
        return labelView
    }()
    
    private var movieImage:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = .init(named: "placeHolder")
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0.125
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var movieBackDropImage:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = .init(named: "placeHolder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private var gradientLayer:CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        return gradient
    }()
    
    
    private var movieInfoStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private var playButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
    
        //Adding buttomImage to button
        if let safeImage = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)){
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(safeImage, for: .normal)
            button.tintColor = .white
            button.imageView?.contentMode = .scaleAspectFill
            button.backgroundColor = .black
            button.imageView?.clipsToBounds = true
        }

        return button
    }()
    
    private var movieMetricStack:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private func movieInfoStackBuilder(){
        self.movieInfoStack.addArrangedSubview(self.titleView)
        self.movieInfoStack.addArrangedSubview(self.yearView)
        self.movieInfoStack.addArrangedSubview(self.overviewView)
        self.addSubview(self.movieInfoStack)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        //View
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.75
        self.layer.cornerRadius = 10
        
        //Backdrop image
        self.movieBackDropImage.layer.addSublayer(self.gradientLayer)
        self.addSubview(self.movieBackDropImage)
        
        //PosterImage
        self.addSubview(self.movieImage)
        
        //Movie Info Section
        self.movieInfoStackBuilder()
        
        //PlayButton
        self.addSubview(self.playButton)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
        self.setupLayout()
    }
    
    func updateView(_  movie:MovieData){
        if let safeTitle = movie.title{
            DispatchQueue.main.async {
                self.titleView.text = safeTitle
            }
        }
        
        if let safeYear = movie.releaseDate{
            DispatchQueue.main.async {
                self.yearView.text = safeYear
            }
        }
        
        if let safeOverviewView = movie.overview{
            DispatchQueue.main.async {
                self.overviewView.text = safeOverviewView
            }
        }
        
        if let safeImagePoster = movie.posterPath{
            TMDBAPI.shared.loadImage(posterPath: safeImagePoster) { [weak self] result in
                switch result{
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.movieImage.image = image
                    }
                case .failure(let err):
                    print("(Error) err : ",err)
                }
            }
        }
        
        if let backDropImage = movie.backdropPath{
            TMDBAPI.shared.loadImage(posterPath: backDropImage) { [weak self] result in
                switch result{
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.movieBackDropImage.image = image
                    }
                case .failure(let err):
                    print("(Error) err  : ",err)
                }
            }
        }
    }

    
    func setupLayout(){
        
        //backdropImage
        self.movieBackDropImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.movieBackDropImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.movieBackDropImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.movieBackDropImage.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.5).isActive = true
        
        //moviePoster
        self.movieImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.movieImage.centerYAnchor.constraint(equalTo: self.movieBackDropImage.bottomAnchor).isActive = true
        self.movieImage.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.35).isActive = true
        self.movieImage.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.275).isActive = true
        
        
        //movieInfoStack
        self.movieInfoStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.movieInfoStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.movieInfoStack.topAnchor.constraint(equalTo: self.movieImage.bottomAnchor, constant: 10).isActive = true
        self.movieInfoStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        //overviewView
//        self.titleView.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.0625).isActive = true
//        self.yearView.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.0625).isActive = true
        self.overviewView.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.2 - 20).isActive = true
        
        
        //playButton
        self.playButton.centerYAnchor.constraint(equalTo: self.movieBackDropImage.bottomAnchor).isActive = true
        self.playButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.playButton.layer.cornerRadius = 25
        self.playButton.clipsToBounds = true
        self.playButton.layer.borderColor = UIColor.white.cgColor
        self.playButton.layer.borderWidth = 1.5
        
    }

    
}
