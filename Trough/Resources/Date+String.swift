//
//  Date+String.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import UIKit

enum DateFormateStyle {
  case custom(String)
  case Chat_Format, DATE_FORMAT, TIME_FORMAT, TIME_FORMAT_24, TIME_DATE_FORMAT, DATE_TIME_FORMAT_ISO8601,DATE_FORMAT_M

  var value: String {
    switch self {
    case .Chat_Format:
        return "MM/dd/yyyy, HH:mm:ss a"
    case .DATE_FORMAT:
      return "MMM/dd/yyyy"
    case .TIME_FORMAT:
      return "h:mm a"
    case .TIME_FORMAT_24:
      return "HH:mm"
    case .TIME_DATE_FORMAT:
      return "h:mm a MM/dd/yyyy"
    case .DATE_TIME_FORMAT_ISO8601:
      return "yyyy-MM-dd'T'HH:mm:ss"
    case .DATE_FORMAT_M:
        return "MMMM-dd-yyyy"
    case .custom(let customValue):
      return customValue
    }
  }
}

extension Date {
    
    func string(with format: DateFormateStyle) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.value
        return formatter.string(from: self)
    }
    
    func getOnlyDate() -> Date {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date1 = Calendar.current.date(from: dateComponents)
        return date1 ?? Date()
    }
    
    func days(from date: Date) -> Int {
        let dateComponents = Calendar.current.dateComponents([.day], from: date, to: self)
        return abs(dateComponents.day ?? 0)
    }
    
    func getPastTime() -> String{
        let now = Date()
        var secondsAgo = Int(now.timeIntervalSince(self))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        if secondsAgo < minute  {
            if secondsAgo < 2{
                return "just now"
            }else{
                return "\(secondsAgo) secs ago"
            }
        } else if secondsAgo < hour {
            let min = secondsAgo/minute
            if min == 1{
                return "\(min) min ago"
            }else{
                return "\(min) mins ago"
            }
        } else if secondsAgo < day {
            let hr = secondsAgo/hour
            if hr == 1{
                return "\(hr) hr ago"
            } else {
                return "\(hr) hrs ago"
            }
        } else if secondsAgo < week {
            let day = secondsAgo/day
            if day == 1{
                return "\(day) day ago"
            }else{
                return "\(day) days ago"
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            //            formatter.locale = Locale(identifier: "en_US")
            let strDate: String = formatter.string(from: self)
            return strDate
        }
    }
}

extension Date {
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}

extension String {
    func date(with format: DateFormateStyle) -> Date? {
        let dateComponentsArray = self.components(separatedBy: ".")
        let dateOnlywithtime: String = dateComponentsArray[0]
        let formatter = DateFormatter()
        formatter.dateFormat = format.value
        return formatter.date(from: dateOnlywithtime)
    }
    
    func timeConversion12() -> String {
        let dateAsString = self
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
}
