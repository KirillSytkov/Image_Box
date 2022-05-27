
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
        viewMainTitle.textColor = UIColor(named: "textColor")
        viewSubtitle.textColor = UIColor(named: "textColor")
        viewMainTitle.text = "Set password"
        viewSubtitle.text = "Your password will be used each time you log into the application. It is designed to protect against offenders."
        for numberButton in numberButtons {
            numberButton.addPinCodeButtonsSettings()
        }
        registrationButton.addRegistrationButtonSettings()
        registrationButton.setTitle("Set password", for: .normal)
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
 
