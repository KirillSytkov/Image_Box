//
//  UItextField+extension.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 13.02.2022.
//

import Foundation
import UIKit

extension UITextField{
    
    func addSettingsTextFiled(_ radius: CGFloat = 15) {
        self.backgroundColor = Settings.shared.secondColor
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
