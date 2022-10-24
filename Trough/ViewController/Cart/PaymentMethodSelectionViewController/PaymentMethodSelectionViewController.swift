//
//  PaymentMethodSelectionViewController.swift
//  Trough
//
//  Created by Imed on 07/07/2021.
//
import UIKit

protocol ConfirmPaymentDelegate : AnyObject {
    func cardSelect(paymentId : Int)
    func cashSelect(isCod : Bool)
}

class PaymentMethodSelectionViewController: UIViewController , PaymentMethodInfoDelegate{
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var paymentSelectionBtn: UIButton!
    @IBOutlet weak var cashBtn: UIButton!
    
    weak var delegate : ConfirmPaymentDelegate?
    
    
    var cardList = [PaymentMethodViewModel]()
    var paymentId = 0
    var isCod = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
        } else{
            sender.isSelected = true
        }
        
    }
    @IBAction func moveToPaymentView(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Settings", bundle: nil)
        if #available(iOS 13.0, *) {
            let vc = sb.instantiateViewController(identifier: "PaymentMethodViewController") as! PaymentMethodViewController
            vc.delegate = self
//            present(vc, animated: true, completion: nil)
            
            self.navigationController?.pushViewController( vc, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func actionDone(_ sender: UIButton) {
        //        if ((delegate?.cardSelect(paymentId: self.paymentId)) != nil) && ((delegate?.cashSelect(isCod: false)) != nil){
        //            self.delegate?.cardSelect(paymentId: paymentId)
        //            print(self.delegate?.cardSelect(paymentId: 0) as Any)
        //        }
        //        else
        //        {
        //            self.delegate?.cashSelect(isCod: true)
        //            print(self.delegate?.cashSelect(isCod: true) as Any)
        //        }
        //        self.navigationController?.popViewController(animated: true)
        //
        
        if (paymentId != 0 && isCod == false){
            
            self.delegate?.cardSelect(paymentId: paymentId)
        }
        else{
            self.delegate?.cashSelect(isCod: true)
        }
        
        // if (paymentId != 0 && isCod == false){
        //
        //    let temp = paymentId
        //    paymentId = temp
        //    print("---->", temp)
        //    }
        //    else{
        //        self.isCod = true
        //        print("--+",isCod)
        //    }
        self.navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    func didSelectCard(paymentId: Int) {
        self.paymentId = paymentId
//        print(paymentId)
    }
    func didSelectCash(isCOD: Bool) {
        self.isCod = isCOD
//        print(isCod)
    }
    
}
