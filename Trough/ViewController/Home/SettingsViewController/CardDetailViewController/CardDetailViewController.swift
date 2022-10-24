//
//  CardDetailViewController.swift
//  Trough
//
//  Created by Macbook on 16/04/2021.
//

import UIKit

class CardDetailsViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardDateView: UIView!
    @IBOutlet weak var cardNumberView: UIView!
    @IBOutlet weak var cardCvvTextField: UITextField!
    @IBOutlet weak var cardDateTextField: UITextField!
    @IBOutlet weak var cardYearTextField: UITextField!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var cardCvvView: UIView!
    var pay = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.cardNumberView.setborderView()
//        self.cardDateView.setborderView()
//        self.cardCvvView.setborderView()
        self.cardNumberTextField.delegate = self
        self.cardDateTextField.delegate = self
        self.cardCvvTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if(textField == cardNumberTextField){
         let currentText = textField.text ?? ""

          guard let stringRange = Range(range, in: currentText) else { return false }

          let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        
        if updatedText.count == 5 || updatedText.count == 10 || updatedText.count == 15{
            self.cardNumberTextField.text! += " "
        }
        return updatedText.count < 20
       }
        if(textField == cardCvvTextField){
            let currentText = textField.text ?? ""
            
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            
            
            return updatedText.count < 4
        }
        if(textField == cardDateTextField){
            
        }

       return true
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPay(_ sender: Any) {
        if self.cardNumberTextField.text != "" && self.cardCvvTextField.text != "" && self.cardDateTextField.text != "" {
            self.placeOrderRequest()
        }
        else{
            print("Please provide valid details")
            self.simpleAlert(title: "Info inValid", msg: "Please Provide Valid Card Details")
//            self.createAlertPopUp(desc: "Please Provide Valid Card Details")
//            self.alertView?.show()
        }
    }
    
    func placeOrderRequest(){
        let params =
            [
                "cardNumber"    : self.cardNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                "expMonth"      : Int(self.cardDateTextField.text ?? "0") ?? 0,
                "expYear"       : Int(self.cardYearTextField.text ?? "0") ?? 0,
                "cvc"           : self.cardCvvTextField.text ?? "",
//                "customerName"  : "Sikandar",//Global.shared.currentUser.firstName ?? "",
                "customerName"  : Global.shared.currentUser.fullName ?? "",
                "email"         : Global.shared.currentUser.email ?? ""
            ] as [String : Any]
        print(params)
        let service = ModeSelectionService()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.createStripeCustomerAccount(params: params) {  (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        self.stopActivity()
                        let alert = UIAlertController(title: "Success", message: "Stripe account created", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (_) in
                            //Global.shared.currentUser.isPaymentMethodAdded = true
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                case .Failure :
                    GCD.async(.Main) {
                        let alert = UIAlertController(title: "Failed", message: "\(serviceResponse.message)--4242 4242 4242 4242 this is test card number", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (_) in
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        print("Not Found!,Failed")
                    }
                default :
                    GCD.async(.Main) {
                        print("Not Found!")
                    }
                }
            }
        }
    }
}
