//
//  MovieCellSnapshot.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 18/05/2022.
//

import UIKit

class MovieCellSnapshot: UICollectionViewCell {
    static var identifier = "MovieCellSnapshot"

    private let moviePosterView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(named: "placeHolder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playButton:UIButton = {
        let button = UIButton()
        if let image  = UIImage(systemName: "play.fill"){
            button.setImage(image, for: .normal)
            button.tintColor = .white
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let viewStack:UIStackView = {
        let stack = UIStackView()
        stack.clipsToBounds = true
        stack.spacing = 2.5
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let movieDetailStack:UIStackView = {
        let titleView = UILabel()
        titleView.text = ""
        titleView.font = .systemFont(ofSize: 13, weight: .medium)
        titleView.textColor = .white
        titleView.accessibilityIdentifier = "title"
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let subTitleView = UILabel()
        subTitleView.text = ""
        subTitleView.font = .systemFont(ofSize: 10, weight: .semibold)
        subTitleView.textColor = .white
        subTitleView.accessibilityIdentifier = "subTitle"
        subTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let overviewView = UILabel()
        overviewView.font = .systemFont(ofSize: 10, weight: .medium)
        overviewView.textColor = .white
        overviewView.numberOfLines = 2
        overviewView.accessibilityIdentifier = "overview"
        overviewView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [titleView,subTitleView,overviewView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
        
    }()
    
    private func metricStackBuilder(key:String,value:Any? = nil,identifier:String) -> UIStackView{
        let header = UILabel()
        header.accessibilityIdentifier = "header"
        header.text = key
        header.textColor = UIColor.gray
        header.font = .systemFont(ofSize: 10, weight: .medium)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        let body = UILabel()
        body.accessibilityIdentifier = "body"
        if let safeValue = value{
            body.text = "\(safeValue)"
        }
        body.textColor = UIColor.gray
        body.font = .systemFont(ofSize: 12, weight: .medium)
        body.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stack = UIStackView(arrangedSubviews: [header,body])
        stack.axis = .vertical
        stack.spacing = 2.5
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = identifier
        
        return stack
    }

    private func movieMetricHStack() -> UIStackView{
        let stack = UIStackView(arrangedSubviews: [self.metricStackBuilder(key: "Popularity", identifier: "popularity"),self.metricStackBuilder(key: "Vote Count", identifier: "voteCount"),self.metricStackBuilder(key: "Vote Average", identifier: "voteAvg")])
        stack.distribution = .fillEqually
        stack.spacing = 2.5
        stack.accessibilityIdentifier = "metricStack"
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    public func updateCellWithMovie(_ movie:MovieData){
        
        if let title = movie.title,let _ = self.movieDetailStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "title"}) as? UILabel{
            DispatchQueue.main.async { [weak self] in
                (self?.movieDetailStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "title"}) as! UILabel).text = title
            }
        }

        
        if let year = movie.releaseDate,let _ = self.movieDetailStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "subTitle"}) as? UILabel{
            DispatchQueue.main.async { [weak self] in
                (self?.movieDetailStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "subTitle"}) as! UILabel).text = year
            }
        }
        
        if let year = movie.overview,let _ = self.movieDetailStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "overview"}) as? UILabel{
            DispatchQueue.main.async { [weak self] in
                (self?.movieDetailStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "overview"}) as! UILabel).text = year
            }
        }
        
        if let popularity = movie.popularity,let metricStack = self.movieDetailStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "metricStack"}) as? UIStackView,
           let popularityView = metricStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "popularity"}) as? UIStackView,
           let bodyView = popularityView.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "body"}) as? UILabel{
            DispatchQueue.main.async {
                bodyView.text = "\(popularity)"
            }
        }

        if  let voteCount = movie.voteCount,let metricStack = self.movieDetailStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "metricStack"}) as? UIStackView,
            let voteCountView = metricStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "voteCount"}) as? UIStackView,
            let bodyView = voteCountView.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "body"}) as? UILabel{
            DispatchQueue.main.async {
                bodyView.text = "\(voteCount)"
            }
        }

        if  let voteAvg = movie.voteAverage,let metricStack = self.movieDetailStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "metricStack"}) as? UIStackView,
            let voteAvgView = metricStack.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "voteAvg"}) as? UIStackView,
            let bodyView = voteAvgView.arrangedSubviews.first(where: {$0.accessibilityIdentifier == "body"}) as? UILabel{
            DispatchQueue.main.async {
                bodyView.text = "\(voteAvg)"
            }
        }

        
        if let url = movie.posterPath{
            TMDBAPI.shared.loadImage(posterPath: url) { [weak self] result in
                switch(result){
                    case .success(let img):
                        DispatchQueue.main.async {
                            self?.moviePosterView.image = img
                        }
                    case .failure(let err):
                        print("(Error) : ",err)
                }
            }
            
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.moviePosterView)
        self.addSubview(self.playButton)
        self.movieDetailStack.addArrangedSubview(self.movieMetricHStack())
        self.addSubview(self.movieDetailStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    
    func setupLayout(){
        //ViewStack
        self.moviePosterView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.moviePosterView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10).isActive = true
        self.moviePosterView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10).isActive = true
        self.moviePosterView.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.3).isActive = true
//        self.moviePosterView.heightAnchor.constraint(equalToConstant: self.bounds.height - 20).isActive = true
        
        //movieDetailStack
        self.movieDetailStack.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.5).isActive = true
        self.movieDetailStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.movieDetailStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.movieDetailStack.leadingAnchor.constraint(equalTo: self.moviePosterView.trailingAnchor, constant: 15).isActive = true
//
        //button
        self.playButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.playButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.playButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.playButton.layer.cornerRadius = 12.5
        self.playButton.layer.borderColor = UIColor.white.cgColor
        self.playButton.layer.borderWidth = 1
    }
    
}
