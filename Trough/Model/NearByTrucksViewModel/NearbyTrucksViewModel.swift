
import Foundation

struct NearbyTrucksViewModel : Codable {
	var truckId : Int?
	var name : String?
	var description : String?
	var createdDate : String?
	var bannerUrl : String?
//	var liveLatitude : String?
//	var liveLongitude : String?
	var permanentLatitude : Double?
	var permanentLongitude : Double?
	var address : String?
	var totalReviews : Int?
	var averageRating : Double?
	var eventIds : [EventIds]?
	var workHours : [WorkHours]?
    
    var isSelected = false
//    var isInviting : Bool?

	enum CodingKeys: String, CodingKey {
		case truckId = "truckId"
		case name = "name"
		case description = "description"
		case createdDate = "createdDate"
		case bannerUrl = "bannerUrl"
//		case liveLatitude = "liveLatitude"
//		case liveLongitude = "liveLongitude"
		case permanentLatitude = "permanentLatitude"
		case permanentLongitude = "permanentLongitude"
		case address = "address"
		case totalReviews = "totalReviews"
		case averageRating = "averageRating"
		case eventIds = "eventIds"
		case workHours = "workHours"
        
        case isSelected = "isSelected"
//        case isInviting = "isInviting"
	}
    
    init() {}

    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
		bannerUrl = try values.decodeIfPresent(String.self, forKey: .bannerUrl)
//		liveLatitude = try values.decodeIfPresent(String.self, forKey: .liveLatitude)
//		liveLongitude = try values.decodeIfPresent(String.self, forKey: .liveLongitude)
		permanentLatitude = try values.decodeIfPresent(Double.self, forKey: .permanentLatitude)
		permanentLongitude = try values.decodeIfPresent(Double.self, forKey: .permanentLongitude)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		totalReviews = try values.decodeIfPresent(Int.self, forKey: .totalReviews)
		averageRating = try values.decodeIfPresent(Double.self, forKey: .averageRating)
		eventIds = try values.decodeIfPresent([EventIds].self, forKey: .eventIds)
		workHours = try values.decodeIfPresent([WorkHours].self, forKey: .workHours)
        
//        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected)!
//        self.isInviting = try values.decodeIfPresent(Bool.self, forKey: .isInviting)
	}

}
