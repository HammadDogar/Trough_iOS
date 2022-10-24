//
//  ModeSelectionViewModel.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

class ModeSelectionViewModel : Codable {
    var status : Int?
    var message : String?
    var data : String?

    init()
    {}
    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.data = try values.decodeIfPresent(String.self, forKey: .data)
    }
}
