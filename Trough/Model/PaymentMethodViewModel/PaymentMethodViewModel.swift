//
//  PaymentMethodViewModel.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import Foundation
class PaymentMethodViewModel : Codable {
    var object : String?
    var billingDetails : BillingDetails?
    var card : Card?
    var created : Int?
    var type : String?
    var paymentId : Int?


    enum CodingKeys: String, CodingKey {

        case object = "object"
        case billingDetails = "billingDetails"
        case card = "card"
        case created = "created"
        case type = "type"
        case paymentId = "paymentId"

    }
    init(){}

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        billingDetails = try values.decodeIfPresent(BillingDetails.self, forKey: .billingDetails)
        card = try values.decodeIfPresent(Card.self, forKey: .card)
        created = try values.decodeIfPresent(Int.self, forKey: .created)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        paymentId = try values.decodeIfPresent(Int.self, forKey: .paymentId)
    }

}
