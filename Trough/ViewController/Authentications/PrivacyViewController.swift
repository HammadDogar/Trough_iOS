//
//  PrivacyViewController.swift
//  Trough
//
//  Created by Imed on 26/07/2021.
//

import UIKit

class PrivacyViewController: BaseViewController {

    
    @IBOutlet weak var privacyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PrivacyConditions()
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionAccept(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionDone(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PrivacyViewController {
    
    func PrivacyConditions(){
        
        var params: [String:Any] = [String:Any]()
        params = [
            :  ] as [String : Any]

        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            
            service.GetTerms(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
                        
                        if let termsList = serviceResponse.data as? [TermsViewModel] {
                            print(termsList)
//                            self.terms = termsList
                            let text = termsList.filter { $0.type == "Privacy"}.first
                            self.privacyTextView.text = text?.privacyText
                            
                        }
                        else {
                            print("No Item Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Item Found!!!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Item Found!!")
                    }
                }
            }
        }
    }
    
}
