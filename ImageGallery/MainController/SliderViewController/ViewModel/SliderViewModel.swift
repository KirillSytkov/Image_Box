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
    var galleryModel = GalleryModel()
    var images =  [imageObject]()
    var imageIndex = 0
    var like = false
    
    //MARK: - flow func
    func loadController(_ textFieldImage: UITextField,_ navigationTitle:UINavigationItem) {
        if galleryModel.images.isEmpty {
            galleryModel.updateImages()
        }
        
        if !galleryModel.images.isEmpty {
            if imageIndex == 0 {
                imageIndex = galleryModel.images.count - 1
            }
            firstImageView.value = ImageManager.shared.loadImage(fileName: galleryModel.images[imageIndex].name)
            secondImageView.value = ImageManager.shared.loadImage(fileName: galleryModel.images[imageIndex].name)
            textFieldImage.isHidden = false
            signature.value = galleryModel.images[imageIndex].signature
            
            navigationTitle.setTitle(mainDateSelected(galleryModel.images[imageIndex]),
                                     subtitle: minutesDateSelect(galleryModel.images[imageIndex]))
            
            checkLike()
            hideAlert?()
        } else {
            textFieldImage.isHidden = true
            showAlert?()
        }
    }
    
    func checkLike() {
        like = galleryModel.images[imageIndex].favorite
        if like {
            isLike?()
        } else {
            noLike?()
        }
    }
    
    func loadFirstImage() -> Bool{
        if !galleryModel.images.isEmpty {
            firstImageView.value = ImageManager.shared.loadImage(fileName: galleryModel.images[imageIndex].name)
            return true
        }
        return false
    }
    
    func loadSecondImage() -> Bool {
        if !galleryModel.images.isEmpty {
            secondImageView.value = ImageManager.shared.loadImage(fileName: galleryModel.images[imageIndex].name)
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
        signature.value = galleryModel.images[imageIndex].signature
        navigationTitle.setTitle(mainDateSelected(galleryModel.images[imageIndex]), subtitle: minutesDateSelect(galleryModel.images[imageIndex]))
        checkLike()
        
    }
    func clearController() {
        imageIndex = 0
        galleryModel.images.removeAll()
    }
    
    //MARK: - Actions
    func singleTap(){
        if !galleryModel.images.isEmpty {
            hideFullScreen?()
        }
    }
    
    func doubleTap(_ fullScreen: ImageFullScreen) {
        if !galleryModel.images.isEmpty {
            fullScreen.imageZoom.image = firstImageView.value
            showFullScreen?()
        }
       
    }
    
    func swipeLeft() {
        if !galleryModel.images.isEmpty{
            galleryModel.images[imageIndex].signature = signature.value ?? ""
            if imageIndex <= (galleryModel.images.count - 1) && imageIndex > 0{
                imageIndex -= 1
            } else {
                imageIndex = galleryModel.images.count - 1
            }
        }
    }
    
    func swipeRight() {
        if !galleryModel.images.isEmpty{
            galleryModel.images[imageIndex].signature = signature.value ?? ""
            if imageIndex < (galleryModel.images.count - 1) {
                imageIndex += 1
            } else {
                imageIndex = 0
            }
        }
    }
    
    func textFieldEndEditing() {
        if !galleryModel.images.isEmpty{
            galleryModel.images[imageIndex].signature = signature.value ?? ""
            UserDefaults.standard.set(encodable: galleryModel.images, forKey: keys.images)
        }
    }
    
    func likeButtonPresed() {
        if !galleryModel.images.isEmpty {
            if !self.like {
                isLike?()
            } else {
                noLike?()
            }
            self.like = !like
            galleryModel.images[imageIndex].favorite = self.like
            UserDefaults.standard.set(encodable: galleryModel.images, forKey: keys.images)
        }
    }
    
    func trashButtonPressed() {
        if !galleryModel.images.isEmpty{
            showDeleteAlert?()
        }
    }
    
    func deleteButtonPressed(_ textFieldImage: UITextField,_ navigationTitle:UINavigationItem) {
        if !galleryModel.images.isEmpty {
            galleryModel.images.remove(at: imageIndex)
            if imageIndex != 0 {
                imageIndex -= 1
            }
            UserDefaults.standard.set(encodable: galleryModel.images, forKey: keys.images)
            if !galleryModel.images.isEmpty {
                checkLike()
                signature.value = galleryModel.images[imageIndex].signature
                secondImageView.value = ImageManager.shared.loadImage(fileName: galleryModel.images[imageIndex].name)
                firstImageView.value = ImageManager.shared.loadImage(fileName: galleryModel.images[imageIndex].name)
                navigationTitle.setTitle(mainDateSelected(galleryModel.images[imageIndex]), subtitle: minutesDateSelect(galleryModel.images[imageIndex]))
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
