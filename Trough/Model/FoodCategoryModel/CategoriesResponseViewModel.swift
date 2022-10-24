//
//  CategoriesResponseViewModel.swift
//  Trough
//
//  Created by Imed on 04/10/2021.
//


import Foundation

struct CategoriesResponseViewModel : Codable {
    let status : Int?
    let message : String?
    let data : [CategoriesViewModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([CategoriesViewModel].self, forKey: .data)
    }

}
