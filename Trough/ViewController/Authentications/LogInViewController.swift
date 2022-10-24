//
//  LogInViewController.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth
import GoogleSignIn
import Firebase
import AuthenticationServices
import Vision


class LogInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var btnFaceBook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var splashBackView: UIView!
    
//    var isFromNotification = false
    
    var data : SignInData?
    
    var errorMessage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Splash Screeen")
        passwordTextField.clearsOnBeginEditing = false
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

//        let defaults = UserDefaults.standard
//        defaults.value(forKey: "email")
        self.emailTextField.text = UserDefaults.standard.value(forKey: "email") as? String ?? ""
        
        Global.shared.loadLoginUserData()
        GCD.async(.Main, delay: 0.3) {
            if Global.shared.currentUser.userId != nil{
                Global.shared.headerToken = Global.shared.currentUser.token!
                self.splashBackView.isHidden = true
                
                self.emailTextField.text = UserDefaults.standard.value(forKey: "email") as? String ?? ""
//                self.passwordTextField.text = "asdasd"
                self.moveToHome(isFromNotification: true)
            }else{
                self.splashBackView.isHidden = true
                self.emailTextField.text = UserDefaults.standard.value(forKey: "email") as? String ?? ""
                //                self.passwordTextField.text = "asdasd"
            }
        }
        
        //        if let accessToken = AccessToken.current{
        //            print(accessToken)
        //            self.fireBaseFaceBookLogin(accessToken: accessToken.tokenString)
        //        }else if let userIdentifier = UserDefaults.standard.object(forKey: "userIdentifier1") as? String {
        //            self.getAppleCredantialsFrom(userId: userIdentifier)
        //        }else if let user = Auth.auth().currentUser{
        //            if user.uid == nil {
        //                //Show Login Screen
        //            } else {
        //                //Show content
        ////                self.moveToHome()
        //            }
        //        }
    }
    
    @IBAction func actionFaceBook(_ sender: Any){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.email,.publicProfile], viewController: self) { (loginResult) in
            switch loginResult{
            case .failed(let error):
                print("\(error.localizedDescription)")
            case .success(granted: let granted, declined: let declined, token: let token):
                print(token)
                print(granted.contains(.email))
                print(declined.contains(.email))
                self.fireBaseFaceBookLogin(accessToken: token.tokenString)
            case .cancelled:
                print("Cancelled")
            }
            
        }
    }
    
    func fireBaseFaceBookLogin(accessToken:String){
        let credantials = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credantials) { (authResult, error) in
            if error != nil{
                print("\(error?.localizedDescription)")
                return
            }
            print("successfully logged in")
            print(authResult)
            
            if let user = Auth.auth().currentUser{
                print("successfully logged in")
                print(user)
                let param : [String: Any] =
                    [
                        "fullName"          : user.displayName ?? "",
                        "email"             : user.email ?? "",
                        "phone"             : user.phoneNumber ?? "",
                        "profileUrl"        : "\(user.photoURL)",
                        "fcmDeviceToken"    : Global.shared.fcmToken,
                        "deviceTypeId"      : 12
                    ] as [String : Any]

                self.userLoginWithOtherOptionsRequest(params:param)

                //Server Api call to register
            }
        }
        
    }
    
    @IBAction func actionGoogle(_ sender: Any){
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func actionApple(_ sender: Any){
        self.handleAppleIdRequest()
    }
    
    @IBAction func actionShowPassword(_ sender: Any){
        self.passwordTextField.isSecureTextEntry.toggle()
        self.btnPassword.isSelected.toggle()
    }
    
    @IBAction func actionForgotPasswordBtn(_ sender: UIButton) {
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "ForgotPasswordViewController") as? ForgotPasswordViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func actionSignUp(_ sender: Any){
        if let vc = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionLogIn(_ sender: Any){
        if self.isValidate(){
            self.userLoginRequest()
        }else{
            self.simpleAlert(title: "", msg: self.errorMessage)
            
        }
        
        
    }
    
    func isValidate() -> Bool {
        var isValid = true
        if !self.emailTextField.isValidInput(){
            errorMessage = "Email is required!"
            isValid = false
        }
        else if !self.isValidEmail(self.emailTextField.text ?? ""){
            errorMessage = "Email is invalid!"
            isValid = false
        }
        else if !self.passwordTextField.isValidInput(){
            errorMessage = "Password is required!"
            isValid = false
        }
        return isValid
    }
}


extension LogInViewController{
    func userLoginRequest(){
        
        var params:[String:Any] = [:]
        
        if Global.shared.currentUser.userId != nil{
            
        }
        

         params = [
            "email"             : self.emailTextField.text!,
            "password"          : self.passwordTextField.text!,
            "fcmDeviceToken"    : Global.shared.fcmToken,
            "deviceTypeId"      : 12
        ] as [String : Any]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.userLoginRequest(isThird: false, params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let user = serviceResponse.data as? UserViewModel {
                            print(user)
                            Global.shared.currentUser = user
                            Global.shared.saveLoginUserData()
                            if user.isActive ?? false {
                                Global.shared.headerToken = user.token ?? ""
//                                self.getFoodCategoriesListing()
                                let defaults = UserDefaults.standard
                                defaults.setValue(self.emailTextField.text!, forKey: "email")
                                
                                self.moveToHome(isFromNotification: true)
                            }else{
                                self.simpleAlert(title: "Access denied", msg: "Please contact app administrator")
                            }
                        }
                        else {
                            self.simpleAlert(title: "Access denied", msg: serviceResponse.message)
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Access denied", msg: serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Access denied", msg: serviceResponse.message)
                    }
                }
            }
        }
    }
    
    func userLoginWithOtherOptionsRequest(params: [String: Any]){
        
//        let params = [
//            "email"             : self.emailTextField.text!,
//
//            "fcmDeviceToken"    : Global.shared.fcmToken,
//            "deviceTypeId"      : 12
//        ] as [String : Any]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.userLoginRequest(isThird: true, params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let user = serviceResponse.data as? UserViewModel {
                            Global.shared.currentUser = user
                            Global.shared.saveLoginUserData()
                            if user.isActive ?? false {
                                Global.shared.headerToken = user.token ?? ""
//                                self.getFoodCategoriesListing()
                                self.moveToHome(isFromNotification: true)
                                
                            }else{
                                self.simpleAlert(title: "Access denied", msg: "Please contact app administrator")
                            }
                        }
                        else {
                            self.simpleAlert(title: "Access denied", msg: serviceResponse.message)
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Access denied", msg: serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Access denied", msg: serviceResponse.message)
                    }
                }
            }
        }
    }
}

extension LogInViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print("\(error.localizedDescription)")
            return
        }
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile
        
        guard let authentication = user.authentication else { return }
        
        let credantials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credantials) { (authResult, error) in
            if error != nil{
                print("\(error?.localizedDescription)")
                return
            }
            print("successfully logged in")
            print(authResult)
            
            if let user = Auth.auth().currentUser{
                print("successfully logged in")
                print(user)
                let param : [String: Any] =
                    [
                        "email"             : email?.email ?? "",
                        "fullName"          : fullName ?? "",
                        "phone"             : "",
                        "profileUrl"        : "\(user.photoURL)",
                        "fcmDeviceToken"    : Global.shared.fcmToken,
                        "deviceTypeId"      : 12
                    ] as [String : Any]

                self.userLoginWithOtherOptionsRequest(params:param)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("disconnected")
    }
    
}

extension LogInViewController: ASAuthorizationControllerDelegate{
    
  
    
    func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if userIdentifier != "" && fullName?.givenName != nil && email != nil {
//                let dict: [String: Any] = ["userId": userIdentifier,
//                                           "email": fullName,
//                                           "name": email]
             data =  SignInData.init(userId: userIdentifier, email: email ?? "", name: fullName?.givenName ?? "")

                
                saveMetaData()
//                UserDefaults.standard.set(dict, forKey: "appleIdCredentials")
//                UserDefaults.standard.synchronize()
            }
            
            func saveMetaData() {
                let jsonEncoder = JSONEncoder()
                do {
                    let encoded = try jsonEncoder.encode(data)
                    UserDefaults.standard.set(encoded, forKey: "appleIdCredentials")
                    UserDefaults.standard.synchronize()
                }catch {
                    print(error.localizedDescription)
                }
            }

            func loadMetaData() -> SignInData? {
                    if let data = UserDefaults.standard.data(forKey: "appleIdCredentials") {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let item = try jsonDecoder.decode(SignInData.self, from: data)
                            return item
                        }catch {
                            print(error.localizedDescription)
                        }
                    }
                    return nil
                }
                
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            
            if let sdata = loadMetaData() {
                self.data = sdata
            }
            

            self.getAppleCredantialsFrom(userId: data?.userId ?? "", fullName: data?.name ?? "", email: data?.email ?? "")
        }
        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            
            print("\(appleUsername) --- \(applePassword)")
            //Write your code
        }
    }
    
    func getAppleCredantialsFrom(userId:String, fullName:String, email:String){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userId) {  (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                let defaults = UserDefaults.standard
                defaults.set(userId, forKey: "userIdentifier1")
                let param : [String: Any] =
                    [
                        "email"             : email,
                        "fullName"          : fullName,
                        "phone"             : "",
                        "profileUrl"        : "",
                        "fcmDeviceToken"    : Global.shared.fcmToken,
                        "deviceTypeId"      : 12
                    ] as [String : Any]

                self.userLoginWithOtherOptionsRequest(params:param)
                
                break
            case .revoked:
                // The Apple ID credential is revoked.
                break
            case .notFound:
                // No credential was found, so show the sign-in UI.
                print("No found any user")
            default:
                break
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print(error.localizedDescription)
    }
}

struct SignInData : Codable {
    var userId: String = ""
    var email: String = ""
    var name: String
}

   enum CodingKeys: String, CodingKey {
          case userId ,email
          case name
   }

//
//init(from decoder: Decoder) throws {
//    let values = try decoder.container(keyedBy: CodingKeys.self)
//    name = try values.decode(NSObject.self, forKey: .name)
//    email = try values.decode(String.self, forKey: .name)
//    userId = try values.decode(String.self, forKey: .name)
//}
