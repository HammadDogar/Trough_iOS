//
//  PromotionViewController.swift
//  Trough
//
//  Created by Imed on 07/09/2021.
//

import UIKit

protocol PromotionDelegate {
    func didAddCode(code : String)
}

class PromotionViewController: UIViewController {

    @IBOutlet weak var promoTextField: UITextField!    
    
    var delegate : PromotionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func actiionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionEnter(_ sender: Any) {

    }
    
    @IBAction func actionPromoCode(_ sender: Any) {
        self.delegate?.didAddCode(code: self.promoTextField.text ?? "")
        self.navigationController?.popViewController(animated: true)
    }
    
}
