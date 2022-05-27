
import Foundation
import SwiftyKeychainKit

class EntranceViewModel {
    
    //MARK: - vars/lets
    var mainLabel = Bindable<String?>(nil)

    var shakeTextField: (()->())?
    var errorPassword: (()->())?
    var navigate: (()->())?
    
    private var password: String?
    private let keychain = Keychain(service: "keychain.service")
    private let key = KeychainKey<String>(key: keys.password)
    
    //MARK: - Actions
    func deleteButtonPressed(textField: UITextField) {
        textField.text = ""
    }
    
    func numberButtonPressed(number: UIButton, textField: UITextField) {
        if textField.text!.count < self.password!.count {
            textField.text! += "\(number.tag)"
        }
        if textField.text!.count == self.password!.count {
            passwordCheck(textField: textField)
        }
    }
    
    //MARK: - flow func
    func addPassword() {
        password = try? keychain.get(key)
    }
    
    private func passwordCheck(textField: UITextField) {
        if self.password == textField.text {
            navigate?()
        } else {
            mainLabel.value = "Invalid password"
            textField.text = ""
            errorPassword?()
            shakeTextField?()
        }
      
    }
}
