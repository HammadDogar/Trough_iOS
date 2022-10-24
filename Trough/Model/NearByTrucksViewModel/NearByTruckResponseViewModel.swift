
import Foundation



// this will happen for notification

struct NearByTruckResponseViewModel : Codable {
    var status : Int?
    var message : String?
    var nearByTrucksList : [NearbyTrucksViewModel]?

    enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case nearByTrucksList = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
        nearByTrucksList = try values.decodeIfPresent([NearbyTrucksViewModel].self, forKey: .nearByTrucksList)
	}

}
