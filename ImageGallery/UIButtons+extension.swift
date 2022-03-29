//
//  UIButtons+extension.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 12.02.2022.
//

import Foundation
import UIKit

extension UIButton{
    
    func addButtonColor() {
        self.tintColor = UIColor(named:"textColor")
    }
    
    func addButtonRadius(_ radius: CGFloat = 25) {
        self.layer.cornerRadius = radius
    }
    
    func addPinCodeButtonsSettings() {
        self.addButtonRadius(15)
        self.addButtonColor()
        self.backgroundColor = Settings.shared.thirdColor
        self.configuration?.titleAlignment = .center
    }
    
    func addRegistrationButtonSettings() {
        self.backgroundColor = Settings.shared.fourthColor
        self.addButtonRadius()
        self.tintColor = .gray
        self.isUserInteractionEnabled = false
    }
}
