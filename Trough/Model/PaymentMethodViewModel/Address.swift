//
//  Address.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import Foundation
struct Address : Codable {
    let city : String?
    let country : String?
    let line1 : String?
    let line2 : String?
    let postalCode : String?
    let state : String?

    enum CodingKeys: String, CodingKey {

        case city = "city"
        case country = "country"
        case line1 = "line1"
        case line2 = "line2"
        case postalCode = "postalCode"
        case state = "state"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        line1 = try values.decodeIfPresent(String.self, forKey: .line1)
        line2 = try values.decodeIfPresent(String.self, forKey: .line2)
        postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
        state = try values.decodeIfPresent(String.self, forKey: .state)
    }

}

