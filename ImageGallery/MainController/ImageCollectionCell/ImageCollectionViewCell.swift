//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 09.02.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewCell: UIImageView!
    
    func configure(image: String) {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.imageViewCell.image = ImageManager.shared.loadImage(fileName: image)
    }
    
}
