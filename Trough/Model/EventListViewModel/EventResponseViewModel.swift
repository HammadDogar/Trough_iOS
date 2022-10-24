//
//  UserViewModel.swift
//  Trough
//
//  Created by Irfan Malik on 22/12/2020.
//

import Foundation

struct EventResponseViewModel : Codable {
	let status : Int?
	let message : String?
	let eventList : [EventViewModel]?

	enum CodingKeys: String, CodingKey {
		case status = "status"
		case message = "message"
		case eventList = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.eventList = try values.decodeIfPresent([EventViewModel].self, forKey: .eventList)
	}
}
