//
//  ImageObject.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 19.01.2022.
//

import Foundation

class imageObject: Codable {
    
    var name: String
    var favorite: Bool
    var signature: String
    var date: Date
    
    init(name: String, favorite: Bool, signature: String, date: Date){
        self.name = name
        self.favorite = favorite
        self.signature = signature
        self.date = date
    }
    private enum CodingKeys: String, CodingKey {
        case name
        case favorite
        case signature
        case date
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(favorite, forKey: .favorite)
        try container.encode(signature, forKey: .signature)
        try container.encode(date, forKey: .date)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.favorite = try container.decode(Bool.self, forKey: .favorite)
        self.signature = try container.decode(String.self, forKey: .signature)
        self.date = try container.decode(Date.self, forKey: .date)
    }
}
