//
//  UserViewModel.swift
//  Trough
//
//  Created by Irfan Malik on 22/12/2020.
//

import Foundation
import UIKit

struct EventViewModel : Codable {
	var eventId : Int?
	var eventName : String?
	var description : String?
	var imageUrl : String?
	var locationName : String?
	var address : String?
	var type : String?
	var createdDate : String?
	var createdById : Int?
	var fullName : String?
	var commentCount : Int?
    var profileUrl : String?
	var likeCount : Int?
	var isLiked : Bool?
    var isMaybe:Bool?
    var isGoing: Bool?
	var eventSlots : [EventSlots]?
    var truckIds : String?
    var isInviting : Bool?
    
    var peopleComing : Int?

    
    var invitedTrucks : [InvitedTrucks]?
    
    
    var imageFile = UIImage()
    var eventType = ""
    var Latitude = 0.0
    var Longitude = 0.0
    var UsersInEvents = [25,26]
    
    var latitude: Double?
    var longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        
		case eventId = "eventId"
		case eventName = "eventName"
		case description = "description"
		case imageUrl = "imageUrl"
		case locationName = "locationName"
		case address = "address"
		case type = "type"
		case createdDate = "createdDate"
		case createdById = "createdById"
		case fullName = "fullName"
		case commentCount = "commentCount"
		case likeCount = "likeCount"
		case isLiked = "isLiked"
		case eventSlots = "eventSlots"
        case profileUrl = "profileUrl"
        case isMaybe = "isMaybe"
        case isGoing = "isGoing"
        case truckIds = "truckIds"
        case isInviting = "isInviting"
       
        case invitedTrucks = "invitedTrucks"
        
        case peopleComing

        
        case longitude
        case latitude
	}
    init() {
        
        self.imageFile = UIImage()
        self.eventType = ""
        self.Latitude = 0.0
        self.Longitude = 0.0
        self.UsersInEvents = [25,26]
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        self.eventId = try values.decodeIfPresent(Int.self, forKey: .eventId)
        self.eventName = try values.decodeIfPresent(String.self, forKey: .eventName)
        self.description = try values.decodeIfPresent(String.self, forKey: .description)
        self.imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        self.locationName = try values.decodeIfPresent(String.self, forKey: .locationName)
        self.address = try values.decodeIfPresent(String.self, forKey: .address)
        self.type = try values.decodeIfPresent(String.self, forKey: .type)
        self.createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        self.createdById = try values.decodeIfPresent(Int.self, forKey: .createdById)
        self.fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        self.commentCount = try values.decodeIfPresent(Int.self, forKey: .commentCount)
        self.likeCount = try values.decodeIfPresent(Int.self, forKey: .likeCount)
        self.isLiked = try values.decodeIfPresent(Bool.self, forKey: .isLiked)
        self.isMaybe = try values.decodeIfPresent(Bool.self, forKey: .isMaybe)
        self.isGoing = try values.decodeIfPresent(Bool.self, forKey: .isGoing)
        self.profileUrl = try values.decodeIfPresent(String.self, forKey: .profileUrl)
        self.eventSlots = try values.decodeIfPresent([EventSlots].self, forKey: .eventSlots)
        self.truckIds = try values.decodeIfPresent(String.self, forKey: .truckIds)
        self.isInviting = try values.decodeIfPresent(Bool.self, forKey: .isInviting)
        self.invitedTrucks = try values.decodeIfPresent([InvitedTrucks].self, forKey: .invitedTrucks)
        
        self.latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        self.peopleComing = try values.decodeIfPresent(Int.self, forKey: .peopleComing)

	}
}
