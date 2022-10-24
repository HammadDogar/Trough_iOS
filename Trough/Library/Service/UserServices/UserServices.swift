//
//  UserServices.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import Foundation
class UserServices: BaseService {

    //Check USER Email Exists
    func userEmailExistRequest(email: String,params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = USER_EMAIL_EXISTS_URL+email
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: false, requestMessage: networkRequestMessage) { (networkResponseMessage) in
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
    
    //REGISTER USER
    func userRegistrationRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = USER_REGISTRATION_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        
        BaseNetwork().performNetworkTask(isToken: false, requestMessage: networkRequestMessage) { (networkResponseMessage) in
//        }
//        BaseNetwork().performUploadImageNetworkTask1(requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let user = try JSONDecoder().decode(UserModel.self , from: networkResponseMessage.data as! Data)
                    if user.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = user.message ?? ""
                        response.data = user.data
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
    
    //LOGIN USER
    func userLoginRequest(isThird:Bool, params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = isThird ? USER_LOGIN_With_OTHERS_URL : USER_LOGIN_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: false, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let user = try JSONDecoder().decode(UserModel.self , from: networkResponseMessage.data as! Data)
                    if user.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = user.message ?? ""
                        response.data = user.data
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
    
    //UPDATE USER TOKEN
    func userDeviceTokenUpdateRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = USER_DEVICE_TOKEN_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
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
    
    //Forgot Password Api
    func ForgotpasswordApi(params : [String : Any],email:String,userRoleId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Users/ForgotPassword?email=\(email)&userRoleId=\(userRoleId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: false, requestMessage: networkRequestMessage) { (networkResponseMessage) in
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
    
    
    //Get All User
    func getAllUser(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_ALL_USER
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(GetAllUserViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.userData as AnyObject?

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
    
    //Update USER Profile
    func updateUserProfile(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = UPDATE_USER_PROFILE
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .HTML, url: url, params: params as Dictionary<String,AnyObject>)
        
//        BaseNetwork().performUploadImageNetworkTask1(requestMessage: networkRequestMessage) { (networkResponseMessage) in
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let user = try JSONDecoder().decode(UserModel.self , from: networkResponseMessage.data as! Data)
                    if user.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = user.message ?? ""
                        response.data = user.data
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
    
    //Reset Password API REQUEST
    func ResetPasswordRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = RESET_PASSWORD_REQUEST
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
    
    //GET FriendList API REQUEST
    func getFriendList(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_ALL_FRIEND
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(FriendListResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.friendList as AnyObject?

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
    
    //Add Friend API REQUEST
    func addFriendRequest(params : [String : Any],FriendId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Users/AddFriend?friendId=\(FriendId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
//                        response.data = result.data as AnyObject?

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
    
    //Add Friend API REQUEST
    func removeFriendRequest(params : [String : Any],FriendId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Users/RemoveFriend?friendId=\(FriendId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        //response.data = result.data as AnyObject?

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
    
    
    //GET NOTIFICATION API REQUEST
    func UsersFavouriteLocations(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_USER_FAVOURITE_LOCATIONS
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(FavouriteLocationResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

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

    //Save User Location API REQUEST
    func SaveUserLocation(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
//        let url = ADD_EDIT_USER_FAVOURITE_LOCATION
        let url = "https://troughapi.azurewebsites.net/api/UsersFavoriteLocation/AddEditV2"
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

    //GET TruckMenu API REQUEST
    func GetTruckMenu(params : [String : Any], truckId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Menu/GetMenuByTruckId?truckId=\(truckId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(TruckMenuResponseViewModel.self , from: networkResponseMessage.data as! Data)
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
    
    //GET UserCart API REQUEST
    func AddToCart(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = ADD_TO_CART
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
    
    //GET UserCart API REQUEST
    
func UserCart(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
    let url = "https://troughapi.azurewebsites.net/api/Orders/GetUserCart"//GET_USER_CART
    let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
    BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
        switch networkResponseMessage.statusCode {
        case .Success :
            do {
                let result = try JSONDecoder().decode(UserCartResponseViewModel.self , from: networkResponseMessage.data as! Data)
                if result.status == 1 {
                    let response = self.getSuccessResponseMessage()
                    response.message = result.message ?? ""
                    response.data = result.data as AnyObject?

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

    //Place Order Api Request
    func PlaceOrder(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = PLACE_ORDER
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
    
    
    //Place Order Api Request
    func PlacePreOrder(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = PLACE_PRE_ORDER
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
    
    
    func GetOrderByUser(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = GET_ORDER_BY_USER
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(GetOrderByUserResponseModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

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
    
    func GetTerms(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = GET_PRIVACY_AND_TERMS
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(TermsResponseModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

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
    
    //Remove From Cart Api Request
    func removeCartItem(params : [String : Any],id:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Orders/RemoveCartItem?Id=\(id)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
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
    
    func GetFoodCategories(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = FOOD_CATEGORIES
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                  let result = try JSONDecoder().decode(CategoriesResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

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

    //GET TruckMenu API REQUEST
    func GetTruckByFoodCategory(params : [String : Any], categoryId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/FoodTruck/GetTrucksByCategoryId?categoryId=\(categoryId)"
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

    //user pre order
    func GetPreOrderByUser(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = GET_PRE_ORDER_BY_USER
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: [:])
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(GetOrderByTruckResponseModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

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
    
    
    func GetOrderByUserTwo(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = GET_ORDER_BY_USER
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(GetOrderByTruckResponseModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

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
    
    
        //GET invited-event detials LISITNG API REQUEST
    func getUserInvitationList(params : [String : Any], userid:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
//        let url = GET_INVITATION_LIST
        let url = "https://troughapi.azurewebsites.net/api/Event/InviteUsersDetails?userid=\(userid)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(EventResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.eventList as AnyObject?

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
    
    
    //INVITATION OF EVENTS FOR USER API REQUEST
    
    //INVITATION OF EVENTS FOR TRUCK API REQUEST
    func acceptInvitationRequestOfEvent(params : [String : Any],eventId:Int,userId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Event/AcceptInvitedUsers?eventId=\(eventId)&userId=\(userId)"
        
//        let url = ACCEPT_EVENT_INVITATION_FOR_TRUCK
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .HTML, url: url, params: params as Dictionary<String,AnyObject>)
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
    
    
    
    //GET FriendRequest List API REQUEST
    func getFriendRequestList(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_ALL_FRIEND_REQUEST
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(FriendListResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.friendList as AnyObject?

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
    
    
    //Add Friend API REQUEST
    func acceptOrRejectFriendRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = ACCEPT_REJECT_FRIEND_REQUEST
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
//                        response.data = result.data as AnyObject?

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
    
    
    
        //GET userwhoaccepted LISITNG API REQUEST
    func getUserWhoAcceptedList(params : [String : Any], eventId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Event/AcceptedInvitedEventUsers?eventId=\(eventId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ComingPeopleResponseModel.self , from: networkResponseMessage.data as! Data)
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
    
    
    
        //GET truckwhoaccepted LISITNG API REQUEST
    func gettruckWhoAcceptedList(params : [String : Any], eventId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Event/AcceptedInvitedEventTrucks?eventId=\(eventId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .HTML, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ComingPeopleResponseModel.self , from: networkResponseMessage.data as! Data)
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
    
    
    //GET Services Cites List API REQUEST
    func getServicesCitesList(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_SERVICES_CITES
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ServicesCitesResponseModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

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
    
    
    //Add UserCity
    func addServicesCity(params : [String : Any],ServicesCity:String, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net//api/ServicesCity/AddServicesCityUser?ServicesCity=\(ServicesCity)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .HTML, url: url, params: params as Dictionary<String,AnyObject>)
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
    
    //requestForCity
    func requestServicesCity(params : [String : Any],ServicesCity:String, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/ServicesCity/ApprovalCities?ServicesCity=\(ServicesCity)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .HTML, url: url, params: params as Dictionary<String,AnyObject>)
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

