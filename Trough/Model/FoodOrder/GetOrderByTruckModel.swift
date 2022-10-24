//
//  GetOrderByTruckModel.swift
//  Trough
//
//  Created by Mateen Nawaz on 31/08/2022.
//


import Foundation
import SwiftUI

struct GetOrderByTruckModel : Codable {
    let userId : Int?
    let preOrderId : Int?
    let orderId : Int?
    let fullName : String?
    let profileUrl : String?
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
    let orderDetail : [GetOrderByTruckModelDetail]?
    let createdDate : String?
    let invoiceNumber : String?
    let isCompleted : Bool?
    let isReadyPickUp : Bool?

    init() {

        self.userId = Int()
        self.preOrderId = Int()
        self.orderId = Int()
        self.profileUrl = ""
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
        self.createdDate = String()
        self.invoiceNumber = String()
        self.isCompleted = Bool()
        self.isReadyPickUp = Bool()
    }

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case preOrderId = "preOrderId"
        case orderId = "orderId"
        case fullName = "fullName"
        case profileUrl = "bannerUrl"
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
        case invoiceNumber = "invoiceNumber"
        case createdDate = "createdDate"
        case isCompleted = "isCompleted"
        case isReadyPickUp = "isReadyPickUp"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        preOrderId = try values.decodeIfPresent(Int.self, forKey: .preOrderId)
        orderId = try values.decodeIfPresent(Int.self, forKey: .orderId)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        profileUrl = try values.decodeIfPresent(String.self, forKey: .profileUrl)
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
        
        invoiceNumber = try values.decodeIfPresent(String.self, forKey: .invoiceNumber)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        isCompleted = try values.decodeIfPresent(Bool.self, forKey: .isCompleted)
        isReadyPickUp = try values.decodeIfPresent(Bool.self, forKey: .isReadyPickUp)
        
        orderDetail = try values.decodeIfPresent([GetOrderByTruckModelDetail].self, forKey: .orderDetail)
        
    }

}
