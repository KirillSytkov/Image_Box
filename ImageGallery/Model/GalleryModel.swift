
import Foundation

class GalleryModel {
    
    var images = [imageObject]()
    var imageNoFavorites = [imageObject]()
    var imageFavorites = [imageObject]()
    
    static let shared = GalleryModel()
    private init() {}
    
    func updateImages() {
        images = ImageManager.shared.loadImageArray()
        getFavorites()
    }
    
    private func getFavorites() {
        imageFavorites.removeAll()
        imageNoFavorites.removeAll()
        for image in images {
            if image.favorite {
                imageFavorites.append(image)
            } else {
                imageNoFavorites.append(image)
            }
        }
    }
    
    func deleteImage(image: imageObject) {
        images = images.filter() { $0 != image }
        UserDefaults.standard.set(encodable: images, forKey: keys.images)
    }
    
}
