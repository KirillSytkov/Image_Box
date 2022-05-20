//
//  FavoritesViewModel.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 18.05.2022.
//

import Foundation
import UIKit

class FavoritesViewModel {
    
    var reloadCollectionView: (()->())?
    var showAlert: (()->())?
    var hiddenError:(()->())?
    var galleryModel = GalleryModel()
    
    private var cellViewModels: [ImageCollectionCellViewModel] = [ImageCollectionCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> ImageCollectionCellViewModel {
        return cellViewModels[indexPath.item]
    }
    
    private func createCell(images: [imageObject]){
        var viewModelCell = [ImageCollectionCellViewModel]()
        for image in images {
            viewModelCell.append(ImageCollectionCellViewModel(imageName: image.name))
        }
        
        cellViewModels = viewModelCell
    }
    
    func updateFavoritesCollection() {
        galleryModel.updateImages()
        if galleryModel.imageFavorites.isEmpty {
            showAlert?()
        } else {
            hiddenError?()
            createCell(images: galleryModel.imageFavorites)
        }
    }
    
    func infoButtonPressed() {
        showAlert?()
    }
    
    func clearGallery() {
        galleryModel.imageFavorites.removeAll()
    }
}
