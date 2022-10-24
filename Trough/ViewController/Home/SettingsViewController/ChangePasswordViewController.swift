//
//  ChangePasswordViewController.swift
//  Trough
//
//  Created by Imed on 08/04/2021.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var textFieldOldPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveChanges(_ sender: UIButton) {
        
        let params:[String:Any] = [
            "userId": Global.shared.currentUser.userId!,
            "oldPassword": self.textFieldOldPassword.text!,
            "password":self.textFieldNewPassword.text!,
            "confirmPassword":self.textFieldConfirmPassword.text!
        
                            ]
        
        let service = UserServices()
        GCD.async(.Default) {
            service.ResetPasswordRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                  
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            
                            self.simpleAlert(title: "Alert!", msg: "Password updated Successfully")
                            
                        }
                        else {
                            self.simpleAlert(title: "Alert!", msg: "Error Updating User Password")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: "Error Updating User Password")
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: "Error Updating User Password")
                    }
                }
            }
        }

    }
    

}
