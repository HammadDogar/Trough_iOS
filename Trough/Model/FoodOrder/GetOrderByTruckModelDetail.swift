//
//  GetOrderByTruckModelDetail.swift
//  Trough
//
//  Created by Mateen Nawaz on 31/08/2022.
//


import Foundation
struct GetOrderByTruckModelDetail : Codable {
    let id : Int?
    let imageUrl : String?
    let description : String?
    let title : String?
    let categoryId : Int?
    let quantity : Int?
    let price : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case imageUrl = "imageUrl"
        case description = "description"
        case title = "title"
        case categoryId = "categoryId"
        case quantity = "quantity"
        case price = "price"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
    }

}
