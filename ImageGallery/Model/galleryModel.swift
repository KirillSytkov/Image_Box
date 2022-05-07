//
//  galleryModel.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 29.03.2022.
//

import Foundation
import UIKit

class GalleryModel {
    
    var imageObjectArray: [imageObject] = UserDefaults.standard.value([imageObject].self, forKey: keys.images) ?? []
    var firstTime = UserDefaults.standard.value(Bool.self, forKey: keys.firstEnter)
    var imageFavorites = [imageObject]()
    
    func reloadImageViewCenter( centerView: UIView ) {
        if !imageObjectArray.isEmpty {
            centerView.isHidden = true
        } else {
            centerView.isHidden = false
        }
    }
    
    func getFavorites() {
        for image in imageObjectArray {
            if image.favorite {
                imageFavorites.append(image)
            }
        }
    }
    func reloadCollectionImage(with collectionView: UICollectionView) {
        imageObjectArray = UserDefaults.standard.value([imageObject].self, forKey: keys.images) ?? []
        getFavorites()
        collectionView.reloadData()
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
