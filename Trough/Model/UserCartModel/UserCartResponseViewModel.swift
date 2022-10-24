//
//  UserCartResponseViewModel.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//


import Foundation
struct UserCartResponseViewModel : Codable {
    var status : Int?
    var message : String?
    var data : GetUserCartViewModel?

    enum UserModelKeys: String,CodingKey{
        case message
        case status
        case cartDetails
    }
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(GetUserCartViewModel.self, forKey: .data)
	}

}
