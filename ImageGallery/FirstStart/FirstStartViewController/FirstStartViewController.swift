
import UIKit

class FirstStartViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var privacyPoliceText: UILabel!
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var welcomeTitle: UILabel!
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(Bool.self, forKey: keys.firstEnter) == false {
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "EntranceViewController") as? EntranceViewController else {return}
            self.navigationController?.pushViewController(controller, animated: false)
        } else {
            mainSetttins()
        }

    }

    //MARK: - IBActions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "PinCodeViewController") as? PinCodeViewController else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - flow func
    private func mainSetttins() {
        self.view.backgroundColor = Settings.shared.mainColor
        continueButton.backgroundColor = Settings.shared.fourthColor
        continueButton.setTitle("Continue", for: .normal)
        continueButton.addButtonRadius()
        appLabel.text = "Image Box"
        appLabel.textColor = UIColor(named: "textColor")
        welcomeTitle.text = "Welcome"
        welcomeTitle.textColor = UIColor(named: "textColor")
        privacyPoliceText.text = "By using the application you accept the Terms of Use and Privacy Policy"
        privacyPoliceText.textColor = UIColor(named: "textColor")

    }
}
