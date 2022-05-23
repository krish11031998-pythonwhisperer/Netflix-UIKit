//
//  MovieVideoCellCollectionViewCell.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 22/05/2022.
//

import UIKit
import YouTubeiOSPlayerHelper

class MovieVideoCellCollectionViewCell: UICollectionViewCell {
    private var video:MovieVideoModel?
    private var videoState:YTPlayerState = .unstarted
    
    
    static let identifier = "MovieVideoCell"
    
    private lazy var imageView:UIImageView = self.imageView(cornerRadius: 10, borderColor: .clear, borderWidth: 1, autoLayout: true, addGradient: true)
    
    private lazy var playButton:UIButton = self.imageButton(buttonImage: "play.fill")
    
    private lazy var videoTitleLabel:UILabel = self.labelBuilder(text: "", size: 15, weight: .medium, color: .white, numOfLines: 2)
    
    private lazy var videoSubTitleLabel:UILabel = self.labelBuilder(text: "", size: 12, weight: .semibold, color: .white, numOfLines: 1)
    
    private lazy var videoPlayer:YTPlayerView = {
        let player = YTPlayerView()
        player.clipsToBounds = true
        player.layer.cornerRadius = 10
        player.delegate = self
        player.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(player)
        
        NSLayoutConstraint.activate([
            player.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5),
            player.topAnchor.constraint(equalTo: self.topAnchor,constant: 5)
        
        ])
        
        return player
    }()
    
    private lazy var videoInfoStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.videoTitleLabel,self.videoSubTitleLabel])
        stack.alignment = .leading
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.addSubview(self.imageView)
//        self.addSubview(self.videoPlayer)
        self.addSubview(self.playButton)
        self.playButton.addTarget(self, action: #selector(self.playVideo), for: .touchUpInside)
//        self.addSubview(self.videoInfoStack)
    }
    
    @objc func playVideo(){
        if self.videoState == .unstarted || self.videoState == .paused{
            self.videoPlayer.playVideo()
        }else if self.videoState == .playing{
            self.videoPlayer.pauseVideo()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        self.videoPlayer.frame = self.bounds.inset(by: .init(top: 5, left: 5, bottom: 5, right: 5))
        self.setupLayout()
    }
    
    public func updateMovieCell(_ video:MovieVideoModel){
        DispatchQueue.main.async {
            if let title = video.name{
                self.videoTitleLabel.text = title
            }
            
            if let videoId = video.key{
                self.videoPlayer.load(withVideoId: videoId)
            }
        }
    }
    
    
    private func setupLayout(){
        
//        self.videoInfoStack.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10).isActive = true
//        self.videoInfoStack.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10).isActive = true
//        self.videoInfoStack.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -20).isActive = true
//        self.videoInfoStack.heightAnchor.constraint(equalToConstant: self.videoInfoStack.arrangedSubviews.compactMap({$0.intrinsicContentSize.height}).reduce(0,{$0 + $1})).isActive = true
        
        self.playButton.topAnchor.constraint(equalTo: self.topAnchor,constant: 10).isActive = true
        self.playButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10).isActive = true
        self.playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.playButton.layer.cornerRadius = 25
        self.playButton.layer.borderWidth = 1
        self.playButton.layer.borderColor = UIColor.gray.cgColor
        
    }

}


extension MovieVideoCellCollectionViewCell:YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//        playerView.playVideo()
        self.videoState = .unstarted
    }
    
//    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
//        if self.videoState != state{
//            self.videoState = state
//        }
//    }
}
