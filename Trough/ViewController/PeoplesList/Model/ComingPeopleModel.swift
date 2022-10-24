//
//  ComingPeopleModel.swift
//  Trough
//
//  Created by Mateen Nawaz on 02/09/2022.
//

import Foundation
struct ComingPeopleModel : Codable {
    let eventId : Int?
    let userName : String?
    let fullName : String?
    let profilePicture : String?
    let accepted : Bool?
    let rejected : Bool?
    let pending : Bool?

    enum CodingKeys: String, CodingKey {

        case eventId = "eventId"
        case userName = "userName"
        case fullName = "fullName"
        case profilePicture = "profilePicture"
        case accepted = "accepted"
        case rejected = "rejected"
        case pending = "pending"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        eventId = try values.decodeIfPresent(Int.self, forKey: .eventId)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        profilePicture = try values.decodeIfPresent(String.self, forKey: .profilePicture)
        accepted = try values.decodeIfPresent(Bool.self, forKey: .accepted)
        rejected = try values.decodeIfPresent(Bool.self, forKey: .rejected)
        pending = try values.decodeIfPresent(Bool.self, forKey: .pending)
    }

}
