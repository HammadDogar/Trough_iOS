//
//  ForgotPasswordViewController.swift
//  Trough
//
//  Created by Macbook on 15/03/2021.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        if !textFieldEmail.isEmailValid(){
            self.simpleAlert(title: "Alert", msg: "Enter Valid Email")
        }
        else{
            self.ForgotPasswordApi()
        }
    }
    
    @IBAction func actionBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func ForgotPasswordApi(){
        let params =
            [:
                
//                "email"        : self.textFieldEmail.text!,
//                "userRoleId"        : 3
                
            ] as [String : Any]
        let email:String = self.textFieldEmail.text!
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.ForgotpasswordApi(params: params,email: email, userRoleId: 2) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            self.simpleAlert(title: "Success", msg: "Please check Your Email")
                        }
                        else {
                            print("Error Sending Email")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error Sending Email")
                    }
                default :
                    GCD.async(.Main) {
                        print("Error Sending Email")                                    }
                }
            }
        }
    }
}
