//
//  GetUserCartViewModel.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import Foundation
struct GetUserCartViewModel : Codable {
    var truckId : Int = -1
	let fullName : String?
	let bannerUrl : String?
	let eventId : Int?
	let eventName : String?
    var imageUrl = ""
	let totalAmount : Int?
	let cartDetails : [GetCartDetails]?    
    
	enum CodingKeys: String, CodingKey {

		case truckId = "truckId"
		case fullName = "fullName"
		case bannerUrl = "bannerUrl"
		case eventId = "eventId"
		case eventName = "eventName"
		case imageUrl = "imageUrl"
		case totalAmount = "totalAmount"
		case cartDetails = "cartDetails"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)!
		fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
		bannerUrl = try values.decodeIfPresent(String.self, forKey: .bannerUrl)
		eventId = try values.decodeIfPresent(Int.self, forKey: .eventId)
		eventName = try values.decodeIfPresent(String.self, forKey: .eventName)
//        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
		totalAmount = try values.decodeIfPresent(Int.self, forKey: .totalAmount)
        cartDetails = try values.decodeIfPresent([GetCartDetails].self, forKey: .cartDetails)
        
        // 1 - Conditional Decoding
        if let imageUrl =  try values.decodeIfPresent(String.self, forKey: .imageUrl) {
                    self.imageUrl = imageUrl
                }else {
                    self.imageUrl = ""
                }
	}

}
