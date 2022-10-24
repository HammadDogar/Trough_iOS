//
//  NotificationsViewModel.swift
//  Trough
//
//  Created by Irfan Malik on 03/02/2021.
//

import Foundation


struct NotificationViewModel : Codable {
    
    var notificationId : Int?
    var notificationTitle : String?
    var notificationBody : String?
    var createdDate : String?
    var type : String?
    var isRead : Bool?
    let redirectionId : Int?
    let orderId : Int?
    let preOrderId : Int?
    let isFriendRequest : Bool?
    let isReadyPickUp : Bool?
    
    enum CodingKeys: String, CodingKey {
        case notificationId = "notificationId"
        case notificationTitle = "title"
        case notificationBody = "body"
        case createdDate = "createdDate"
        case type = "type"
        case isRead = "isRead"
        case redirectionId = "redirectionId"
        case orderId = "orderId"
        case preOrderId = "preOrderId"
        case isFriendRequest = "isFriendRequest"
        case isReadyPickUp = "isReadyPickUp"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.notificationId = try values.decode(Int.self, forKey: .notificationId)
        self.notificationBody = try values.decodeIfPresent(String.self, forKey: .notificationBody)
        self.notificationTitle = try values.decode(String.self, forKey: .notificationTitle)
        self.createdDate = try values.decode(String.self, forKey: .createdDate)
        self.isRead = try values.decode(Bool.self, forKey: .isRead)
        self.type = try values.decode(String.self, forKey: .type)
        self.redirectionId = try values.decodeIfPresent(Int.self, forKey: .redirectionId)
        self.orderId = try values.decodeIfPresent(Int.self, forKey: .orderId)
        self.preOrderId = try values.decodeIfPresent(Int.self, forKey: .preOrderId)
        self.isReadyPickUp =  try values.decodeIfPresent(Bool.self, forKey: .isReadyPickUp)
        self.isFriendRequest =  try values.decodeIfPresent(Bool.self, forKey: .isFriendRequest)
    }
}
