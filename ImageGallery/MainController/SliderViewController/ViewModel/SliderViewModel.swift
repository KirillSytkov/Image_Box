//
//  SliderViewModel.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 20.05.2022.
//

import Foundation
import UIKit

class SliderViewModel {
    
    var firstImageView = Bindable<UIImage?>(nil)
    var secondImageView = Bindable<UIImage?>(nil)
    var likeButton = Bindable<UIBarButtonItem?>(nil)
    var signature = Bindable<String?>(nil)
    
    var showAlert: (()->())?
    var hideAlert: (()->())?
    var showDeleteAlert: (()->())?
    var hideDeleteAlert: (()->())?
    var isLike: (()->())?
    var noLike: (()->())?
    var showFullScreen: (()->())?
    var hideFullScreen: (()->())?
    
    //MARK: - vars/lets
    var galleryModel = GalleryModel.shared
    var images = [imageObject]()
    lazy var imageIndex = GalleryModel.shared.images.count - 1
    var like = false
    
    //MARK: - flow func
    func loadController(_ textFieldImage: UITextField,_ navigationTitle:UINavigationItem) {
        if images.isEmpty {
            images = galleryModel.images
            galleryModel.updateImages()
        }

        if !images.isEmpty {
            firstImageView.value = ImageManager.shared.loadImage(fileName: images[imageIndex].name)
            secondImageView.value = ImageManager.shared.loadImage(fileName: images[imageIndex].name)
            textFieldImage.isHidden = false
            signature.value = images[imageIndex].signature
            
            navigationTitle.setTitle(mainDateSelected(images[imageIndex]),
                                     subtitle: minutesDateSelect(images[imageIndex]))
            
            checkLike()
            hideAlert?()
        } else {
            textFieldImage.isHidden = true
            showAlert?()
        }
    }
    
    func checkLike() {
        like = images[imageIndex].favorite
        if like {
            isLike?()
        } else {
            noLike?()
        }
    }
    
    func loadFirstImage() -> Bool{
        if !images.isEmpty {
            firstImageView.value = ImageManager.shared.loadImage(fileName: images[imageIndex].name)
            return true
        }
        return false
    }
    
    func loadSecondImage() -> Bool {
        if !images.isEmpty {
            secondImageView.value = ImageManager.shared.loadImage(fileName: images[imageIndex].name)
            return true
        }
        return false
    }
    
    func mainDateSelected(_ sender: imageObject) -> String {
        let date = sender.date
        let formater = DateFormatter()
        formater.dateFormat = "d MMMM yyyy"
        return  formater.string(from: date)
    }

    func minutesDateSelect(_ sender: imageObject) -> String {
        let date = sender.date
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm"
        return  formater.string(from: date)
    }
    
     func updateScrollView(_ navigationTitle: UINavigationItem) {
        signature.value = images[imageIndex].signature
        navigationTitle.setTitle(mainDateSelected(images[imageIndex]), subtitle: minutesDateSelect(images[imageIndex]))
        checkLike()
        
    }
    
    func clearController() {
        imageIndex = 0
        images.removeAll()
    }
    
    //MARK: - Actions
    func singleTap(){
        if !images.isEmpty {
            hideFullScreen?()
        }
    }
    
    func doubleTap(_ fullScreen: ImageFullScreen) {
        if !images.isEmpty {
            fullScreen.imageZoom.image = firstImageView.value
            showFullScreen?()
        }
       
    }
    
    func swipeLeft() {
        if !images.isEmpty{
            images[imageIndex].signature = signature.value ?? ""
            if imageIndex <= (images.count - 1) && imageIndex > 0{
                imageIndex -= 1
            } else {
                imageIndex = images.count - 1
            }
        }
    }
    
    func swipeRight() {
        if !images.isEmpty{
            images[imageIndex].signature = signature.value ?? ""
            if imageIndex < (images.count - 1) {
                imageIndex += 1
            } else {
                imageIndex = 0
            }
        }
    }
    
    func textFieldEndEditing(textField: UITextField) {
        if !images.isEmpty{
            signature.value = textField.text
            images[imageIndex].signature = signature.value ?? ""
            UserDefaults.standard.set(encodable: images, forKey: keys.images)
        }
    }
    
    func likeButtonPresed() {
        if !images.isEmpty {
            if !self.like {
                isLike?()
            } else {
                noLike?()
            }
            self.like = !like
            images[imageIndex].favorite = self.like
            UserDefaults.standard.set(encodable: images, forKey: keys.images)
        }
    }
    
    func trashButtonPressed() {
        if !images.isEmpty{
            showDeleteAlert?()
        }
    }
    
    func deleteButtonPressed(_ textFieldImage: UITextField,_ navigationTitle:UINavigationItem) {
        if !images.isEmpty {
            galleryModel.deleteImage(image: images[imageIndex])
            images.remove(at: imageIndex)
            if imageIndex != 0 {
                imageIndex -= 1
            }
            if !images.isEmpty {
                checkLike()
                signature.value = images[imageIndex].signature
                secondImageView.value = ImageManager.shared.loadImage(fileName: images[imageIndex].name)
                firstImageView.value = ImageManager.shared.loadImage(fileName: images[imageIndex].name)
                navigationTitle.setTitle(mainDateSelected(images[imageIndex]), subtitle: minutesDateSelect(images[imageIndex]))
            } else {
                like = false
                signature.value = ""
                textFieldImage.isHidden = true
                like = false
                noLike?()
                secondImageView.value = nil
                firstImageView.value = nil
                navigationTitle.setTitle("Слайдер", subtitle: "")
                showAlert?()
            }
        }
        hideDeleteAlert?()
    }
    
}
