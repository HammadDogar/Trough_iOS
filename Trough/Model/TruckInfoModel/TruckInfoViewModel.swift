//
//  TruckInfoViewModel.swift
//  Trough
//
//  Created by Imed on 01/07/2021.
//

import Foundation

struct TruckInfoViewModel : Codable {
    var truckId : Int?
    var name : String?
    var description : String?
    var bannerUrl : String?
    var permanentLatitude : Double?
    var permanentLongitude : Double?
    var address : String?
    var workHours : [WorkHours]?
    
       enum CodingKeys: String, CodingKey {

           case truckId = "truckId"
           case name = "name"
           case description = "description"
           case bannerUrl = "bannerUrl"
           case permanentLatitude = "permanentLatitude"
           case permanentLongitude = "permanentLongitude"
           case address = "address"
           case workHours = "workHours"
       }
    init() {}

    init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: CodingKeys.self)
           truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
           name = try values.decodeIfPresent(String.self, forKey: .name)
           description = try values.decodeIfPresent(String.self, forKey: .description)
           bannerUrl = try values.decodeIfPresent(String.self, forKey: .bannerUrl)
           permanentLatitude = try values.decodeIfPresent(Double.self, forKey: .permanentLatitude)
           permanentLongitude = try values.decodeIfPresent(Double.self, forKey: .permanentLongitude)
           address = try values.decodeIfPresent(String.self, forKey: .address)
           workHours = try values.decodeIfPresent([WorkHours].self, forKey: .workHours)
       }
}
