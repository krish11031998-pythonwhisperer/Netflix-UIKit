//
//  UIViewExtension.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 22/05/2022.
//

import Foundation
import QuartzCore
import UIKit

extension UIView{
    public func gradientLayerBuilder() -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        return gradient
    }
    
    public func imageView(cornerRadius:CGFloat = 10, borderColor:UIColor = .clear,borderWidth:CGFloat = 1,autoLayout:Bool = true,addGradient:Bool = false) -> UIImageView{
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = .init(named: "placeHolder")
        imageView.translatesAutoresizingMaskIntoConstraints = autoLayout
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderColor = borderColor.cgColor
        imageView.layer.borderWidth = borderWidth
        if addGradient{
            imageView.layer.addSublayer(self.gradientLayerBuilder())
        }
        return imageView
    }
    
    public func imageButton(buttonImage:String) -> UIButton{
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let buttonImage = UIImage(systemName: buttonImage, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)){
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(buttonImage, for: .normal)
            button.tintColor = .white
            button.imageView?.contentMode = .scaleAspectFill
            button.backgroundColor = .black
            button.imageView?.clipsToBounds = true
        }
        
        button.backgroundColor = .black

        return button
    }
    
    public func labelBuilder(text:String,size:CGFloat = 13,weight:UIFont.Weight = .semibold,color:UIColor,numOfLines:Int) -> UILabel{
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.numberOfLines = numOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
