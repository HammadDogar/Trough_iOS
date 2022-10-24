//
//  CreateEventViewModel.swift
//  Trough
//
//  Created by Irfan Malik on 29/12/2020.
//

import Foundation
import UIKit

class CreateEventViewModel{
    var eventId = 0
    var EventName = ""
    var Description = ""
    var LocationName = ""
    var ImageUrl = ""
    var Address = ""
    var Latitude = 0.0
    var Longitude = 0.0
    var eventType = ""
    var TrucksInEvents = [14,15]
    var UsersInEvents = [25,26]
    var EventSlots = [NewEventSlotsViewModel]()
    var ImageFile = UIImage()
    
    var truckIds = ""
    var userIds = ""
    
    var isInviting = true
    
    init() {
        self.eventId = 0
        self.EventName = ""
        self.Description = ""
        self.LocationName = ""
        self.ImageUrl = ""
        self.Address = ""
        self.Latitude = 0.0
        self.Longitude = 0.0
        self.eventType = ""
        self.TrucksInEvents = [14,15]
        self.UsersInEvents = [25,26]
        self.EventSlots = [NewEventSlotsViewModel]()
        self.ImageFile = UIImage()
        
        self.truckIds = ""
        self.userIds = ""
        
        self.isInviting = true

    }
}
