//
//  FoodCategoriesViewModel.swift
//  Trough
//
//  Created by Irfan Malik on 05/01/2021.
//

import Foundation

// MARK: - FoodCategoriesViewModel
class FoodCategoriesViewModel: Codable {
    var categoryID: Int?
    var title: String?

    init(){}
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case title
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.categoryID = try values.decodeIfPresent(Int.self, forKey: .categoryID)
        self.title = try values.decodeIfPresent(String.self, forKey: .title)

    }
}
