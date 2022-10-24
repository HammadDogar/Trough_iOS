//
//  GetCartDetails.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import Foundation
struct GetCartDetails : Codable {
	let id : Int?
	var imageUrl : String?
	let description : String?
	let title : String?
	let categoryId : Int?
	let quantity : Int?
	let price : Int?
        
    init() {
        self.id = 0
        self.imageUrl = ""
        self.description = ""
        self.title = ""
        self.categoryId = 0
        self.quantity = 0
        self.price = 0
    }
    
    
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
//		imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
		quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
		price = try values.decodeIfPresent(Int.self, forKey: .price)
        
        // 1 - Conditional Decoding
        if let imageUrl =  try values.decodeIfPresent(String.self, forKey: .imageUrl) {
                    self.imageUrl = imageUrl
                }else {
                    self.imageUrl = ""
                }
	}

}
