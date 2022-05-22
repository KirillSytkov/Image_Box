//
//  FavoritesViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 17.01.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageViewCenterScreen: UIView!
    
    //MARK: - vars/lets
    var infoAlert = InfoCustomAlert.instanceFromNib()
    let itemsPerRow:CGFloat = 4
    let sectionsInserts = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    let viewModel = FavoritesViewModel()
    
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
    
    //MARK: - IBActions
    @IBAction func infoButtonPressed() {
        viewModel.infoButtonPressed()
    }
    
    //MARK: - flow func
    private func mainSettings() {
        self.navigationController?.navigationBar.tintColor = Settings.shared.textColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.shared.textColor]
        self.view.backgroundColor = Settings.shared.mainColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(infoButtonPressed))
        self.infoAlert.addSettings()
        self.infoAlert.title.text = "Раздел Избранное"
        self.infoAlert.subtitle.text = "Здесь хранятся ваши избранные фотографии. Чтобы добавить фотографии  в этот раздел нажмите ❤ при просмотре фотографии в альбоме или слайдере."
        self.infoAlert.center = self.view.center
    }
    
    private func animateAlert() {
        UIView.animate(withDuration: 0.5) {
            self.infoAlert.blurEffectView.alpha = 0.8
            self.infoAlert.attentionView.alpha = 1
            
        }
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
    }
    
}

//MARK: - Extensions
extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.configure(image: cellVM.imageName)
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
        
        sliderViewController.viewModel.images = GalleryModel.shared.imageFavorites
        sliderViewController.viewModel.imageIndex = indexPath.item
        
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
