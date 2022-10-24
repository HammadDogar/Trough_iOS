//
//  PaymentmethodListViewModel.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import Foundation
class PaymentMethodListViewModel : Codable {
    var status : Int?
    var message : String?
    var data : [PaymentMethodViewModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }
    init(){}

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([PaymentMethodViewModel].self, forKey: .data)
    }

}
