
import UIKit

class PinCodeViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var viewMainTitle: UILabel!
    @IBOutlet weak var viewSubtitle: UILabel!
    @IBOutlet weak var textFieldPin: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var pinCodeButtonsView: UIView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: - vars/lets
    private var viewModel = PinCodeViewModel()

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
        UserDefaults.standard.set(encodable: false, forKey: keys.firstEnter)
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
        view.backgroundColor = Settings.shared.mainColor
        viewMainTitle.text = "Set password"
        viewMainTitle.textColor = UIColor(named: "textColor")
        viewSubtitle.text = "Your password will be used each time you log into the application. It is designed to protect against offenders."
        viewSubtitle.textColor = UIColor(named: "textColor")
        textFieldPin.addSettingsTextFiled()
        registrationButton.addRegistrationButtonSettings()
        registrationButton.setTitle("Set password", for: .normal) 
        pinCodeButtonsView.pinCodeButtonsContainerSettings()
        
        for numberButton in numberButtons {
            numberButton.addPinCodeButtonsSettings()
        }

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
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController else {return}
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        
    }

}
 
