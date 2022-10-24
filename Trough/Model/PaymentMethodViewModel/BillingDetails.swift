//
//  BillingDetails.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import Foundation
struct BillingDetails : Codable {
    let address : Address?
    let email : String?
    let name : String?
    let phone : String?

    enum CodingKeys: String, CodingKey {

        case address = "address"
        case email = "email"
        case name = "name"
        case phone = "phone"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(Address.self, forKey: .address)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
    }

}

