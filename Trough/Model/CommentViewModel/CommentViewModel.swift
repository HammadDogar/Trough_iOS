//
//  CommentViewModel.swift
//  Trough
//
//  Created by Macbook on 15/03/2021.
//

import Foundation

struct CommentViewModel : Codable {
    
    var commentId : Int?
    var comment : String?
    var eventId : Int?
    var commentTypeId : Int?
    var parentId : Int?
    var createdDate : String?
    var createdById: Int?
    var fullName: String?
    var imageURL : String?
    
    var profileUrl: String?
    
    var commentLikeCount : Int?
    var isCommentLiked : Bool?
    
    enum CodingKeys: String, CodingKey {
        case commentId = "commentId"
        case comment = "comment"
        case eventId = "eventId"
        case commentTypeId = "commentTypeId"
        case parentId = "parentId"
        case createdDate = "createdDate"
        case createdById = "createdById"
        case fullName = "fullName"
        case imageURL = "imageURL"

        case commentLikeCount = "commentLikeCount"
        case isCommentLiked = "isCommentLiked"
        
        case profileUrl = "profileUrl"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.commentId = try values.decode(Int.self, forKey: .commentId)
        self.comment = try values.decodeIfPresent(String.self, forKey: .comment)
        self.eventId = try values.decode(Int.self, forKey: .eventId)
        self.createdDate = try values.decode(String.self, forKey: .createdDate)
        self.commentTypeId = try values.decode(Int.self, forKey: .commentTypeId)
        //self.parentId = try values.decode(Int.self, forKey: .parentId)
        self.createdById = try values.decode(Int.self, forKey: .createdById)
        self.fullName = try values.decode(String.self, forKey: .fullName)
        
        // 3 - Conditional Decoding
        if let id =  try values.decodeIfPresent(Int.self, forKey: .parentId) {
                    self.parentId = id
                }else {
                    self.parentId = -1
                }
        
        self.imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)

        self.commentLikeCount = try values.decodeIfPresent(Int.self, forKey: .commentLikeCount)
        self.isCommentLiked = try values.decodeIfPresent(Bool.self, forKey: .isCommentLiked)
        
        self.profileUrl = try values.decodeIfPresent(String.self, forKey: .profileUrl)

    }

}
