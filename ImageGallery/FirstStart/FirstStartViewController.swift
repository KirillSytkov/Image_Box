//
//  FirstStartViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 16.01.2022.
//

import UIKit
import SwiftyKeychainKit

class FirstStartViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var privacyPoliceText: UILabel!
    @IBOutlet var textLabel: [UILabel]!
    
    //MARK: - vars/lets
    let keychain = Keychain(service: "keychain.service")
    let key = KeychainKey<String>(key: keys.password)
    
    //MARK: - lyfecycle
    override func loadView() {
        super.loadView()
        let password = try? keychain.get(key)
        if password != nil {
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "EntranceViewController") as? EntranceViewController else {return}
            self.navigationController?.pushViewController(controller, animated: false)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainSetttins()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - IBActions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "PinCodeViewController") as? PinCodeViewController else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - flow func
    private func mainSetttins() {
        self.view.backgroundColor = Settings.shared.mainColor
        self.continueButton.backgroundColor = Settings.shared.fourthColor
        self.continueButton.addButtonRadius()
        for textLabel in textLabel {
            textLabel.addLabelTintColor()
        }
    }
}
