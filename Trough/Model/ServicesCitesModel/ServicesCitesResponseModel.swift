//
//  ServicesCitesResponseModel.swift
//  Trough
//
//  Created by Mateen Nawaz on 17/10/2022.
//


import Foundation
struct ServicesCitesResponseModel : Codable {
    let status : Int?
    let message : String?
    let data : [ServicesCitesModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([ServicesCitesModel].self, forKey: .data)
    }

}
