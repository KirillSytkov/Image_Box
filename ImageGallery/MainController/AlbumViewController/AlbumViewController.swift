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
    let infoAlert = FirstAttention.instanceFromNib()
    let itemsPerRow: CGFloat = 4
    let sectionsInserts = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    var viewModel = AlbumViewModel()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainSettings()
        viewModel.loadController()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deactivatePlusButtonRotate()
    }
    
    //MARK: - IBActions
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        viewModel.plusButtonPressed()

    }
    
    @IBAction func openCameraPressed(_ sender: UIButton) {
        viewModel.openCamreButtonPressed(view: self)

    }
    
    @IBAction func importPhotoButtonPressed(_ sender: UIButton) {
        viewModel.importPhotoButtonPressed(view: self)
    }
    
    @IBAction func infoButtonPressed() {
        viewModel.infoButtonPressed()
    }
    
    //MARK: - flow func
    private  func mainSettings() {
        self.navigationController?.navigationBar.tintColor = Settings.shared.textColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.shared.textColor]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(infoButtonPressed))
        self.view.backgroundColor = Settings.shared.mainColor
        self.plusButton.layer.cornerRadius = self.plusButton.frame.width / 2
        self.plusButton.backgroundColor = UIColor(red: 76/255, green: 87/255, blue: 180/255, alpha: 0.8)
        for importButton in self.importButtons {
            importButton.backgroundColor = Settings.shared.fourthColor
            importButton.addButtonRadius(15)
            importButton.alpha = 0
        }
        //------xib settings
        self.infoAlert.addSettings()
        self.infoAlert.center = self.view.center
        //------xib settings
    }
    
    private func bind() {
        viewModel.reloadCollectionView = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        viewModel.hideCenterView = {
                self.imageViewCenterScreen.isHidden = true
        }
        
        viewModel.showCenterView = {
                self.imageViewCenterScreen.isHidden = false
        }
        
        viewModel.showAlert = {
                self.view.addSubview(self.infoAlert)
                self.animateAlert()
        }
        viewModel.activePlusButton = {
            self.activePlusButtonRotate()
        }
        
        viewModel.deactivatePlusButton = {
            self.deactivatePlusButtonRotate()
        }
        
        
        
    }

    private func activePlusButtonRotate() {
        for importButton in self.importButtons {
            UIView.animate(withDuration: 0.3) {
                importButton.alpha = 1
                self.plusButton.backgroundColor = .red
                self.plusButton.transform = CGAffineTransform(rotationAngle: 135 * .pi/180)
                self.blurView.alpha = 1
            }
        }
    }
    
    private func deactivatePlusButtonRotate() {
        for importButton in self.importButtons {
            UIView.animate(withDuration: 0.3) {
                importButton.alpha = 0
                self.plusButton.backgroundColor = UIColor(red: 76/255, green: 87/255, blue: 180/255, alpha: 0.8)
                self.plusButton.transform = CGAffineTransform(rotationAngle: 0 * .pi/180)
                self.blurView.alpha = 0
            }
        }
    }
    private func animateAlert() {
        UIView.animate(withDuration: 0.5) {
            self.infoAlert.blurEffectView.alpha = 0.8
            self.infoAlert.attentionView.alpha = 1
            
        }
    }

}

//MARK: - Extensions
extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.configure(image: cellViewModel.imageName)
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
        
            sliderViewController.imageIndex = indexPath.item
            
            self.tabBarController?.selectedIndex = 2
        
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


