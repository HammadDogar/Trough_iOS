//
//  PromotionCodeViewController.swift
//  Trough
//
//  Created by Imed on 09/09/2021.
//

import UIKit

class PromotionCodeViewController: UIViewController {

    
    @IBOutlet weak var promoTextField: UITextField!
    
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
    
    @IBAction func actionPromoCode(_ sender: Any) {
        let alert = UIAlertController(title: "Invalid promo code", message: "Please enter correct promo code", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in }))
        self.present(alert, animated: true, completion: nil)
    }


}
