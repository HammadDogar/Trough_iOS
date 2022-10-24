//
//  MenucategoryViewModel.swift
//  Trough
//
//  Created by Macbook on 21/04/2021.
//

import Foundation

struct MenuCategoryViewModel:Codable {
    var title:String?
    var description: String?
    var imageUrl:String?
    var menuId:Int?
    var categoryId:Int?
    var typeId:Int?
    var price:Int?
//    var isActive: Bool?
//    var createdDate:String?
//    var createdById:Int?
//    var productDetails:String?
//
//
    init() {
    }
    
    enum CodingKeys: String, CodingKey {
//
        case title = "title"
        case description = "description"
        case imageUrl = "imageUrl"
        case menuId = "menuId"
        case categoryId = "categoryId"
        case typeId = "typeId"
        case price = "price"
//        case isActive = "isActive"
//        case createdDate = "createdDate"
//        case createdById = "createdById"
//        case productDetails = "productDetails"
//
//
//
    }
//
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        menuId = try values.decodeIfPresent(Int.self, forKey: .menuId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
//        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
//        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
//        productDetails = try values.decodeIfPresent(String.self, forKey: .productDetails)
//        createdById = try values.decodeIfPresent(Int.self, forKey: .createdById)
        typeId = try values.decodeIfPresent(Int.self, forKey: .typeId)
        categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
//
    }
}

