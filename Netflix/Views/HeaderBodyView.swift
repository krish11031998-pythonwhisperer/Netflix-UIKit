//
//  HeaderBodyView.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 20/05/2022.
//

import UIKit

class HeaderBodyView: UIView {

    
    private let headerView:UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = Int.max
        return label
    }()
    
    
    private let bodyView:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = Int.max
        return label
    }()
    
    
    private let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.stackView.addArrangedSubview(self.headerView)
        self.stackView.addArrangedSubview(self.bodyView)
        self.addSubview(self.stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //stackViewArrangement
        
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func updateUI(header:String,body:String,headerSize:CGFloat = 13,bodySize:CGFloat = 20){
        DispatchQueue.main.async { [weak self] in
            self?.headerView.text = header
            self?.bodyView.text = body
            self?.headerView.font = .systemFont(ofSize: headerSize, weight: .semibold)
            self?.bodyView.font = .systemFont(ofSize: bodySize, weight: .medium)
        }
    }

}
