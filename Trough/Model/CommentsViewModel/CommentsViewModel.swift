//
//  Comment.swift
//  traf
//
//  Created by Mateen Nawaz on 13/01/2021.
//

import UIKit
import Foundation

class CommentsViewModel {
    
    var commentId : Int
    var commentUserImage = ""
    var commentLikeCount = Int()
    var commentsCount = Int()
    var commentDay = ""
    var commentText = ""
    var isSeeMore = false

    var replies = [RepliesViewModel]()
    
    init(){
        self.commentId = -1
        self.commentUserImage = ""
        self.commentLikeCount = 0
        self.commentsCount = 0
        self.commentDay = ""
        self.commentText = ""
        self.replies = [RepliesViewModel]()
        self.isSeeMore = false

    }
    
    init(id: Int,image: String,likes:Int,cCounts:Int,cDay: String,cText: String, reply: [RepliesViewModel] ,isSeeMore :Bool){
        self.commentId = id
        self.commentUserImage = image
        self.commentLikeCount = likes
        self.commentDay = cDay
        self.commentText = cText
        self.replies = reply
        self.isSeeMore = isSeeMore
    
    }
}

