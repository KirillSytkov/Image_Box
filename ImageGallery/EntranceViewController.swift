//
//  EntranceViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 16.01.2022.
//

import UIKit
import SwiftyKeychainKit

class EntranceViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subtitleView: UILabel!
    @IBOutlet weak var pinCodeButtonsView: UIView!
    @IBOutlet weak var textFieldPin: UITextField!
    @IBOutlet var numberButtons: [UIButton]!
    
    //MARK: - vars/lets
    let keychain = Keychain(service: "keychain.service")
    let key = KeychainKey<String>(key: keys.password)
    
    var password:String?
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        password = try? keychain.get(key)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainSettings()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ThemeManager.shared.loadTheme(theme: UserDefaults.standard.integer(forKey: keys.settings) , view: view)
    }
    
    //MARK: - IBActions
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.textFieldPin.text = ""
    }
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        if self.textFieldPin.text!.count < self.password!.count {
            self.textFieldPin.text! += "\(sender.tag)"
        }
        if self.textFieldPin.text!.count == self.password!.count {
            passwordCheck()
        }
    }
    
    //MARK: - flow func
    private func passwordCheck() {
        if self.password == self.textFieldPin.text {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController else {return}
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.mainLabel.text = "Неверный пин-код"
            self.subtitleView.isHidden = false
            self.textFieldPin.text = ""
            self.view.backgroundColor = .black
            self.view.addGradient()
            shakeTextField()
        }
    }
    private func mainSettings() {
        self.navigationController?.isNavigationBarHidden = true
        self.subtitleView.isHidden = true
        self.view.backgroundColor = Settings.shared.mainColor
        self.pinCodeButtonsView.pinCodeButtonsContainerSettings()
        self.textFieldPin.addSettingsTextFiled()
        self.mainLabel.addLabelTintColor()
        for numberButton in self.numberButtons {
            numberButton.addPinCodeButtonsSettings()
        }
    }

    private func shakeTextField() {
        UIView.animate(withDuration: 0.1) {
            UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true) {
                self.textFieldPin.frame.origin.x -= 10
            }
        }
    }
}
