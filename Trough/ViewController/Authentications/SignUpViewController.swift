//
//  SignUpViewController.swift
//  Trough
//
//  Created by Irfan Malik on 18/12/2020.
//

import UIKit
import MobileCoreServices
import CoreLocation


class SignUpViewController: BaseViewController, CLLocationManagerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var btnConfirmPassword: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    var errorMessage = ""
    var isProfilePicture = false
    
    //
//    var locManager = CLLocationManager()
//    var currentLocation: CLLocation!
//    let geoCoder = CLGeocoder()
//    let location = CLLocation(latitude: 40.730610, longitude:  -73.935242) // <- New York
//    var latitude =  0.0
//    var longitude =  0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.btnPassword.setImage(UIImage(named: "hidePassword"), for: .selected)
        self.btnPassword.setImage(UIImage(named: "showPassword"), for: .normal)
        self.btnConfirmPassword.setImage(UIImage(named: "hidePassword"), for: .selected)
        self.btnConfirmPassword.setImage(UIImage(named: "showPassword"), for: .normal)
        
//        if (CLLocationManager.locationServicesEnabled())
//        {
//            locManager = CLLocationManager()
//            locManager.delegate = self
//            locManager.desiredAccuracy = kCLLocationAccuracyBest
//            locManager.requestAlwaysAuthorization()
//            locManager.startUpdatingLocation()
//        }
        
    }

    
    
    @IBAction func actionLogIn(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionShowPassword(_ sender: Any){
        self.passwordTextField.isSecureTextEntry.toggle()
        self.btnPassword.isSelected.toggle()
    }
    
    @IBAction func actionShowConfirmPassword(_ sender: Any){
        self.confirmPasswordTextField.isSecureTextEntry.toggle()
        self.btnConfirmPassword.isSelected.toggle()
    }
    @IBAction func actionUploadImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (action) in
            self.chooseFromLibrary(presentFrom: sender)
        }))
        alert.addAction(UIAlertAction(title: "Capture", style: .default, handler: { (action) in
            self.capturePhoto(presentFrom: sender)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        self.present(alert, animated: true, completion: nil)
    }
        
    @IBAction func actionPrivacy(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as? PrivacyViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    @IBAction func actionTerms(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionCheckBox(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        } else{
            sender.isSelected = true
        }
    }
    
    @IBAction func actionSignUp(_ sender: Any){
        if self.isValidate(){
            self.isUserEmailExists(email: self.emailTextField.text!) { (isExists,message) in
                if isExists{
                    self.uploadImage()
//                    self.userRegistrationRequest()
                }else{
                    self.simpleAlert(title: "Failed", msg: message)
                }
            }
        }else{
            self.simpleAlert(title: "", msg: self.errorMessage)
        }
    }
    
    func isValidate() -> Bool {
        
        var isValid = true
        
        if !self.isProfilePicture{
            self.simpleAlert(title: "Alert", msg: "Add Profile Picture")
            return false
        }
        
        else if !self.fullNameTextField.isValidInput(){
            errorMessage = "Name is required!"
            isValid = false
        }
        
        else if !self.emailTextField.isValidInput(){
            errorMessage = "Email is required!"
            isValid = false
        }
        else if !self.isValidEmail(self.emailTextField.text ?? ""){
            errorMessage = "Email is invalid!"
            isValid = false
        }
        else if !self.phoneTextField.isValidInput(){
            errorMessage = "Phone number is required!"
            isValid = false
        }
//        else if self.passwordTextField.text?.count ?? 0 < 5{
//            errorMessage = "Password must be atleast 6 characters long!"
//            isValid = false
//        }
//        else if self.confirmPasswordTextField.text?.count ?? 0 < 5{
//            errorMessage = "Password must be atleast 6 characters long!"
//            isValid = false
//        }
        else if !self.isValidPassword(password: self.passwordTextField.text ?? ""){
            self.simpleAlert(title: "Alert", msg: "Password must have 8 characters long including uppercase, lowercase, digits and special character")
            isValid = false
        }
        else if !self.isValidPassword(password: self.confirmPasswordTextField.text ?? ""){
            self.simpleAlert(title: "Alert", msg: "Confirm Password must have 8 characters long including uppercase, lowercase, digits and special character")
            isValid = false
        }
                    
        else if self.confirmPasswordTextField.text != self.passwordTextField.text{
            errorMessage = "Both passwords are not matched!"
            isValid = false
        }
        else if !self.checkButton.isSelected{
            
            errorMessage = "Please confirm to our Terms & Condition and Privacy policiy"
            
            isValid = false
        }
        return isValid
    }

}

extension SignUpViewController {
    
    func chooseFromLibrary(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func capturePhoto(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                self.profileImageView.image = image
                self.isProfilePicture = true
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

    }
    
    
}



extension SignUpViewController{
    func isUserEmailExists(email: String,complete : @escaping((Bool,String)->Void)){
       
        let params = [:] as [String : Any]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.userEmailExistRequest(email: email, params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if USER_EMAIL_SUCCESS == serviceResponse.message {
                            complete(true,serviceResponse.message)
                    }
                    else {
                        complete(false,serviceResponse.message)
                        print("User email already exists!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        complete(false,serviceResponse.message)
                        print("Failed to check email")
                    }
                default :
                    GCD.async(.Main) {
                        complete(false,serviceResponse.message)
                        print("Failed to check email")
                    }
                }
            }
        }
    }
    
    func uploadImage(){
        if let image = self.profileImageView.image {
            BlobUploadManager.shared.uploadFile(fileData: image.jpegData(compressionQuality: 0.5) ?? Data() , fileName: UUID().uuidString + ".jpg", folder: "User") { fileUrl, isCompleted in
                if isCompleted {
                    let urlString = BlobUploadManager.shared.imagesBaseUrl + fileUrl
                    self.userRegistrationRequest(urlString: urlString)
                }
            }
        }
    }
        
    func userRegistrationRequest(urlString : String ){
            let params = [
                "File": urlString,
                "ProfileUrl"        : "",
                "Email"             : self.emailTextField.text!,
                "Password"          : self.passwordTextField.text!,
                "FullName"          : self.fullNameTextField.text!,
                "Phone"             : self.phoneTextField.text!,
                "Address"           : "Lahore",
                "fcmDeviceToken"    : Global.shared.fcmToken,
                "deviceTypeId"      : 12
                ] as [String : Any]
            let service = UserServices()
            GCD.async(.Main) {
                self.startActivityWithMessage(msg: "")
            }
            GCD.async(.Default) {
                service.userRegistrationRequest(params: params) { (serviceResponse) in
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
                                    let alert = UIAlertController(title: "Success", message: "Register Successfully", preferredStyle: UIAlertController.Style.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (_) in
                                        //Global.shared.currentUser.isPaymentMethodAdded = true
    //                                    self.navigationController?.popViewController(animated: true)
                                        
                                        //---> commenting for add city flow
                                        self.moveToHome(isFromNotification: false)
                                        
                                        //---> adding this
//                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCityViewController") as! AddCityViewController
//                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    //self.moveToHome()
                                }else{
                                    self.simpleAlert(title: "Access denied", msg: "Please contact app administrator")
                                }
                            }else {
                            print("User email already exists!")
                        }
                    }
                    case .Failure :
                        GCD.async(.Main) {
                            print("User failed to Register")
                        }
                    default :
                        GCD.async(.Main) {
                            print("User failed to Register")
                        }
                    }
                }
            }
        }
    
}
//
//extension SignUpViewController {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        let location = locations.last! as CLLocation
//        /* you can use these values*/
//        let lat = location.coordinate.latitude
//        let long = location.coordinate.longitude
//
//        self.latitude = lat
//        self.longitude = long
//    }
//
//}

