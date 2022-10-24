//
//  PaymentViewController.swift
//  Trough
//
//  Created by Imed on 06/04/2021.
//

import UIKit

class PaymentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moveToPaymentView: UIButton!
    
    @IBOutlet weak var confirmOrderBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func movetoPayment(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Cart", bundle: nil)
        if #available(iOS 13.0, *) {
            let mainVC = sb.instantiateViewController(identifier: "PaymentMethodSelectionViewController") as! PaymentMethodSelectionViewController
            
            self.navigationController?.pushViewController( mainVC, animated: true)
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func confirmOrderBtn(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Order Confirmed", message:
                "Your Order has been confirmed", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        let sb = UIStoryboard(name: "Home", bundle: nil)
        if #available(iOS 13.0, *) {
            let mainVC = sb.instantiateViewController(identifier: "EventsListViewController") as! EventsListViewController
            
            self.navigationController?.pushViewController( mainVC, animated: true)
            
        } else {
            // Fallback on earlier versions
        }
    self.present(alertController, animated: true)
       
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
               let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne") as! CellOneTableViewCell
               return cell
           } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! CellTwoTableViewCell
               return cell
           } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellThree") as! CellThreeTableViewCell
            return cell
           }

    }
    
}
