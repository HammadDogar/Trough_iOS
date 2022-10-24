//
//  RequestForCityViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 17/10/2022.
//

import UIKit

class RequestForCityViewController: BaseViewController {

    @IBOutlet weak var requestedCity: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func actionRequestCity(_ sender: Any) {
        requestCity()
    }
    
}

extension RequestForCityViewController{
    
    func requestCity(){
        let params =
            [
                "ServicesCity"        : self.requestedCity.text!
//                "userRoleId"        : 3
            ] as [String : Any]
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        print(params)
        let city : String = self.requestedCity.text ?? ""
        let service = UserServices()
        
        GCD.async(.Default) {
            service.requestServicesCity(params: params, ServicesCity: city) { serviceResponse in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            let alert = UIAlertController(title: "Success", message: "Your city was requested to the admin", preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (_) in
                      
                            self.moveToHome(isFromNotification: false)
    
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            print("Error adding city")
                        }

                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error adding city")
                    }
                default :
                    GCD.async(.Main) {
                        print("Error adding city")
                        
                    }
                }
            }
        }
    }
}
