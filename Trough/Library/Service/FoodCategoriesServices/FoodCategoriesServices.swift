//
//  FoodCategoriesServices.swift
//  Trough
//
//  Created by Irfan Malik on 05/01/2021.
//

import Foundation

class FoodCategoriesServices: BaseService {
    
    //GET FOOD CATEGORIES LISITNG API REQUEST
    func getFoodCategoriesListRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = FOOD_CATEGORIES_LIST_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let category = try JSONDecoder().decode(FoodCatoriesResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if category.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = category.message ?? ""
                        response.data = category.foodCategoriesList as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = category.message ?? ""
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
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .HTML, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performUploadImageNetworkTaskPostEvent(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
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
}
