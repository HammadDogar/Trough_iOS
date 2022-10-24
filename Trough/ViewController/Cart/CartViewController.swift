//
//  CartViewController.swift
//  Trough
//
//  Created by Imed on 05/04/2021.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewPaymentBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func reviewBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Cart", bundle: nil)
        if #available(iOS 13.0, *) {
            let mainVC = sb.instantiateViewController(identifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
            
            self.navigationController?.pushViewController( mainVC, animated: true)
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
               let cell = tableView.dequeueReusableCell(withIdentifier: "firstTableCell") as! FirstTableViewCell
               return cell
           } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableCell") as! SecondTableViewCell
               return cell
           } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "thirdTableCell") as! ThirdTableViewCell
            return cell
           }
    }

}
