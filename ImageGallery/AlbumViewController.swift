//
//  AlbumViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 17.01.2022.
//

import UIKit

class AlbumViewController: UIViewController{
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet var importButtons: [UIButton]!
    @IBOutlet weak var imageViewCenterScreen: UIView!

    //MARK: - vars/lets
    let deleteScreen = deleteAttention.instanceFromNib()
    let firstAttentionView = FirstAttention.instanceFromNib()
    var plusButtonActive = false
    var firstTime = UserDefaults.standard.value(Bool.self, forKey: keys.firstEnter)
    var imageObjectArray: [imageObject] = []
    let itemsPerRow:CGFloat = 4
    let sectionsInserts = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCollectionImage()
        reloadInfoViewCenter()
        mainSettings()
        navigationBarButtonsAdd()
        loginFirstTime()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rotatePlusButton()
    }
    //MARK: - IBActions
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        if self.plusButtonActive {
            rotatePlusButton()
        } else {
            for importButton in self.importButtons {
                UIView.animate(withDuration: 0.3) {
                    importButton.alpha = 1
                    self.plusButton.backgroundColor = .red
                    self.plusButton.transform = CGAffineTransform(rotationAngle: 135 * .pi/180)
                    self.blurView.alpha = 1
                }
            }
            self.plusButtonActive = true
        }
    }
    
    @IBAction func openCameraPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        rotatePlusButton()
    }
    
    @IBAction func importPhotoButtonPressed(_ sender: UIButton) {
        loadImagePicker()
        rotatePlusButton()
    }
    
    @IBAction func infoButtonPressed() {
        firstAttention()
    }
    
    @IBAction func trashButtonPressed() {
        if !self.imageObjectArray.isEmpty{
            self.view.addSubview(deleteScreen)
            UIView.animate(withDuration: 0.5) {
                self.deleteScreen.blur.alpha = 1
            }
        }
    }
    
    //MARK: - flow func
    private  func mainSettings() {
        self.navigationController?.navigationBar.tintColor = Settings.shared.textColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.shared.textColor]
        self.view.backgroundColor = Settings.shared.mainColor
        self.plusButton.layer.cornerRadius = self.plusButton.frame.width / 2
        self.plusButton.backgroundColor = UIColor(red: 76/255, green: 87/255, blue: 180/255, alpha: 0.8)
        for importButton in self.importButtons {
            importButton.backgroundColor = Settings.shared.fourthColor
            importButton.addButtonRadius(15)
            importButton.alpha = 0
        }
        
        //------xib settings
        self.firstAttentionView.addSettings()
        self.firstAttentionView.center = self.view.center
        self.deleteScreen.addSettings()
        self.deleteScreen.center = self.view.center
        //------xib settings
    }
    
    private func loginFirstTime() {
        if firstTime ?? true {
            firstAttention()
            firstTime = false
            UserDefaults.standard.set(encodable: firstTime, forKey: keys.firstEnter)
        }
    }
    
    private func rotatePlusButton() {
        for importButton in self.importButtons {
            UIView.animate(withDuration: 0.3) {
                importButton.alpha = 0
                self.plusButton.backgroundColor = UIColor(red: 76/255, green: 87/255, blue: 180/255, alpha: 0.8)
                self.plusButton.transform = CGAffineTransform(rotationAngle: 0 * .pi/180)
                self.blurView.alpha = 0
            }
        }
        self.plusButtonActive = false
    }
    
    private func navigationBarButtonsAdd() {
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(infoButtonPressed))
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(trashButtonPressed))
    }
    
    private func firstAttention() {
        self.view.addSubview(firstAttentionView)
        UIView.animate(withDuration: 0.5) {
            self.firstAttentionView.blurEffectView.alpha = 0.8
            self.firstAttentionView.attentionView.alpha = 1
        }
    }
    
    private func reloadCollectionImage() {
        self.imageObjectArray = UserDefaults.standard.value([imageObject].self, forKey: keys.images) ?? []
        self.collectionView.reloadData()
        
    }
    
    private func reloadInfoViewCenter() {
        if !self.imageObjectArray.isEmpty {
            self.imageViewCenterScreen.isHidden = true
        } else {
            self.imageViewCenterScreen.isHidden = false
        }
    }
    
    private func loadImagePicker () {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

//MARK: - Extensions
extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageObjectArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.imageViewCell.image = UIImage(systemName: "plus")
            cell.imageViewCell.tintColor = Settings.shared.textColor
        }
        
        if indexPath.item > 0 {
            cell.configure(with: imageObjectArray[indexPath.item - 1])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionsInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let controller = self.tabBarController?.viewControllers?[2] as? UINavigationController,
              let sliderViewController = controller.topViewController as? SliderViewController else { return }
        
        if indexPath.item == 0 {
            loadImagePicker()
        } else {
            if indexPath.item == 1 {
                sliderViewController.imageIndex = 0
            } else {
                sliderViewController.imageIndex = indexPath.item - 1
            }
            self.tabBarController?.selectedIndex = 2
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionsInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInserts.left
    }
    
}


