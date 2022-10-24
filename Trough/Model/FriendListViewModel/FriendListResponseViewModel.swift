//
//  FriendListResponseViewModel.swift
//  Trough
//
//  Created by Macbook on 09/04/2021.
//

import UIKit


struct FriendListResponseViewModel : Codable {
    var status : Int?
    var message : String?
    var friendList : [FriendListViewModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case friendList = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        friendList = try values.decodeIfPresent([FriendListViewModel].self, forKey: .friendList)
    }

}

