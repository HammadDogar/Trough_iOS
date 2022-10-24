//
//  proposalServices.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import Foundation


class ProposalServices: BaseService {
    
    func getAllPaymentRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url =  GET_ALL_PAYMENT_METHOD_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let data = try JSONDecoder().decode(PaymentMethodListViewModel.self , from: networkResponseMessage.data as! Data)
                    if data.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = data.message ?? ""
                        response.data = data.data as AnyObject?
                        
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
