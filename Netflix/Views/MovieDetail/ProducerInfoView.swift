//
//  ProducerView.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 20/05/2022.
//

import UIKit

class ProducerInfoView: UICollectionViewCell {

    
    static var identifier = "ProducerInfo"
    
    private let producerLabel:UILabel = {
        let producerLabel = UILabel()
        producerLabel.font = .systemFont(ofSize: 13, weight: .medium)
        producerLabel.textColor = .black
        producerLabel.numberOfLines = 1
        producerLabel.translatesAutoresizingMaskIntoConstraints = false
        return producerLabel
    }()
    
    
    private let producerImage:UIImageView = {
        let producerImageView = UIImageView()
        producerImageView.clipsToBounds = true
        producerImageView.image = .init(named: "placeHolder")
        producerImageView.contentMode = .scaleAspectFit
        producerImageView.translatesAutoresizingMaskIntoConstraints = false
        return producerImageView
    }()
    
    
    private let stack:UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.backgroundColor = .white
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.75
        self.layer.borderColor = UIColor.white.cgColor
        self.addSubview(self.producerImage)
        self.addSubview(self.producerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    func updateView(_ producer:MovieProductionCompany){
        if let producerImage = producer.logo_path{
            TMDBAPI.shared.loadImage(posterPath: producerImage) { [weak self] result in
                switch result{
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.producerImage.image = image
                    }
                case .failure(let err):
                    print("(Error) err Message",err.localizedDescription)
                }
            }
        }
        
        if let producerName = producer.name{
            self.producerLabel.text = producerName
        }
    }
    
    func setupLayout(){
        
        self.producerImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.producerImage.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10).isActive = true
        self.producerImage.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -20).isActive = true
        self.producerImage.heightAnchor.constraint(equalToConstant: self.frame.height * 0.80 - 30).isActive = true
        
        self.producerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10).isActive = true
        self.producerLabel.topAnchor.constraint(equalTo: self.producerImage.bottomAnchor,constant: 10).isActive = true
        self.producerLabel.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -20).isActive = true
        self.producerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:  -10).isActive = true
    }
}
