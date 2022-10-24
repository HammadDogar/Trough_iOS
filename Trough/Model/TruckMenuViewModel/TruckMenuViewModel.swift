//
//  TruckMenuViewModel.swift
//  Trough
//
//  Created by Macbook on 21/04/2021.
//

import Foundation

struct TruckMenuViewModel:Codable {
    var menuId:Int?
    var title: String?
    var truckId:Int?
    var createdDate:String?
    var isActive:Bool?
    var categories : [MenuCategoryViewModel]?
    
    enum CodingKeys: String, CodingKey {
        
        case menuId = "menuId"
        case title = "title"
        case truckId = "truckId"
        case createdDate = "createdDate"
        case isActive = "isActive"
        case categories = "categories"
        
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        menuId = try values.decodeIfPresent(Int.self, forKey: .menuId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        categories = try values.decodeIfPresent([MenuCategoryViewModel].self, forKey: .categories)
    }
}
