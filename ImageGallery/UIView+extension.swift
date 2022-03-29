//
//  UIview.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 16.01.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func addGradient() {
     let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.red.cgColor]
     gradient.opacity =  1
     gradient.startPoint = CGPoint(x: 0, y: 0)
     gradient.endPoint = CGPoint(x: 1, y: 1)
     gradient.frame = self.bounds
     gradient.cornerRadius = self.layer.cornerRadius
     self.layer.insertSublayer(gradient, at: 0)
    }
    
    func pinCodeButtonsContainerSettings(){
        self.backgroundColor = Settings.shared.secondColor
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
