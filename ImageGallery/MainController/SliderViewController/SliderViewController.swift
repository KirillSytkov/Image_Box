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
    var imageObjectArray: [imageObject] = []
    var imageIndex = 0
    var like = false
    
//MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addRecognizer()
        registerForKeyboardNotifications()
        likeButton = navBarInfoButtonAdd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainSettings()
        loadSliderView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.imageIndex = 0        
        self.imageObjectArray.removeAll()
    }
    
//MARK: - IBActions
    //Recognizeres ----
    @IBAction func tapDetected(_ recognizer: UITapGestureRecognizer) {
        if !imageObjectArray.isEmpty {
            self.view.endEditing(true)
            self.navigationController?.isNavigationBarHidden = false
            self.fullScreen.removeFromSuperview()
            self.imageContainer.isHidden = false
            self.textFieldImage.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    @IBAction func doubleTapDetected(_ recognizer: UITapGestureRecognizer) {
        if !imageObjectArray.isEmpty {
            self.view.addSubview(self.fullScreen)
            self.fullScreen.imageZoom.image = ImageManager.shared.loadImage(fileName: imageObjectArray[imageIndex].name)
            UIView.animate(withDuration: 0.5) {
                self.fullScreen.alpha = 1
                self.navigationController?.isNavigationBarHidden = true
                self.imageContainer.isHidden = true
                self.textFieldImage.isHidden = true
                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }
    
    @IBAction func swipeLeft(_ recognizer: UISwipeGestureRecognizer) {
        secondImageView.isHidden = false
        if !imageObjectArray.isEmpty{
            imageObjectArray[imageIndex].signature = self.textFieldImage.text ?? ""
            if imageIndex <= (imageObjectArray.count - 1) && imageIndex > 0{
                imageIndex -= 1
            } else {
                imageIndex = imageObjectArray.count - 1
            }
            loadLeftSwipe()
        }
 
    }
    
    @IBAction func swipeRight(_ recognizer: UISwipeGestureRecognizer) {
        secondImageView.isHidden = false
        if !imageObjectArray.isEmpty{
            imageObjectArray[imageIndex].signature = self.textFieldImage.text ?? ""
            if imageIndex < (imageObjectArray.count - 1) {
                imageIndex += 1
            } else {
                imageIndex = 0
            }
            loadRightSwipe()

        }
    }
    
    //END OF Recognizeres ----
    @IBAction func textFieldSave(_ sender: UITextField) {
        if !imageObjectArray.isEmpty{
            imageObjectArray[imageIndex].signature = self.textFieldImage.text ?? ""
            UserDefaults.standard.set(encodable: imageObjectArray, forKey: keys.images)
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: UIBarButtonItem) {
        if !imageObjectArray.isEmpty {
            if !self.like {
                sender.image = UIImage(systemName: "heart.fill")
                sender.tintColor = .red
            } else {
                sender.image = UIImage(systemName: "heart")
                sender.tintColor = Settings.shared.textColor
            }
            self.like = !like
            imageObjectArray[imageIndex].favorite = self.like
            UserDefaults.standard.set(encodable: imageObjectArray, forKey: keys.images)
        }
    }
    
    @IBAction func trashButtonPressed() {
        if !self.imageObjectArray.isEmpty{
            self.view.addSubview(deleteScreen)
            UIView.animate(withDuration: 0.5) {
                self.deleteScreen.blur.alpha = 1
            }
        }
    }
    
    @IBAction func deleteOkButtonPresed(_ sender: UIButton){
        if !self.imageObjectArray.isEmpty {
            ImageManager.shared.deleteImage(imageArray: imageObjectArray, imageIndex: imageIndex)
//            imageObjectArray.remove(at: imageIndex)
            if imageIndex != 0 {
                imageIndex -= 1
            }
//            UserDefaults.standard.set(encodable: imageObjectArray, forKey: keys.images)
            if !self.imageObjectArray.isEmpty {
                checkLike()
                self.textFieldImage.text = self.imageObjectArray[imageIndex].signature
                self.secondImageView.image = ImageManager.shared.loadImage(fileName: imageObjectArray[imageIndex].name)
                self.firstImageView.image = ImageManager.shared.loadImage(fileName: imageObjectArray[imageIndex].name)
                self.navigationTitle.setTitle(mainDateSelected(imageObjectArray[imageIndex]), subtitle: minutesDateSelect(imageObjectArray[imageIndex]))
            } else {
                self.like = false
                self.textFieldImage.text = ""
                self.textFieldImage.isHidden = true
                self.like = false
                self.likeButton?.image = UIImage(systemName: "heart")
                self.likeButton?.tintColor = .white
                self.secondImageView.image = nil
                self.firstImageView.image = nil
                self.navigationTitle.setTitle("Слайдер", subtitle: "")
                self.view.addSubview(sliderAttentionScreen)
            }
        }
        self.deleteScreen.removeFromSuperview()
        self.deleteScreen.blur.alpha = 0
    }
    
//MARK: - flow func
    private func mainSettings() {
        self.navigationController?.navigationBar.tintColor = Settings.shared.textColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.shared.textColor]
        self.view.backgroundColor = Settings.shared.sliderColor
        
        self.textFieldImage.attributedPlaceholder = NSAttributedString(string: "Добавить подпись...", attributes: [NSAttributedString.Key.foregroundColor: Settings.shared.textColor])
        self.textFieldImage.backgroundColor = UIColor.clear
        self.textFieldImage.borderStyle = .none
        self.textFieldImage.textColor = Settings.shared.textColor
        //xib settings
        self.sliderAttentionScreen.addSettings()
        self.sliderAttentionScreen.center = self.view.center
        self.fullScreen.alpha = 0
        self.deleteScreen.addSettings()
        self.deleteScreen.center = self.view.center
        self.deleteScreen.okButton.addTarget(self, action: #selector(deleteOkButtonPresed(_:)), for: .touchUpInside)
        //xib settings
    }
    
    private func loadSliderView() {
        if self.imageObjectArray.isEmpty{
            self.imageObjectArray = UserDefaults.standard.value([imageObject].self, forKey: keys.images) ?? []
        }
        
        if !self.imageObjectArray.isEmpty{
            if self.imageIndex == 0 {
                self.imageIndex = self.imageObjectArray.count - 1
            }
            
            self.textFieldImage.isHidden = false
            self.firstImageView.image = ImageManager.shared.loadImage(fileName: imageObjectArray[imageIndex].name)
            self.secondImageView.image = ImageManager.shared.loadImage(fileName: imageObjectArray[imageIndex].name)
            self.textFieldImage.text = imageObjectArray[imageIndex].signature
            self.navigationTitle.setTitle(mainDateSelected(imageObjectArray[imageIndex]), subtitle: minutesDateSelect(imageObjectArray[imageIndex]))
            checkLike()
            self.sliderAttentionScreen.removeFromSuperview()
        } else {
            self.textFieldImage.isHidden = true
            self.view.addSubview(sliderAttentionScreen)
        }
    }
    
    private func checkLike() {
            self.like = imageObjectArray[imageIndex].favorite
            if self.like {
                likeButton?.image = UIImage(systemName: "heart.fill")
                likeButton?.tintColor = .red
            } else {
                likeButton?.image = UIImage(systemName: "heart")
                likeButton?.tintColor = Settings.shared.textColor
            }
    }
 
//MARK: - swipe functions
    private func updateScrollView() {
        self.textFieldImage.text = imageObjectArray[imageIndex].signature
        self.navigationTitle.setTitle(mainDateSelected(imageObjectArray[imageIndex]), subtitle: minutesDateSelect(imageObjectArray[imageIndex]))
        checkLike()
    }
    
    private func loadLeftSwipe() {
        guard let imageView = firstImageView,
              let secondImageView = secondImageView else {return}
        secondImageView.image = ImageManager.shared.loadImage(fileName: imageObjectArray[imageIndex].name)
        UIView.animate(withDuration: 0.5) {
            imageView.frame.origin.x = self.view.frame.minX - imageView.frame.width * 2
        } completion: { _ in
            secondImageView.isHidden = true
            imageView.image = secondImageView.image
            imageView.frame.origin.x = 0
        }
        updateScrollView()
    }
    
    private func loadRightSwipe() {
        guard let imageView = firstImageView,
              let secondImageView = secondImageView else {return}
        imageView.image = ImageManager.shared.loadImage(fileName: imageObjectArray[imageIndex].name)
        imageView.frame.origin.x  = self.view.frame.maxX + imageView.frame.width
        UIView.animate(withDuration: 0.5) {
            imageView.frame.origin.x = 0
        } completion: { _ in
            secondImageView.isHidden = true
            secondImageView.image = imageView.image
        }
        updateScrollView()
    }
    
// END OF SWIPE FUNCTIONS ---------
    private func navBarInfoButtonAdd() -> UIBarButtonItem {
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(likeButtonPressed(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(trashButtonPressed))

        return self.navigationItem.rightBarButtonItem!
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


