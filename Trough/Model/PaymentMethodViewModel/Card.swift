//
//  Card.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import Foundation
struct Card : Codable {
    let brand : String?
    let checks : Checks?
    let country : String?
    let funding : String?
    let generatedFrom : String?
    let last4 : String?
    let networks : Networks?
    let threeDSecureUsage : ThreeDSecureUsage?

    enum CodingKeys: String, CodingKey {

        case brand = "brand"
        case checks = "checks"
        case country = "country"
        case funding = "funding"
        case generatedFrom = "generatedFrom"
        case last4 = "last4"
        case networks = "networks"
        case threeDSecureUsage = "threeDSecureUsage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        checks = try values.decodeIfPresent(Checks.self, forKey: .checks)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        funding = try values.decodeIfPresent(String.self, forKey: .funding)
        generatedFrom = try values.decodeIfPresent(String.self, forKey: .generatedFrom)
        last4 = try values.decodeIfPresent(String.self, forKey: .last4)
        networks = try values.decodeIfPresent(Networks.self, forKey: .networks)
        threeDSecureUsage = try values.decodeIfPresent(ThreeDSecureUsage.self, forKey: .threeDSecureUsage)
    }

}

