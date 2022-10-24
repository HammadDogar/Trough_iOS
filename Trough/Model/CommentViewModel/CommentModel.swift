//
//  CommentModel.swift
//  Trough
//
//  Created by Macbook on 16/03/2021.
//

import Foundation

struct commentModel {
    var commentId : Int?
    var comment : String?
    var eventId : Int?
    var commentTypeId : Int?
    var parentId : Int?
    var createdDate : String?
    var createdById: Int?
    var fullName: String?
    var isSeeMore = false
    
    var replies = [replyModel]()
    
    init(){
        self.commentId = -1
        self.comment = ""
        self.eventId = -1
        self.commentTypeId = -1
        self.parentId = -1
        self.createdDate = ""
        self.fullName = ""
        self.isSeeMore = false
        self.replies = [replyModel]()
    }
    init(cId:Int,c:String,eId:Int,ctId:Int,pId:Int,cDate:String,fName:String,iSMore:Bool,r:[replyModel]) {
        self.commentId = cId
        self.comment = c
        self.eventId = eId
        self.commentTypeId = ctId
        self.parentId = pId
        self.createdDate = cDate
        self.fullName = fName
        self.isSeeMore = iSMore
        self.replies = r

    }
}

struct replyModel {
    var commentId : Int?
    var comment : String?
    var eventId : Int?
    var commentTypeId : Int?
    var parentId : Int?
    var createdDate : String?
    var createdById: Int?
    var fullName: String?
    
    init(){
        self.commentId = -1
        self.comment = ""
        self.eventId = -1
        self.commentTypeId = -1
        self.parentId = -1
        self.createdDate = ""
        self.fullName = ""
    }
    
    init(cId:Int,c:String,eId:Int,ctId:Int,pId:Int,cDate:String,fName:String) {
        self.commentId = cId
        self.comment = c
        self.eventId = eId
        self.commentTypeId = ctId
        self.parentId = pId
        self.createdDate = cDate
        self.fullName = fName

    }

}
