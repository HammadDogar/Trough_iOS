//
//  StripeApiService.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import Foundation


class ModeSelectionService: BaseService {
    
    //Stripe Connect Account
    func createStripeConnectAccount(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = CREATE_STRIPE_CONNECT_ACCOUNT
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let data = try JSONDecoder().decode(ModeSelectionViewModel.self , from: networkResponseMessage.data as! Data)
                    if data.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = data.message ?? ""
                        response.data = data.data as AnyObject
                        
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = data.message ?? ""
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
    
    func createStripeCustomerAccount(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = CREATE_CUSTOMER_STRIPE_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let data = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if data.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = data.message ?? ""
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = data.message ?? ""
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

