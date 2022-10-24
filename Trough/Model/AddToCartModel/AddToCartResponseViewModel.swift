//
//  AddToCartResponseViewModel.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import Foundation


struct AddToCartResponseViewModel : Codable {
    var status : Int?
    var message : String?
    var data : [AddtoCartViewModel]?
    
    init() {
        
    }
    
    enum UserModelKeys: String,CodingKey{
        case message = "status"
        case status = "message"
        case data = "data"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([AddtoCartViewModel].self, forKey: .data)
    }

}
