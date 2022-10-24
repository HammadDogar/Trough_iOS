//
//  ComingPeopleResponseModel.swift
//  Trough
//
//  Created by Mateen Nawaz on 02/09/2022.
//


import Foundation

struct ComingPeopleResponseModel : Codable {
    let status : Int?
    let message : String?
    let data : [ComingPeopleModel]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.data = try values.decodeIfPresent([ComingPeopleModel].self, forKey: .data)
    }
}
