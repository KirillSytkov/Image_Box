//
//  Manager.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 19.01.2022.
//

import Foundation
import UIKit

class Manager {
    
    static let shared = Manager()
    private init() {}
    
    func saveImage( _ image: UIImage) -> String? {
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first // получили имя папки, куда будем писать файл
            let fileName = UUID().uuidString // создали уникальное имя файла
            
             guard let fileURL = documentsDirectory?.appendingPathComponent(fileName), // добавили имя файла к имени папки
                   let imageDate = image.jpegData(compressionQuality: 1 ) else { return nil } // превратили image в 001010101010 (Data)
            
            if FileManager.default.fileExists(atPath: fileURL.path) { // проверяет наличие файла с таким же имененм true или false
                do { // изолируем кусок кода который может крашнуть приложение
                    try FileManager.default.removeItem(atPath: fileURL.path) // пытаемся удалить его
                } catch let error { // или ловим ошибку
                    print(error.localizedDescription) // и распечатываем ее
                    return nil // тк все пошло не так - сохранение не удалось, уходим
                }
            }
                do {
                    try imageDate.write(to: fileURL) // пытаемся сохранить  101010101001010 в путь куда хочу записать файл
                    return fileName // сохранение удалось - возвращаем имя файла для дальшнейшей работы
                } catch let error { // или ловим ошибку
                    print(error.localizedDescription) // распечатываем еще
                    return nil // тк все пошло не так - сохранение не удалось, уходим
                }
            }
        
        func loadImage(fileName: String) -> UIImage? {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // получили имя папки , где должен лежать файл
                  let fileURL = documentsDirectory.appendingPathComponent(fileName) // добавили имя файла к имени папки
                    let image = UIImage(contentsOfFile: fileURL.path) // прочитали файл, превратив его в UIimage
            return image // вернули картинку
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
        
}
