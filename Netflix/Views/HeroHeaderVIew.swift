//
//  HeroHeaderVIew.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 16/05/2022.
//

import UIKit

class HeroHeaderVIew: UIView {
    
    private let heroImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = .init(named: "heroImage")
        
        return imageView
    }()
    
    private let gradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        return gradientLayer
    }()
    
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame:CGRect){
        super.init(frame: frame)
        self.addSubview(self.heroImageView)
        self.layer.addSublayer(self.gradientLayer)
        self.addSubview(self.playButton)
        self.addSubview(self.downloadButton)
        self.applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = self.bounds
        gradientLayer.frame = self.bounds
    }
    
    required init?(coder:NSCoder){
        fatalError()
    }
    
    private func applyConstraints(){
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: self.frame.width * 0.25 - 15),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            playButton.widthAnchor.constraint(equalToConstant: self.frame.width * 0.25)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        
        let downloadConstraints = [
            downloadButton.leadingAnchor.constraint(equalTo: self.playButton.trailingAnchor, constant: 30),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            downloadButton.widthAnchor.constraint(equalToConstant: self.frame.width * 0.25)
        ]
        
        NSLayoutConstraint.activate(downloadConstraints)
    }
    

}
