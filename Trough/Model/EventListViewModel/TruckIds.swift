import Foundation

struct TruckIds : Codable {
    var truckId : Int?

    enum CodingKeys: String, CodingKey {

        case truckId = "eventId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
    }

}
