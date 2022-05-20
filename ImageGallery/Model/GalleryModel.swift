//
//  galleryModel.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 29.03.2022.
//

import Foundation
import UIKit

class GalleryModel {
    
    var imagesCollection = [imageObject]()
    var firstTime = UserDefaults.standard.value(Bool.self, forKey: keys.firstEnter)
    var imageFavorites = [imageObject]()
    
    
    func reloadImageViewCenter( centerView: UIView ) {
        if !imagesCollection.isEmpty {
            centerView.isHidden = true
        } else {
            centerView.isHidden = false
        }
    }
    
    func updateImages() {
        imagesCollection = ImageManager.shared.loadImageArray()
        getFavorites()
    }
    
    func reloadCollectionImage(with collectionView: UICollectionView) {
//        imagesCollection = UserDefaults.standard.value([imageObject].self, forKey: keys.images) ?? []
        updateImages()
        collectionView.reloadData()
    }
    
    private func getFavorites() {
        for image in imagesCollection {
            if image.favorite {
                imageFavorites.append(image)
            }
        }
    }
    
    func loadImagePicker (view: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = view
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        view.present(imagePicker, animated: true, completion: nil)
    }
}
