//
//  UserViewModel.swift
//  Trough
//
//  Created by Irfan Malik on 21/12/2020.
//

import Foundation

class UserViewModel: Codable {
    var userId: Int?
    var isActive: Bool?
    var isAccountVerified : Bool?
    var truckId : Int?
    var roleId : Int?
    var role : String?
    var createdDate : String?
    var token : String?
    var email: String?
    var phone: String?
    var fullName: String?
    var profileUrl: String?
    var password: String?
    var address: String?
    var serviceCityName : String?
    
    init() {
    }
    
    enum UserViewModelKeys: String,CodingKey{
        case userId
        case isActive
        case isAccountVerified
        case truckId
        case roleId
        case role
        case createdDate
        case token
        case email
        case phone
        case fullName
        case profileUrl
        case password
        case address
        case serviceCityName

    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UserViewModelKeys.self)
        self.userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        self.isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        self.isAccountVerified = try values.decodeIfPresent(Bool.self, forKey: .isAccountVerified)
        self.truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        self.roleId = try values.decodeIfPresent(Int.self, forKey: .roleId)
        self.role = try values.decodeIfPresent(String.self, forKey: .role)
        self.createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        self.token = try values.decodeIfPresent(String.self, forKey: .token)
        self.email = try values.decodeIfPresent(String.self, forKey: .email)
        self.phone = try values.decodeIfPresent(String.self, forKey: .phone)
        self.profileUrl = try values.decodeIfPresent(String.self, forKey: .profileUrl)
        self.password = try values.decodeIfPresent(String.self, forKey: .password)
        self.fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        self.serviceCityName = try values.decodeIfPresent(String.self, forKey: .serviceCityName)
        
        // 3 - Conditional Decoding
        if let address =  try values.decodeIfPresent(String.self, forKey: .address) {
                    self.address = address
                }else {
                    self.address = ""
                }
    }
    
}

