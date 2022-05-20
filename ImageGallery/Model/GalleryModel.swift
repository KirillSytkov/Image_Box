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
    var imageFavorites = [imageObject]()
    
    func updateImages() {
        imagesCollection = ImageManager.shared.loadImageArray()
        getFavorites()
    }
    
    private func getFavorites() {
        for image in imagesCollection {
            if image.favorite {
                imageFavorites.append(image)
            }
        }
    }
    
}
