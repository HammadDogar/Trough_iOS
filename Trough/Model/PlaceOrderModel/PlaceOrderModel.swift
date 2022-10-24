//
//  PlaceOrderModel.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import Foundation
struct PlaceOrderModel : Codable {
	let isDeliveryRequired : Bool?
	let deliveryAddress : String?
	let instructions : String?
	let otherPhoneNumber : String?
	let deliveryCharges : Int?
	let isCOD : Bool?
	let paymentId : Int?
    let promoCode : String?
    
	enum CodingKeys: String, CodingKey {

		case isDeliveryRequired = "isDeliveryRequired"
		case deliveryAddress = "deliveryAddress"
		case instructions = "instructions"
		case otherPhoneNumber = "otherPhoneNumber"
		case deliveryCharges = "deliveryCharges"
		case isCOD = "isCOD"
		case paymentId = "paymentId"
        case promoCode = "promoCode"

	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		isDeliveryRequired = try values.decodeIfPresent(Bool.self, forKey: .isDeliveryRequired)
		deliveryAddress = try values.decodeIfPresent(String.self, forKey: .deliveryAddress)
		instructions = try values.decodeIfPresent(String.self, forKey: .instructions)
		otherPhoneNumber = try values.decodeIfPresent(String.self, forKey: .otherPhoneNumber)
		deliveryCharges = try values.decodeIfPresent(Int.self, forKey: .deliveryCharges)
		isCOD = try values.decodeIfPresent(Bool.self, forKey: .isCOD)
		paymentId = try values.decodeIfPresent(Int.self, forKey: .paymentId)
        promoCode = try values.decodeIfPresent(String.self, forKey: .promoCode)
	}

}
