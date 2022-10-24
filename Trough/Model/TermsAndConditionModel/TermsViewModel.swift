//
//  TermsViewModel.swift
//  Trough
//
//  Created by Imed on 26/07/2021.
//

import Foundation
struct TermsViewModel : Codable {
    let privacyId : Int?
    let privacyText : String?
    let status : Bool?
    let createdDate : String?
    let type : String?

    enum CodingKeys: String, CodingKey {

        case privacyId = "privacyId"
        case privacyText = "privacyText"
        case status = "status"
        case createdDate = "createdDate"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        privacyId = try values.decodeIfPresent(Int.self, forKey: .privacyId)
        privacyText = try values.decodeIfPresent(String.self, forKey: .privacyText)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }

}
