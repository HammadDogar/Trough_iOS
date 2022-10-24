//
//  User-Order-DetialViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 29/08/2022.
//

import UIKit

class User_Order_DetialViewController: UIViewController {
    
    @IBOutlet weak var  truckImage: UIImageView!
    @IBOutlet weak var truckName: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var invoiceNumberLabel: UILabel!
    @IBOutlet weak var tableView: SelfSizingTableView!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var isReadyFor: UIImageView!
    
    var order : GetOrderByTruckModel?
    var id = 0
    var invoiceID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.mapping()
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
    
    
    func mapping(){
        self.truckName.text = order?.fullName ?? ""
//        if order?.isCOD != false && order?.isCOD != nil{
//            paymentCheckBox.isSelected = true
//        }
//        else {
//            paymentCheckBox.isHighlighted = true
//        }
        
//        if order?.orderDetail?[0].imageUrl != "" &&  order?.orderDetail?[0].imageUrl != nil {
//            let url = URL(string: BASE_URL+( order?.orderDetail?[0].imageUrl!)!) ?? URL.init(string: "https://www.google.com")!
//            self.truckImage.setImage(url: url)
//        }else{}
        
        if order?.orderDetail?[0].imageUrl != "" &&  order?.orderDetail?[0].imageUrl != nil {
            if let url = URL(string: order?.orderDetail?[0].imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.truckImage.setImage(url: url)
                }
            }
        }else{}

        
        var price = 0
        for i in 0...(self.order?.orderDetail?.count)! - 1 {
            price += (self.order?.orderDetail?[i].price!)!
        }
        self.totalAmountLabel.text = "$ \(price)"
        self.invoiceNumberLabel.text = order?.invoiceNumber ?? ""
        
        self.invoiceID = order?.invoiceNumber ?? ""
//        self.createdDate.text = order?.createdDate ?? ""
        
        let orderDates = order?.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        
        self.createdDate.text = "\(orderDates?.string(with: .custom("dd MMMM yyyy")) ?? "No Date Found")"

        if order?.isReadyPickUp == true{
            self.isReadyFor.image = UIImage(named: "yes")
        }
        else {
            self.isReadyFor.image = UIImage(named: "no")
        }
        
//        if order?.isCompleted == true{
//            self.completeButton.backgroundColor = .gray
//            self.completeButton.isEnabled = false
//            self.completeButton.titleLabel?.text = "Order was completed"
//        }
    }
   
}


extension User_Order_DetialViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.orderDetail?.count ?? 0
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User_Order_SummaryCell", for: indexPath) as! User_Order_SummaryCell
        if let item = self.order?.orderDetail?[indexPath.row] {
            cell.orderDetial(orders: item)
            
        }
        return cell
    }

}
