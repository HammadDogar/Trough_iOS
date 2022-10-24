//
//  User_Pre_Order_DetailViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 30/08/2022.
//

import UIKit

class User_Pre_Order_DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: SelfSizingTableView!
    @IBOutlet weak var preuserImage: UIImageView!
    @IBOutlet weak var preTruckName: UILabel!
    @IBOutlet weak var pretotalAmountLabel: UILabel!
    @IBOutlet weak var preinvoiceNumberLabel: UILabel!
 
    @IBOutlet weak var preIsReadyImage: UIImageView!
    @IBOutlet weak var precompleteButton: UIButton!
    @IBOutlet weak var preCreatedDate: UILabel!
    
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
        self.preTruckName.text = order?.fullName ?? ""
//        if order?.isCOD != false && order?.isCOD != nil{
//            prepaymentCheckBox.isSelected = true
//        }
//        else {
//            prepaymentCheckBox.isHighlighted = true
//        }
        
//        if order?.orderDetail?[0].imageUrl != "" &&  order?.orderDetail?[0].imageUrl != nil {
//            let url = URL(string: BASE_URL+( order?.orderDetail?[0].imageUrl!)!) ?? URL.init(string: "https://www.google.com")!
//            self.preuserImage.setImage(url: url)
//        }else{}
        
        if order?.orderDetail?[0].imageUrl != "" &&  order?.orderDetail?[0].imageUrl != nil {
            if let url = URL(string: order?.orderDetail?[0].imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.preuserImage.setImage(url: url)
                }
            }
        }else{}
        
        var price = 0
        for i in 0...(self.order?.orderDetail?.count)! - 1 {
            price += (self.order?.orderDetail?[i].price!)!
        }
        self.pretotalAmountLabel.text = "$ \(price)"
        self.preinvoiceNumberLabel.text = order?.invoiceNumber ?? ""
//        self.preCreatedDate.text = order?.createdDate ?? ""
        
        let orderDates = order?.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        
        self.preCreatedDate.text = "\(orderDates?.string(with: .custom("dd MMMM yyyy")) ?? "No Date Found")"
        
        
        self.invoiceID = order?.invoiceNumber ?? ""
        
        if order?.isReadyPickUp == true{
            self.preIsReadyImage.image = UIImage(named: "yes")
        }
        else {
            self.preIsReadyImage.image = UIImage(named: "no")
        }
        
        
//        if order?.isCompleted == true{
//            self.precompleteButton.backgroundColor = .gray
//            self.precompleteButton.isEnabled = false
//            self.precompleteButton.titleLabel?.text = "Order was completed"
//        }
    }
}

extension User_Pre_Order_DetailViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.orderDetail?.count ?? 0
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User_PRE_Order_SummaryCell", for: indexPath) as! User_PRE_Order_SummaryCell
        if let item = self.order?.orderDetail?[indexPath.row] {
            cell.orderDetial(orders: item)
        }
        
        return cell
    }
    
}
