//
//  TruckMenuResponseViewModel.swift
//  Trough
//
//  Created by Macbook on 21/04/2021.
//

import UIKit


struct TruckMenuResponseViewModel : Codable {
    var status : Int?
    var message : String?
    var data : [TruckMenuViewModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([TruckMenuViewModel].self, forKey: .data)
    }

}

