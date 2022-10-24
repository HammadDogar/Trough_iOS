//
//  GetOrderByTruckResponseModel.swift
//  Trough
//
//  Created by Mateen Nawaz on 31/08/2022.
//

import Foundation
struct GetOrderByTruckResponseModel : Codable {
    let status : Int?
    let message : String?
    let data : [GetOrderByTruckModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([GetOrderByTruckModel].self, forKey: .data)
    }

}
