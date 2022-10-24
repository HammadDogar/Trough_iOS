//
//  UserViewModel.swift
//  Trough
//
//  Created by Irfan Malik on 22/12/2020.
//

import Foundation
struct EndTime : Codable {
	var ticks : Int?
	var days : Int?
	var hours : Int?
	var milliseconds : Int?
	var minutes : Int?
	var seconds : Int?
	var totalDays : Double?
	var totalHours : Double?
	var totalMilliseconds : Int?
	var totalMinutes : Int?
	var totalSeconds : Int?

	enum CodingKeys: String, CodingKey {
		case ticks = "ticks"
		case days = "days"
		case hours = "hours"
		case milliseconds = "milliseconds"
		case minutes = "minutes"
		case seconds = "seconds"
		case totalDays = "totalDays"
		case totalHours = "totalHours"
		case totalMilliseconds = "totalMilliseconds"
		case totalMinutes = "totalMinutes"
		case totalSeconds = "totalSeconds"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        self.ticks = try values.decodeIfPresent(Int.self, forKey: .ticks)
        self.days = try values.decodeIfPresent(Int.self, forKey: .days)
        self.hours = try values.decodeIfPresent(Int.self, forKey: .hours)
        self.milliseconds = try values.decodeIfPresent(Int.self, forKey: .milliseconds)
        self.minutes = try values.decodeIfPresent(Int.self, forKey: .minutes)
        self.seconds = try values.decodeIfPresent(Int.self, forKey: .seconds)
        self.totalDays = try values.decodeIfPresent(Double.self, forKey: .totalDays)
        self.totalHours = try values.decodeIfPresent(Double.self, forKey: .totalHours)
        self.totalMilliseconds = try values.decodeIfPresent(Int.self, forKey: .totalMilliseconds)
        self.totalMinutes = try values.decodeIfPresent(Int.self, forKey: .totalMinutes)
        self.totalSeconds = try values.decodeIfPresent(Int.self, forKey: .totalSeconds)
	}
}
