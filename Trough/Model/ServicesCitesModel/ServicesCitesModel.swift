//
//  ServicesCitesModel.swift
//  Trough
//
//  Created by Mateen Nawaz on 17/10/2022.
//

import Foundation
struct ServicesCitesModel : Codable {
    var servicesCityBulkId : Int = 0
    var name : String = ""
    var isActive : Bool = false

    enum CodingKeys: String, CodingKey {

        case servicesCityBulkId = "servicesCityBulkId"
        case name = "name"
        case isActive = "isActive"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        servicesCityBulkId = try values.decodeIfPresent(Int.self, forKey: .servicesCityBulkId) ?? 0
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
    }
    
    init() {
        
    }

}
