//
//  NearByServices.swift
//  Trough
//
//  Created by Irfan Malik on 06/01/2021.
//

import Foundation

class NearByServices: BaseService {
    
    //GET NearBy Trucks LISITNG API REQUEST
    func getNearByTrucksListRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_NEAR_BY_TRUCKS
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(NearByTruckResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.nearByTrucksList as AnyObject?

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
