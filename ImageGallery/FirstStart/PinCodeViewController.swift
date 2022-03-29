//
//  PinCodeViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 15.01.2022.
//

import UIKit
import SwiftyKeychainKit

class PinCodeViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var textFieldPin: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pinCodeButtonsView: UIView!
    @IBOutlet weak var viewMainTitle: UILabel!
    @IBOutlet weak var viewSubtitle: UILabel!
    
    
    //MARK: - vars/lets
    var password: String?
    let keychain = Keychain(service: "keychain.service")
    let key = KeychainKey<String>(key: keys.password)
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainSettings()
    }
    
    //MARK: - IBActions

    @IBAction func numberPressed(_ sender: UIButton) {
        if self.textFieldPin.text!.count < 8 {
            self.textFieldPin.text! += "\(sender.tag)"

        }
        if self.textFieldPin.text!.count >= 4 && self.password == nil {
            self.registrationButton.tintColor = .white
            self.registrationButton.isUserInteractionEnabled = true
        }
        passwordCheck()
    }
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        self.password = textFieldPin.text ?? ""
        viewMainTitle.text = "Подтвердите пароль"
        viewSubtitle.text = "Ваш пароль будет использован при каждом входе в приложение. Он предназначен для защиты от правонарушителей."
        textFieldPin.text = ""
        self.registrationButton.addRegistrationButtonSettings()

    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.textFieldPin.text = ""
        self.registrationButton.addRegistrationButtonSettings()
    }
    
    //MARK: - flow func
    private func mainSettings() {
        self.view.backgroundColor = Settings.shared.mainColor
        self.pinCodeButtonsView.pinCodeButtonsContainerSettings()
        self.textFieldPin.addSettingsTextFiled()
        self.viewMainTitle.addLabelTintColor()
        self.viewSubtitle.addLabelTintColor()
        for numberButton in self.numberButtons {
            numberButton.addPinCodeButtonsSettings()
        }
        self.registrationButton.addRegistrationButtonSettings()
    }
    
    private func passwordCheck() {
        if let password = self.password {
            if self.textFieldPin.text!.count == password.count{
                if self.textFieldPin.text == password {
                    try? keychain.set(password, for: key)
                    guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController else {return}
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                } else {
                    self.viewMainTitle.text = "Установите пин-код"
                    self.viewSubtitle.text = "Неверный пин-код, попробуйте снова"
                    self.textFieldPin.text = ""
                    self.password = nil
                    self.registrationButton.addRegistrationButtonSettings()
                    return
                }
            }
        }
    }

}
 
