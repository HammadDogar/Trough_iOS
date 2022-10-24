//
//  Notifications.swift
//  Trough
//
//  Created by Imed on 11/02/2021.
//


import UIKit

class Notifications: BaseService  {
    
    //GET NOTIFICATION API REQUEST
    func notificatons(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Notification/GetALL?take=50"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(NotificationResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.notificationsList as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = result.message ?? ""
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
