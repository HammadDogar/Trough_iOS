//
//  NewEventSlotsViewModel.swift
//  Trough
//
//  Created by Irfan Malik on 29/12/2020.
//

import Foundation

class NewEventSlotsViewModel:Encodable{
    var startDate = ""
    var startTime = ""
    var endTime   = ""
    
    init() {}
    
    init(sDate:String,sTime:String,eTime:String) {
        self.startDate = sDate
        self.startTime = sTime
        self.endTime   = eTime
    }
    
    func toDictionary() -> [String: Any]{
        return ["startDate": startDate,
                "startTime": startTime,
                "endTime": endTime]
    }
  
}
