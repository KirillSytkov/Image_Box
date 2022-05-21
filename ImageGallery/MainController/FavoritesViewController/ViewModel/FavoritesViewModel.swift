//
//  FavoritesViewModel.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 18.05.2022.
//

import Foundation
import UIKit

class FavoritesViewModel {
    //MARK: - vars/lets
    var reloadCollectionView: (()->())?
    var showCenterView: (()->())?
    var hideCenterView:(()->())?
    var showAlert: (()->())?
    private var galleryModel = GalleryModel()
    private var firstStart = UserDefaults.standard.value(Bool.self, forKey: keys.favoriteStart)
    
    private var cellViewModels: [ImageCollectionCellViewModel] = [ImageCollectionCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    //MARK: - flow func
    func loadController() {
        if firstStart ?? true {
            showAlert?()
            firstStart = false
            UserDefaults.standard.set(encodable: firstStart, forKey: keys.favoriteStart)
        }
        updateFavoritesCollection()
    }
    
    private func updateFavoritesCollection() {
        galleryModel.updateImages()
        if galleryModel.imageFavorites.isEmpty {
            showCenterView?()
        } else {
            hideCenterView?()
        }
        createCell(images: galleryModel.imageFavorites)
    }
    
    private func createCell(images: [imageObject]){
        var viewModelCell = [ImageCollectionCellViewModel]()
        for image in images {
            viewModelCell.append(ImageCollectionCellViewModel(imageName: image.name))
        }
        
        cellViewModels = viewModelCell
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> ImageCollectionCellViewModel {
        return cellViewModels[indexPath.item]
    }
 
    func clearGallery() {
        galleryModel.imageFavorites.removeAll()
    }
    
    func getFavoritesSlider() -> [imageObject]{
        return galleryModel.imageFavorites
    }
    
    //MARK: - Actions
    func infoButtonPressed() {
        showAlert?()
    }
    
}
