//
//  UIViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 18.01.2022.
//

import Foundation
import UIKit

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){

        if let image = info[.editedImage] as? UIImage {
            addImageObject(image)
        }  else if let image = info[.originalImage] as? UIImage {
            addImageObject(image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func addImageObject(_ image: UIImage) {
        if let imageString = ImageManager.shared.saveImage(image) {
            let newImageObject = imageObject(name: imageString, favorite: false, signature: "", date: Date())
            ImageManager.shared.addImageArray(newImageObject)
            GalleryModel.shared.updateImages()
        }
    }
    
}

