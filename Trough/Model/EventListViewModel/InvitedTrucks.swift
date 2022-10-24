//
//  InvitedTrucks.swift
//  Trough
//
//  Created by Imed on 22/06/2021.
//

import Foundation
struct InvitedTrucks : Codable {
    var truckId : Int?
    let name : String?
    let bannerUrl : String?
    let address : String?
    
    let description : String?
    let liveLatitude : Int?
    let liveLongitude : Int?
    let permanentLatitude : Int?
    let permanentLongitude : Int?
    let workHours : String?

    enum CodingKeys: String, CodingKey {

        case truckId = "truckId"
        case name = "name"
        case bannerUrl = "bannerUrl"
        case address = "address"
        
        case description = "description"
        case liveLatitude = "liveLatitude"
        case liveLongitude = "liveLongitude"
        case permanentLatitude = "permanentLatitude"
        case permanentLongitude = "permanentLongitude"
        case workHours = "workHours"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        bannerUrl = try values.decodeIfPresent(String.self, forKey: .bannerUrl)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        liveLatitude = try values.decodeIfPresent(Int.self, forKey: .liveLatitude)
        liveLongitude = try values.decodeIfPresent(Int.self, forKey: .liveLongitude)
        permanentLatitude = try values.decodeIfPresent(Int.self, forKey: .permanentLatitude)
        permanentLongitude = try values.decodeIfPresent(Int.self, forKey: .permanentLongitude)
        workHours = try values.decodeIfPresent(String.self, forKey: .workHours)
    }

}
