
import Foundation

class WorkHours : Codable {
	var dayOfWeek : Int = -1
	var startTime : String = ""
	var endTime : String = ""

    init(){
        
    }
    
	enum CodingKeys: String, CodingKey {

		case dayOfWeek = "dayOfWeek"
		case startTime = "startTime"
		case endTime = "endTime"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        dayOfWeek = try values.decodeIfPresent(Int.self, forKey: .dayOfWeek)!
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime)!
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime)!
	}

}
