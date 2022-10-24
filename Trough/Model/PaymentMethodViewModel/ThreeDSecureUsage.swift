//
//  ThreeDSecureUsage.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import Foundation
struct ThreeDSecureUsage : Codable {
    let supported : Bool?

    enum CodingKeys: String, CodingKey {

        case supported = "supported"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        supported = try values.decodeIfPresent(Bool.self, forKey: .supported)
    }

}

