//
//  FoodCategoriesViewModel.swift
//  Trough
//
//  Created by Irfan Malik on 05/01/2021.
//

import Foundation

// MARK: - FoodCatoriesResponseViewModel
class FoodCatoriesResponseViewModel: Codable {
    var status: Int?
    var message: String?
    var foodCategoriesList: [FoodCategoriesViewModel]?

    init(){}
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case foodCategoriesList = "data"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.foodCategoriesList = try values.decodeIfPresent([FoodCategoriesViewModel].self, forKey: .foodCategoriesList)
    }
}

