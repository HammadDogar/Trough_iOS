//
//  GetOrderByUserModel.swift
//  Trough
//
//  Created by Imed on 16/07/2021.
//

import Foundation
struct GetOrderByUserModel : Codable {
    let truckId : Int?
    let fullName : String?
    let bannerUrl : String?
    let eventId : Int?
    let eventName : String?
    let imageUrl : String?
    let isDeliveryRequired : Bool?
    let deliveryAddress : String?
    let instructions : String?
    let otherPhoneNumber : String?
    let deliveryCharges : Int?
    let isCOD : Bool?
    let totalAmount : Int?
    let orderDetail : [GetOrderByUserModelDetail]?

    init() {

        self.truckId = Int()
        self.bannerUrl = ""
        self.imageUrl = ""
        self.fullName = ""
        self.eventId = Int()
        self.eventName = ""
        self.isDeliveryRequired = Bool()
        self.deliveryAddress = ""
        self.instructions = ""
        self.otherPhoneNumber = ""
        self.deliveryCharges = Int()
        self.isCOD = Bool()
        self.totalAmount = Int()
//        self.orderDetail = [GetOrderByUserModelDetail]
        self.orderDetail = []
    }

    enum CodingKeys: String, CodingKey {

        case truckId = "truckId"
        case fullName = "fullName"
        case bannerUrl = "bannerUrl"
        case eventId = "eventId"
        case eventName = "eventName"
        case imageUrl = "imageUrl"
        case isDeliveryRequired = "isDeliveryRequired"
        case deliveryAddress = "deliveryAddress"
        case instructions = "instructions"
        case otherPhoneNumber = "otherPhoneNumber"
        case deliveryCharges = "deliveryCharges"
        case isCOD = "isCOD"
        case totalAmount = "totalAmount"
        case orderDetail = "orderDetail"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        bannerUrl = try values.decodeIfPresent(String.self, forKey: .bannerUrl)
        eventId = try values.decodeIfPresent(Int.self, forKey: .eventId)
        eventName = try values.decodeIfPresent(String.self, forKey: .eventName)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        isDeliveryRequired = try values.decodeIfPresent(Bool.self, forKey: .isDeliveryRequired)
        deliveryAddress = try values.decodeIfPresent(String.self, forKey: .deliveryAddress)
        instructions = try values.decodeIfPresent(String.self, forKey: .instructions)
        otherPhoneNumber = try values.decodeIfPresent(String.self, forKey: .otherPhoneNumber)
        deliveryCharges = try values.decodeIfPresent(Int.self, forKey: .deliveryCharges)
        isCOD = try values.decodeIfPresent(Bool.self, forKey: .isCOD)
        totalAmount = try values.decodeIfPresent(Int.self, forKey: .totalAmount)
        orderDetail = try values.decodeIfPresent([GetOrderByUserModelDetail].self, forKey: .orderDetail)
    }

}
