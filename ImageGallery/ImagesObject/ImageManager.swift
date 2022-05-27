
import Foundation
import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    private init() {}
    
    func saveImage( _ image: UIImage) -> String? {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = UUID().uuidString
        
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName),
              let imageDate = image.jpegData(compressionQuality: 1 ) else { return nil }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        do {
            try imageDate.write(to: fileURL)
            return fileName
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image 
    }
    
    func addImageArray(_ image: imageObject){
        var images = self.loadImageArray()
        images.append(image)
        UserDefaults.standard.set(encodable: images, forKey: keys.images)
    }
    
    func loadImageArray() -> [imageObject] {
        guard let results = UserDefaults.standard.value([imageObject].self, forKey: keys.images) else {
            return []
        }
        return results
    }
    
    func deleteImage(imageArray: [imageObject], imageIndex: Int ) {
        var images = imageArray
        images.remove(at: imageIndex)
        UserDefaults.standard.set(encodable: images, forKey: keys.images)
    }
    
}
