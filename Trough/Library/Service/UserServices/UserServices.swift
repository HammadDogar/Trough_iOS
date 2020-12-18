//
//  UserServices.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import Foundation
class UserServices: BaseService {

    //ADD CUSTOMER
//    func addCustomerRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
//        let url = ADD_CUSTOMER_URL
//        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
//        BaseNetwork().performNetworkTask(isToken: false, requestMessage: networkRequestMessage) { (networkResponseMessage) in
//            switch networkResponseMessage.statusCode {
//            case .Success :
//                do {
//                    let user = try JSONDecoder().decode(AddCustomerResponse.self , from: networkResponseMessage.data as! Data)
//                    if user.Status == 200 {
//                        let response = self.getSuccessResponseMessage()
//                        response.message = user.Message ?? ""
//                        complete(response)
//                    }
//                    else {
//                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
//                        response.message = user.Message ?? ""
//                        complete(response)
//                    }
//                }catch _ {
//                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
//                    complete(response)
//                }
//            case .Failure :
//                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
//                complete(response)
//            case .Timeout :
//                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
//                complete(response)
//            }
//        }
//    }

}
