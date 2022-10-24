//
//  CommentResponseViewModel.swift
//  Trough
//
//  Created by Macbook on 15/03/2021.
//

import UIKit


struct CommentResponseViewModel : Codable {
    var status : Int?
    var message : String?
    var commentList : [CommentViewModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case commentList = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        commentList = try values.decodeIfPresent([CommentViewModel].self, forKey: .commentList)
    }

}

