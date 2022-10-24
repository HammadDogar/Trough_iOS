//
//  UserProfileViewController.swift
//  Trough
//
//  Created by Imed on 02/04/2021.
//

import UIKit

class UserProfileViewController: BaseViewController {
    @IBOutlet weak var lblUserTitle: UILabel!
    @IBOutlet weak var lblUserPhone: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setData()
        
        //self.stripeApiCall()
    }
    
    func setData(){
        self.lblUserTitle.text = Global.shared.currentUser.fullName
        self.lblUserPhone.text = Global.shared.currentUser.phone
        self.lblUserEmail.text = Global.shared.currentUser.email
    }
    
 
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionEditProfileBtn(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionChangePassword(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionPayment(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController") as? PaymentMethodViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionMyOrders(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderViewController") as? MyOrderViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func stripeApiCall(){
        let dateString = "2001-04-16T05:41:57.934Z"
        createStripeConnectAccount(dateOfBirth: dateString) { (isValid,message) in
            if isValid{
                if let link = URL(string: message) {
                  UIApplication.shared.open(link)
                }
            }else{
                self.simpleAlert(title: "Failed", msg: message)
            }
        }

    }
    
}



extension UserProfileViewController {
    func createStripeConnectAccount(dateOfBirth: String, complete : @escaping((Bool,String)->Void)){

        let params: [String : Any] = ["dateOfBirth": dateOfBirth]
        let service = ModeSelectionService()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        print(params)
        GCD.async(.Default) {
            service.createStripeConnectAccount(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                print(params)
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        complete(true,serviceResponse.data as! String)
                    }
                case .Failure :
                    GCD.async(.Main) {
                        complete(false,serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        complete(false,serviceResponse.message)
                    }
                }
            }
        }
    }
}

