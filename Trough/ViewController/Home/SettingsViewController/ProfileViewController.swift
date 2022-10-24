//
//  ProfileViewController.swift
//  Trough
//
//  Created by Imed on 02/04/2021.
//

import UIKit
import MobileCoreServices
//import Kingfisher

class ProfileViewController: BaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadImageLabel: UIButton!
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setProfileData()
    }
    
    func setProfileData(){
        
        self.textFieldFullName.text = Global.shared.currentUser.fullName
        self.textFieldEmail.text = Global.shared.currentUser.email ?? ""
        self.textFieldAddress.text = Global.shared.currentUser.address ?? ""
        self.textFieldPhoneNumber.text = Global.shared.currentUser.phone ?? ""
        
//        self.profileImage.kf.setImage(with: URL(string: BASE_URL + Global.shared.currentUser.profileUrl!))
        
        if Global.shared.currentUser.profileUrl  != "" && Global.shared.currentUser.profileUrl  != nil{
            if let url = URL(string: Global.shared.currentUser.profileUrl ?? "") {
                DispatchQueue.main.async {
                    self.profileImage.setImage(url: url)
                }
            }
        }else{
            self.profileImage.image = UIImage(named: "PlaceHolder2")
        }
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCamera(_ sender: UIButton){
        
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
    
    
    

    @IBAction func actionSaveBtn(_ sender: UIButton) {
        
        if isAllValidationWorks(){
            
            self.uploadImage()
            }

//        }
        else{
            print("Validation not Passed")
        }
    }
    
    func isAllValidationWorks()->Bool{
        
        if self.profileImage.image == nil{
            self.simpleAlert(title: "Alert", msg: "Select Profile Image!")
            return false
        }
        
        if textFieldFullName.isTextFieldEmpty(){
            self.simpleAlert(title: "Alert", msg: "Full Name field is empty!")
            return false
        }
        if !textFieldEmail.isEmailValid(){
            self.simpleAlert(title: "Alert", msg: "Enter Valid Email")
            return false
        }
        if textFieldPhoneNumber.text?.count ?? 0 < 8{
            self.simpleAlert(title: "Alert", msg: "Phone must be atleast 8 character long")
            return false
        }
        
        if textFieldAddress.isTextFieldEmpty(){
            self.simpleAlert(title: "Alert", msg: "Add address field is empty")
            return false
        }
        
        return true
    }

    func uploadImage(){
        if let image = self.profileImage.image {
            BlobUploadManager.shared.uploadFile(fileData: image.jpegData(compressionQuality: 0.5) ?? Data() , fileName: UUID().uuidString + ".jpg", folder: "User") { fileUrl, isCompleted in
                if isCompleted {
                    let urlString = BlobUploadManager.shared.imagesBaseUrl + fileUrl
                    self.editInfo(urlString: urlString)
                }
            }
        }
    }

    
    func editInfo(urlString: String){
        
        //Call Register Api
        let parameter: [String:Any] = ["FullName":textFieldFullName.text!,
                                       "Address":textFieldAddress.text!,
                                       "Phone":textFieldPhoneNumber.text!,
                                       "File": urlString,
                                       "Email":self.textFieldEmail.text!,
                                       "ProfileUrl": urlString

                                       ]
        print(parameter)
        let service = UserServices()
//            GCD.async(.Default) {
            self.startActivityWithMessage(msg: "")
            service.updateUserProfile(params: parameter) { (serviceResponse) in
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
                                self.simpleAlert(title: "Alert", msg: "Profile Updated Successfully")
                            }
                            else{
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
extension ProfileViewController{
    
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

extension ProfileViewController
{
    func imagePickerController(_ picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                self.profileImage.image = image
              
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
