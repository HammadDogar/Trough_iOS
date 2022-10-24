//
//  EventsService.swift
//  Trough
//
//  Created by Irfan Malik on 22/12/2020.
//

import Foundation
class EventsServices: BaseService {
    
    //GET EVENTS LISITNG API REQUEST
    func getEventsListRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_EVENTS_LISTING_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let event = try JSONDecoder().decode(EventResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if event.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = event.message ?? ""
                        response.data = event.eventList as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = event.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    //EVENTS GOING OR MAYBE API REQUEST
    func eventGoingOrMaybeRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = EVENT_GOING_MAYBE_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let event = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if event.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = event.message ?? ""
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = event.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    //POST EVENT REQUEST
    func postEventRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = NEW_OR_EDIT_EVENT_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        
//        BaseNetwork().performUploadImageNetworkTaskPostEvent(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let user = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if user.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = user.message ?? ""
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = user.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    //TRUCK INVITATION  API REQUEST
    func truckInviteRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
    
        let url = INVITE_AND_UNINVITE_TRUCK_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let event = try JSONDecoder().decode(EventResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if event.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = event.message ?? ""
                        response.data = event.eventList as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = event.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    //GET ACTIVITY LISITNG API REQUEST
    func getActivityListRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_ACTIVITY_LISTING_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let activity = try JSONDecoder().decode(EventResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if activity.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = activity.message ?? ""
                        response.data = activity.eventList as AnyObject?
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = activity.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    //Forgot Password Api
    func LikeApiRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = ADD_EDIT_COMMENT_LIKE_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    //GET Comment Request
    func getCommentRequest(params : [String : Any],eventId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Comments/GetComments?eventId=\(eventId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(CommentResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.commentList as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    //Add Comment Request
    func addCommentRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = ADD_EDIT_COMMENT_LIKE_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    
    //Comment like api
    func LikeCommentApiRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = LIKE_COMMENT
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
}
