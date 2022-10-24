//
//  AddtoCartViewModel.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import Foundation
struct AddtoCartViewModel : Codable {
	let truckId : Int?
	let eventId : Int?
	let isConfirmToRemoveOtherCartItems : Bool?
	let cartDetails : [CartDetails]?

    init() {
        self.truckId = 0
        self.eventId = 0
        self.isConfirmToRemoveOtherCartItems = false
        self.cartDetails = [CartDetails]()
    }
    
    

	enum CodingKeys: String, CodingKey {

		case truckId = "truckId"
		case eventId = "eventId"
		case isConfirmToRemoveOtherCartItems = "isConfirmToRemoveOtherCartItems"
		case cartDetails = "cartDetails"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
		eventId = try values.decodeIfPresent(Int.self, forKey: .eventId)
		isConfirmToRemoveOtherCartItems = try values.decodeIfPresent(Bool.self, forKey: .isConfirmToRemoveOtherCartItems)
		cartDetails = try values.decodeIfPresent([CartDetails].self, forKey: .cartDetails)
	}
}
