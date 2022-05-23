//
//  EntranceViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 16.01.2022.
//

import UIKit

class EntranceViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var textFieldPin: UITextField!
    @IBOutlet weak var subtitleView: UILabel!
    @IBOutlet weak var pinCodeButtonsView: UIView!
    @IBOutlet var numberButtons: [UIButton]!
    
    //MARK: - vars/lets
    private var viewModel = EntranceViewModel()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
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
        viewModel.deleteButtonPressed(textField: textFieldPin)
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        viewModel.numberButtonPressed(number: sender, textField: textFieldPin)
    }
    
    //MARK: - flow func

    private func mainSettings() {
        navigationController?.isNavigationBarHidden = true
        subtitleView.isHidden = true
        view.backgroundColor = Settings.shared.mainColor
        pinCodeButtonsView.pinCodeButtonsContainerSettings()
        textFieldPin.addSettingsTextFiled()
        mainLabel.text = "Enter password"
        mainLabel.textColor = UIColor(named: "textColor")
        subtitleView.text = "Try again"
        for numberButton in self.numberButtons {
            numberButton.addPinCodeButtonsSettings()
        }
    }

    private func bind() {
        self.viewModel.shakeTextField = {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1) {
                    UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true) {
                        self.textFieldPin.frame.origin.x -= 10
                    }
                }
            }
        }
        self.viewModel.navigate = {
            DispatchQueue.main.async {
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController else {return}
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        self.viewModel.errorPassword = {
            DispatchQueue.main.async {
                self.view.backgroundColor = .black
                self.view.addGradient()
                self.subtitleView.isHidden = false
            }
        }
        
        viewModel.addPassword()
    }
}
