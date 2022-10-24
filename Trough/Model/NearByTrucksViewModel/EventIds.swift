

import Foundation

struct EventIds : Codable {
	var eventId : Int?

	enum CodingKeys: String, CodingKey {

		case eventId = "eventId"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		eventId = try values.decodeIfPresent(Int.self, forKey: .eventId)
	}

}
