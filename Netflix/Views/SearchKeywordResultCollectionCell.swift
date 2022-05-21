//
//  SearchKeywordResultCollectionCell.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 19/05/2022.
//

import Foundation
import UIKit

class SerachResultCollectionCell:UICollectionViewCell{

    static var identifier = "SearchKeyword"
    
    private var keywordData:KeywordData?
    public var handleKeywordSelection:((String) -> Void) = { text in
       print("Text : ",text)
    }
    
    private let keywordView:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font  = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleOnTap(_:)))
        self.addGestureRecognizer(tap)
        self.addSubview(self.keywordView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    private func setupLayout(){
        
        NSLayoutConstraint.activate([
            self.keywordView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.keywordView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            self.keywordView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75)
        ])
    }
    
    
    public func updateKeyword(_ keyword:KeywordData){
        self.keywordData = keyword
        if let name = keyword.name{
            DispatchQueue.main.async {
                self.keywordView.text = name
            }
        }
    }

    @objc func handleOnTap(_ sender:UITapGestureRecognizer? = nil){
        if let safeKeyword = self.keywordData?.name,let safeId = keywordData?.id{
            print("(DEBUG) Clicked on : \(safeKeyword)")
            self.handleKeywordSelection("\(safeId)")
        }
    }
    
}
