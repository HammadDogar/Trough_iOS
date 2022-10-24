//
//  RepliesViewModel.swift
//  traf
//
//  Created by Mateen Nawaz on 13/01/2021.
//

import Foundation
import UIKit

class RepliesViewModel {
    
    
    var replyId : Int
    var commentId: Int
    var replyUserImage = ""
    var replyLikeCount = Int()
    var replysCount = Int()
    var replyDay =  ""
    var replyText = ""
//    var isSeeMore = false
    
    init() {
        self.replyId = -1
        self.commentId = -1
        self.replyUserImage = ""
        self.replyLikeCount = 0
        self.replysCount = Int()
        self.replyDay = ""
        self.replyText = ""
//        self.isSeeMore = false

        
    }
    
    init(id: Int,comentId: Int,image: String,likes: Int,cCounts:Int,cDay: String,cText: String) {
        self.replyId = id
        self.commentId = comentId
        self.replyDay = cDay
        self.replyLikeCount = likes
        self.replyUserImage = image
        self.replyText = cText
//        self.isSeeMore = false
        
    }
    
}



