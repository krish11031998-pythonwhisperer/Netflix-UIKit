//
//  MovieReviewCollectionViewCell.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class MovieReviewCollectionViewCell: UICollectionViewCell {
    
    private var review:MovieReviewModel?
    
    public static var identifier = "ReviewCell"
    
    private lazy var username:UILabel = self.labelBuilder(text: "", size: 15, weight: .medium, color: .white, numOfLines: 1)
    
    private lazy var created_at:UILabel = self.labelBuilder(text: "", size: 10, weight: .semibold, color: .white, numOfLines: 1)
    
    private lazy var comment:UILabel = self.labelBuilder(text: "", size: 13, weight: .regular, color: .white, numOfLines: 3)
    
    private lazy var profileImage:UIImageView = {
        let imageView = self.imageView(autoLayout:false)
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    
    private lazy var profileInfo:UIStackView = {
        let profileDetails = UIStackView(arrangedSubviews: [self.username,self.created_at])
        profileDetails.axis = .vertical
        profileDetails.alignment = .leading
        profileDetails.distribution = .fillProportionally
        profileDetails.translatesAutoresizingMaskIntoConstraints = false
    
        let profileDetailsWithImage = UIStackView(arrangedSubviews: [self.profileImage,profileDetails])
        profileDetailsWithImage.axis = .horizontal
        profileDetailsWithImage.alignment = .center
        profileDetailsWithImage.distribution = .fillProportionally
        profileDetailsWithImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.profileImage.leadingAnchor.constraint(equalTo: profileDetailsWithImage.leadingAnchor),
            self.profileImage.widthAnchor.constraint(equalToConstant: 50),
            self.profileImage.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        return profileDetailsWithImage
    }()
    
    
    private lazy var commentMainBody:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.profileInfo,self.comment])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.comment.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.comment)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    public func updateCellWithReview(_ review:MovieReviewModel){
        if let username = review.author_details?.username{
            DispatchQueue.main.async { [weak self] in
                self?.username.text = username
            }
        }
        
        if let created_at = review.created_at{
            DispatchQueue.main.async { [weak self] in
                self?.created_at.text = created_at
            }
        }
        
        if let imgURL = review.author_details?.avatar_path?.replacingOccurrences(of: "/", with: ""){
            DispatchQueue.main.async { [weak self] in
                ImageDownloader.shared.fetchImage(urlStr: imgURL) { [weak self] result in
                    switch result{
                        case .success(let img):
                            self?.profileImage.image = img
                        case .failure(let err):
                            print("(Error) Err : ",err.localizedDescription)
                    }
                }
            }
        }
        
        
        if let comment = review.content{
            DispatchQueue.main.async { [weak self] in
                self?.comment.text = comment
            }
        }
    }
    
    func setupLayout(){
        
        NSLayoutConstraint.activate([
            self.comment.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            self.comment.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:  -10),
            self.comment.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
			self.comment.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
            
        ])
        
    }
    
}

extension MovieReviewCollectionViewCell{
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.review =  nil
        self.comment.text = ""
        self.profileImage.image = .init(named: "placeHolder")
        self.created_at.text = ""
        self.username.text = ""
    }
}
