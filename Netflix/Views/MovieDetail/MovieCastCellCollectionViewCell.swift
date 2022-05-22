//
//  MovieCastCellCollectionViewCell.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 21/05/2022.
//

import UIKit

class MovieCastCellCollectionViewCell: UICollectionViewCell {
    private var actor:Actor? = nil
    
    static var identifier:String = "CastCell"
    
    private lazy var imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = .init(named: "placeHolder")
        imageView.layer.cornerRadius = 10
        imageView.layer.addSublayer(self.gradient)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let actorLabel:UILabel = {
        let label = UILabel()
        label.text = "Actor"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roleLabel:UILabel = {
        let label = UILabel()
        label.text = "as Role"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var castInfo:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.actorLabel,self.roleLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let gradient:CAGradientLayer = {
       let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.addSubview(self.imageView)
        self.addSubview(self.castInfo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        self.gradient.frame = self.bounds
        setupLayout()
    }
    
    
    func setupLayout(){
        
        self.castInfo.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10).isActive = true
        self.castInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.castInfo.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        
    }
    
    
    func updateUIWithCast( _  actor:Actor){
        self.actor = actor
        DispatchQueue.main.async {
            
            if let actorLabel = actor.name{
                self.actorLabel.text = actorLabel
            }
            
            if let role = actor.character{
                self.roleLabel.text = "as \(role)"
            }
            
            if let profilePath = actor.profile_path{
                TMDBAPI.shared.loadImage(posterPath: profilePath) { [weak self] result in
                    switch result{
                    case .success(let image):
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    case .failure(let err):
                        print("(Error) err : ",err.localizedDescription)
                    }
                }
            }
            
            
        }
    }
    
    
    
    
}
