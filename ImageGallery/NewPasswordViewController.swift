//
//  NewPasswordViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 30.01.2022.
//

import UIKit

class NewPasswordViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var textFieldPin: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pinCodeButtonsView: UIView!
    @IBOutlet weak var viewMainTitle: UILabel!
    @IBOutlet weak var viewSubtitle: UILabel!
    
    //MARK: - vars/lets
    private var viewModel = NewPasswrodViewModel()

    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
    }
    //MARK: - IBActions

    @IBAction func numberPressed(_ sender: UIButton) {
        viewModel.numberButtonPressed(button: sender, pin: textFieldPin)

    }
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        viewModel.registrationButtonPressed(passwordText: textFieldPin)

    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        viewModel.deleteButtonPressed(textFiled: textFieldPin)
    }
    
    //MARK: - flow func
    private func mainSettings() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Settings.shared.mainColor
        pinCodeButtonsView.pinCodeButtonsContainerSettings()
        textFieldPin.addSettingsTextFiled()
        viewMainTitle.addLabelTintColor()
        viewSubtitle.addLabelTintColor()
        viewMainTitle.text = "Установите код доступа"
        viewSubtitle.text = "Ваш пароль будет использован при каждом входе в приложение. Он преднозначен для защиты от правонарушителей."
        for numberButton in numberButtons {
            numberButton.addPinCodeButtonsSettings()
        }
        registrationButton.addRegistrationButtonSettings()
    }

    private func bind() {

        self.viewModel.viewMainTitle.bind { [weak self] viewMainTitle in
            self?.viewMainTitle.text = viewMainTitle
        }
        self.viewModel.viewSubtitle.bind { [weak self] viewSubtitle in
            self?.viewSubtitle.text = viewSubtitle
        }
        self.viewModel.registrationButtonActive = {
            DispatchQueue.main.async {
                self.registrationButton.tintColor = .white
                self.registrationButton.isUserInteractionEnabled = true
            }
        }
        self.viewModel.registrationButtonNoActive = {
            DispatchQueue.main.async {
                self.registrationButton.addRegistrationButtonSettings()
            }
        }
        self.viewModel.navigate = {
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        
    }

}
 
