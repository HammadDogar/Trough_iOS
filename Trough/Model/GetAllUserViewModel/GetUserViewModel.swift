//
//  GetUserViewModel.swift
//  Trough
//
//  Created by Macbook on 31/03/2021.
//

import Foundation


struct GetUserViewModel : Codable {
    
    var userId : Int?
    var fullName : String?
    var email : String?
    var phone : String = ""
    var profileUrl : String = ""
    var about: String = ""
    
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case fullName = "fullName"
        case email = "email"
        case phone = "phone"
        case profileUrl = "profileUrl"
        case about = "about"
    }

    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try values.decode(Int.self, forKey: .userId)
        self.fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        self.email = try values.decode(String.self, forKey: .email)
        
        // 3 - Conditional Decoding
        if let phone =  try values.decodeIfPresent(String.self, forKey: .phone) {
                    self.phone = phone
                }else {
                    self.phone = ""
                }
        if let profileUrl =  try values.decodeIfPresent(String.self, forKey: .profileUrl) {
                    self.profileUrl = profileUrl
                }else {
                    self.profileUrl = ""
                }
        if let about =  try values.decodeIfPresent(String.self, forKey: .about) {
                    self.about = about
                }else {
                    self.about = ""
                }
    }

}
