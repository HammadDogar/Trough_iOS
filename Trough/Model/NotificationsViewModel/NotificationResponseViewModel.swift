//
//  NotificationResponseViewModel.swift
//  Trough
//
//  Created by Imed on 11/02/2021.
//

import UIKit


struct NotificationResponseViewModel : Codable {
    var status : Int?
    var message : String?
    var notificationsList : [NotificationViewModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case notificationsList = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        notificationsList = try values.decodeIfPresent([NotificationViewModel].self, forKey: .notificationsList)
    }

}
