//
//  TermsResponseModel.swift
//  Trough
//
//  Created by Imed on 26/07/2021.
//

import Foundation
struct TermsResponseModel : Codable {
    let status : Int?
    let message : String?
    let data : [TermsViewModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([TermsViewModel].self, forKey: .data)
    }

}
