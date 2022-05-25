//
//  SliderViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 17.01.2022.
//


import UIKit

class SliderViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var textFieldImage: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomNavigation: UITabBarItem!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    //MARK: - vars/lets
    let fullScreen = ImageFullScreen.instanceFromNib()
    let deleteScreen = deleteAttention.instanceFromNib()
    let sliderAttentionScreen = sliderAttention.instanceFromNib()
    var likeButton: UIBarButtonItem?
    
    var viewModel = SliderViewModel()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        addRecognizer()
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainSettings()
        viewModel.loadController(textFieldImage, navigationTitle)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.clearController()
    }
    
    //MARK: - IBActions
    //Recognizeres ----
    @IBAction func tapDetected(_ recognizer: UITapGestureRecognizer) {
        viewModel.singleTap()

    }
    
    @IBAction func doubleTapDetected(_ recognizer: UITapGestureRecognizer) {
        viewModel.doubleTap(fullScreen)

    }
    
    @IBAction func swipeLeft(_ recognizer: UISwipeGestureRecognizer) {
        secondImageView.isHidden = false
        viewModel.swipeLeft()
        loadLeftSwipe()

        
    }
    
    @IBAction func swipeRight(_ recognizer: UISwipeGestureRecognizer) {
        secondImageView.isHidden = false
        viewModel.swipeRight()
        loadRightSwipe()

    }
    
    //END OF Recognizeres ----
    @IBAction func textFieldSave(_ sender: UITextField) {
        viewModel.textFieldEndEditing(textField:sender)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIBarButtonItem) {
        viewModel.likeButtonPresed()

    }
    
    @IBAction func trashButtonPressed() {
        viewModel.trashButtonPressed()

    }
    
    @IBAction func deleteOkButtonPresed(_ sender: UIButton){
        viewModel.deleteButtonPressed(textFieldImage, navigationTitle)
    }
    
    //MARK: - flow func
    private func mainSettings() {
        self.navigationController?.navigationBar.tintColor = Settings.shared.textColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.shared.textColor]
        navBarInfoButtonAdd()
        self.view.backgroundColor = Settings.shared.sliderColor
        
        self.textFieldImage.attributedPlaceholder = NSAttributedString(string: "Add description...", attributes: [NSAttributedString.Key.foregroundColor: Settings.shared.textColor])
        self.textFieldImage.backgroundColor = UIColor.clear
        self.textFieldImage.borderStyle = .none
        self.textFieldImage.textColor = Settings.shared.textColor
        self.textFieldImage.delegate = self
        //xib settings
        self.sliderAttentionScreen.addSettings()
        self.sliderAttentionScreen.center = self.view.center
        self.sliderAttentionScreen.alertTitle.text = "Section Slider"
        self.sliderAttentionScreen.alertDescription.text = "Add photos to the main album to view them in this section"
        self.fullScreen.alpha = 0
        self.deleteScreen.addSettings()
        self.deleteScreen.textLabel.text = "Are you sure want to delete the photo?"
        self.deleteScreen.center = self.view.center
        self.deleteScreen.okButton.addTarget(self, action: #selector(deleteOkButtonPresed(_:)), for: .touchUpInside)
        //xib settings
    }
    
    private func bind() {
        self.viewModel.showAlert = {
            self.view.addSubview(self.sliderAttentionScreen)
        }
        
        self.viewModel.hideAlert = {
            self.sliderAttentionScreen.removeFromSuperview()
        }
        
        self.viewModel.showDeleteAlert = {
            self.view.addSubview(self.deleteScreen)
            UIView.animate(withDuration: 0.5) {
                self.deleteScreen.blur.alpha = 1
            }
        }
        
        self.viewModel.hideDeleteAlert = {
            self.deleteScreen.removeFromSuperview()
            self.deleteScreen.blur.alpha = 0
        }
        
        self.viewModel.showFullScreen = {
            self.view.addSubview(self.fullScreen)
            UIView.animate(withDuration: 0.5) {
                self.fullScreen.alpha = 1
                self.navigationController?.isNavigationBarHidden = true
                self.imageContainer.isHidden = true
                self.textFieldImage.isHidden = true
                self.tabBarController?.tabBar.isHidden = true
            }
        }
        
        self.viewModel.hideFullScreen = {
            self.view.endEditing(true)
            self.navigationController?.isNavigationBarHidden = false
            self.fullScreen.alpha = 0
            self.fullScreen.removeFromSuperview()
            self.imageContainer.isHidden = false
            self.textFieldImage.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }
        
        self.viewModel.isLike = {
            self.likeButton?.image = UIImage(systemName: "heart.fill")
            self.likeButton?.tintColor = .red
        }
        
        self.viewModel.noLike = {
            self.likeButton?.image = UIImage(systemName: "heart")
            self.likeButton?.tintColor = Settings.shared.textColor
        }
        
        self.viewModel.firstImageView.bind { [weak self] firstImageView in
            self?.firstImageView.image = firstImageView
        }
        
        self.viewModel.secondImageView.bind { [weak self] secondImageView in
            self?.secondImageView.image = secondImageView
        }
        
        self.viewModel.likeButton.bind { [weak self] likeButton in
            self?.likeButton = likeButton
        }
        self.viewModel.signature.bind { [weak self] signature in
            self?.textFieldImage.text = signature
        }
        
        
    }
    
    
    //MARK: - swipe functions
    private func loadLeftSwipe() {
        if viewModel.loadSecondImage() {
            UIView.animate(withDuration: 0.5) {
                self.firstImageView.frame.origin.x = self.view.frame.minX - self.firstImageView.frame.width * 2
            } completion: { _ in
                self.secondImageView.isHidden = true
                self.firstImageView.image = self.secondImageView.image
                self.firstImageView.frame.origin.x = 0
            }
            viewModel.updateScrollView(navigationTitle)
        }
    }
    
    private func loadRightSwipe() {
        if viewModel.loadFirstImage() {
            self.firstImageView.frame.origin.x  = self.view.frame.minX - self.firstImageView.frame.width
            UIView.animate(withDuration: 0.5) {
                self.firstImageView.frame.origin.x = 0
            } completion: { _ in
                self.secondImageView.isHidden = true
                self.secondImageView.image = self.firstImageView.image
            }
            viewModel.updateScrollView(navigationTitle)
        }
    }
    
    // END OF SWIPE FUNCTIONS ---------
    private func navBarInfoButtonAdd(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(likeButtonPressed(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(trashButtonPressed))
        likeButton = self.navigationItem.rightBarButtonItem!
    }
    
    private func addRecognizer() {
        let recongizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.view.addGestureRecognizer(recongizer)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapDetected(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
    }
    
    //MARK: - Keyboard ScrollView
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 0
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            bottomConstraint.constant = keyboardScreenEndFrame.height + 15
        }
        
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension SliderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

