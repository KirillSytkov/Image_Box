//
//  galleryModel.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 29.03.2022.
//

import Foundation
import UIKit

class GalleryModel {
    
    var images = [imageObject]()
    var imageFavorites = [imageObject]()
    
    func updateImages() {
        images = ImageManager.shared.loadImageArray()
        getFavorites()
    }
    
    private func getFavorites() {
        for image in images {
            if image.favorite {
                imageFavorites.append(image)
            }
        }
    }
    
}
