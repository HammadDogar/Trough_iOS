//
//  favouriteLocationViewModel.swift
//  Trough
//
//  Created by Macbook on 13/04/2021.
//

import Foundation


struct favouriteLocationViewModel : Codable {
    
    var id : Int?
    var title : String?
    var userId : Int?
    var longitude : Double?
    var latitude : Double?
    var addres: String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case userId = "userId"
        case longitude = "longitude"
        case latitude = "latitude"
        case addres = "addres"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.title = try values.decodeIfPresent(String.self, forKey: .title)
        self.userId = try values.decode(Int.self, forKey: .userId)
        self.longitude = try values.decode(Double.self, forKey: .longitude)
        self.latitude = try values.decode(Double.self, forKey: .latitude)
        
        if let addres =  try values.decodeIfPresent(String.self, forKey: .addres) {
                    self.addres = addres
                }else {
                    self.addres = ""
                }
        
        
        
    }

}
