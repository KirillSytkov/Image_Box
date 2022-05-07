//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 09.02.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewCell: UIImageView!
    
    func configure(with image: imageObject) {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.imageViewCell.image = Manager.shared.loadImage(fileName: image.name)
    }
    

}
