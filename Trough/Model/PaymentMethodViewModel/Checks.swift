//
//  Checks.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import Foundation
struct Checks : Codable {
    let addressLine1Check : String?
    let addressPostalCodeCheck : String?
    let cvcCheck : String?

    enum CodingKeys: String, CodingKey {

        case addressLine1Check = "addressLine1Check"
        case addressPostalCodeCheck = "addressPostalCodeCheck"
        case cvcCheck = "cvcCheck"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addressLine1Check = try values.decodeIfPresent(String.self, forKey: .addressLine1Check)
        addressPostalCodeCheck = try values.decodeIfPresent(String.self, forKey: .addressPostalCodeCheck)
        cvcCheck = try values.decodeIfPresent(String.self, forKey: .cvcCheck)
    }

}

