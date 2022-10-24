//
//  CategoriesViewModel.swift
//  Trough
//
//  Created by Imed on 04/10/2021.
//

import Foundation

struct CategoriesViewModel : Codable {
    let categoryId : Int?
    let name : String?
    let createdDate : String?
    var imageUrl : String?

    enum CodingKeys: String, CodingKey {

        case categoryId = "categoryId"
        case name = "name"
        case createdDate = "createdDate"
        case imageUrl = "imageUrl"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
//        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        if let imageUrl =  try values.decodeIfPresent(String.self, forKey: .imageUrl) {
                    self.imageUrl = imageUrl
                }else {
                    self.imageUrl = ""
                }
    }
}

