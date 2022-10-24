//
//  PlaceOrderResponseModel.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import Foundation

class PlaceOrderResponseModel: Codable {
    var status : Int?
    var message : String?
    var data : PlaceOrderModel?
    
    init() {
        
    }
    
    enum UserModelKeys: String,CodingKey{
        case message
        case status
        case data
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UserModelKeys.self)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.data = try values.decodeIfPresent(PlaceOrderModel.self, forKey: .data)
    }
}
