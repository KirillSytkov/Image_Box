//
//  AlbumViewModel.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 20.05.2022.
//

import Foundation
import UIKit

class AlbumViewModel {
    //MARK: - vars/lets
    var reloadCollectionView: (()->())?
    var showCenterView: (()->())?
    var hideCenterView:(()->())?
    var showAlert: (()->())?
    var activePlusButton: (()->())?
    var deactivatePlusButton:(()->())?
    private var galleryModel = GalleryModel.shared
    private var firstStart = UserDefaults.standard.value(Bool.self, forKey: keys.albumStart)
    private var plusButtonActive = false
    private var cellViewModels: [ImageCollectionCellViewModel] = [ImageCollectionCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    //MARK: - flow func
    func loadController() {
        if firstStart ?? true {
            showAlert?()
            firstStart = false
            UserDefaults.standard.set(encodable: firstStart, forKey: keys.albumStart)
        }
        updateAlbumCollection()
    }
    
    private func updateAlbumCollection() {
        galleryModel.updateImages()
        if galleryModel.images.isEmpty {
                showCenterView?()
            } else {
                hideCenterView?()
        }
        createCell(images: galleryModel.images)
    }
    
    private func createCell(images: [imageObject]){
        var viewModelCell = [ImageCollectionCellViewModel]()
        
        for image in images {
            viewModelCell.append(ImageCollectionCellViewModel(imageName: image.name))
        }
        
        cellViewModels = viewModelCell
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> ImageCollectionCellViewModel {
        return cellViewModels[indexPath.item]
    }
    
    func clearGallery() {
        galleryModel.images.removeAll()
    }

    //MARK: - Actions
    func infoButtonPressed() {
        showAlert?()
    }
    
    func plusButtonPressed() {
        if plusButtonActive {
            deactivatePlusButton?()
            plusButtonActive = false
        } else {
            activePlusButton?()
            plusButtonActive = true
        }
    }
    
    func openCamreButtonPressed(view: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = view
        view.present(imagePicker, animated: true, completion: nil)
        deactivatePlusButton?()
    }
    
    func importPhotoButtonPressed(view: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = view
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        view.present(imagePicker, animated: true, completion: nil)
        deactivatePlusButton?()
    }
}
