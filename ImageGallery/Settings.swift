//
//  appMainSettings.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 16.01.2022.
//

import Foundation
import UIKit

enum Theme: Int {
    
    case device 
    case light
    case dark

}

class Settings {
    
    var mainColor: UIColor = UIColor(named: "backgroundColor")!
    var secondColor: UIColor = UIColor(named: "secondBackgroundColor")!
    var thirdColor: UIColor = UIColor(named: "thirdBackgroundColor")!
    var fourthColor: UIColor = UIColor(named: "fourthBackgroundColor")!
    var sliderColor: UIColor = UIColor(named: "sliderColor")!
    var textColor: UIColor = UIColor(named: "textColor")!
    var tabBarColor: UIColor = UIColor(named: "tabBarImageColor")!
    var tabBarBackground: UIColor = UIColor(named: "tabBarBackgroundColor")!
    
    
    static let shared = Settings()
    private init(){}
    
}
