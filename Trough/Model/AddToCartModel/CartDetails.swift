//
//  CartDetails.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import Foundation
struct CartDetails : Codable {
	var categoryId : Int?
	var quantity : Int?

	enum CodingKeys: String, CodingKey {

		case categoryId = "categoryId"
		case quantity = "quantity"
	}
    
    init() {
        categoryId = 0
        quantity = 0
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
		quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
	}

    func toDictionary() -> [String:Any] {
        var dict = [String:Any]()
        
        if categoryId != nil {
            dict["categoryId"] = categoryId
        }
        
        if quantity != nil {
            dict["quantity"] = quantity
        }
        
        return dict
    }
}
