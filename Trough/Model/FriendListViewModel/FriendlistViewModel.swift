//
//  FriendlistViewModel.swift
//  Trough
//
//  Created by Macbook on 09/04/2021.
//

import Foundation


struct FriendListViewModel : Codable {
    
    var userId : Int?
    var fullName : String?
//    var phone : String?
    var profileUrl : String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case fullName = "fullName"
//        case phone = "phone"
        case profileUrl = "profileUrl"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try values.decode(Int.self, forKey: .userId)
        self.fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
//        self.phone = try values.decode(String.self, forKey: .phone)
        
        
        // 3 - Conditional Decoding
        if let profileUrl =  try values.decodeIfPresent(String.self, forKey: .profileUrl) {
                    self.profileUrl = profileUrl
                }else {
                    self.profileUrl = ""
                }
    }

}

