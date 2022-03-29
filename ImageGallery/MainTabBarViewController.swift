//
//  MainTabBarViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 24.01.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        self.tabBar.tintColor = Settings.shared.tabBarColor
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.layer.cornerRadius = 15
    }

}
