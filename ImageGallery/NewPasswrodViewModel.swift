//
//  NewPasswrodViewModel.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 22.05.2022.
//

import Foundation
import SwiftyKeychainKit

class NewPasswrodViewModel {
   //MARK: - vars/lets
    var viewMainTitle = Bindable<String?>(nil)
    var viewSubtitle = Bindable<String?>(nil)
    
    var registrationButtonActive: (()->())?
    var registrationButtonNoActive: (()->())?
    var navigate: (()->())?
    
    private var password: String?
    private let keychain = Keychain(service: "keychain.service")
    private let key = KeychainKey<String>(key: keys.password)
    
    //MARK: - Actions
    func numberButtonPressed(button: UIButton, pin: UITextField) {
        if pin.text!.count < 8 {
            pin.text! += "\(button.tag)"
        }
        if pin.text!.count >= 4 && self.password == nil {
            self.registrationButtonActive?()
        }
        passwordCheck(textField: pin)
    }
    
    func registrationButtonPressed(passwordText: UITextField) {
        password = passwordText.text ?? ""
        viewMainTitle.value = "Подтвердите пароль"
        viewSubtitle.value = "Ваш пароль будет использован при каждом входе в приложение. Он предназначен для защиты от правонарушителей."
        passwordText.text = ""
        registrationButtonNoActive?()
    }
    
    func deleteButtonPressed(textFiled: UITextField) {
        textFiled.text = ""
        registrationButtonNoActive?()
    }
    
   //MARK: - flow func
    private func passwordCheck(textField: UITextField) {
        if let password = self.password {
            if textField.text!.count == password.count{
                if textField.text == password {
                    try? keychain.set(password, for: key)
                    navigate?()
                } else {
                    viewMainTitle.value = "Установите пин-код"
                    viewSubtitle.value = "Неверный пин-код, попробуйте снова"
                    textField.text = ""
                    self.password = nil
                    registrationButtonNoActive?()
                    return
                }
            }
        }
    }
    
    
}
