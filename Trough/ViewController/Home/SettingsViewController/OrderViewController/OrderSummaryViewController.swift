//
//  OrderSummaryViewController.swift
//  Trough
//
//  Created by Imed on 28/07/2021.
//

import UIKit

class OrderSummaryViewController: BaseViewController {
    
    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var truckName: UILabel!
    @IBOutlet weak var orderFromName: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmount: UILabel!
    
    var order : GetOrderByUserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapping()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func mapping(){
        
        self.truckName.text = order?.fullName ?? ""
        self.orderFromName.text = order?.fullName ?? ""
        self.deliveryAddress.text = order?.deliveryAddress ?? ""
        
        var price = 0
        for i in 0...(self.order?.orderDetail?.count)! - 1 {
            price += (self.order?.orderDetail?[i].price!)!
        }
        self.totalAmount.text = "$ \(price)"
        
//        if order?.bannerUrl != "" && order?.bannerUrl != nil {
//            let url = URL(string: BASE_URL+(order?.bannerUrl!)!) ?? URL.init(string: "https://www.google.com")!
//            self.truckImage.setImage(url: url)
//        }else{
//            self.truckImage.image = UIImage(named: "PlaceHolder2")
//        }
        
        if order?.bannerUrl != "" && order?.bannerUrl != nil {
            if let url = URL(string: order?.bannerUrl ?? "") {
                DispatchQueue.main.async {
                    self.truckImage.setImage(url: url)
                }
            }
        }else{
                self.truckImage.image = UIImage(named: "PlaceHolder2")
        }
        
    }
}

extension OrderSummaryViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.orderDetail?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryCell", for: indexPath) as! OrderSummaryTableViewCell
        if let item = self.order?.orderDetail?[indexPath.row] {
            cell.orderDetial(orders: item)
        }
        //        let item = self.userOrderDetial[indexPath.row]
        //        cell.getOrderDetial(orders: item)
        return cell
    }
    
}
