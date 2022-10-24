//
//  User_OrderTableViewCell.swift
//  Trough
//
//  Created by Mateen Nawaz on 29/08/2022.
//

import UIKit

class User_OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var totalAmmount: UILabel!
    @IBOutlet weak var orderTruckName: UILabel!
    @IBOutlet weak var orderByLabel: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var foodTitle: UILabel!
    
    var myOrder : GetOrderByTruckModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(getOrder : GetOrderByTruckModel){
        self.myOrder = getOrder
        self.orderTruckName.text = "\(getOrder.fullName ?? "")"
        self.totalAmmount.text = "\(getOrder.totalAmount ?? 0)"
//        self.orderDate.text = "\(getOrder.createdDate ?? "")"
        
        let orderDates = getOrder.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        
        self.orderDate.text = "\(orderDates?.string(with: .custom("dd MMMM yyyy")) ?? "No Date Found")"
        
        
//        self.orderUserName.text = "\(getOrder.fullName ?? "")"
        self.orderByLabel.text = "Order by \(getOrder.fullName ?? "")"
        self.foodTitle.text = "\(getOrder.orderDetail?[0].quantity ?? 0)x" + " \(getOrder.orderDetail?[0].title ?? "")"
        
//        if getOrder.orderDetail?[0].imageUrl != "" && getOrder.orderDetail?[0].imageUrl != nil{
//            let url = URL(string: BASE_URL+(getOrder.orderDetail?[0].imageUrl!)!) ?? URL.init(string: "https://www.google.com")!
//            self.truckImage.setImage(url: url)
//        }else{
//            self.truckImage.image = UIImage(named: "Fastfood")
//        }
        
        if getOrder.orderDetail?[0].imageUrl != "" && getOrder.orderDetail?[0].imageUrl != nil{
            if let url = URL(string: getOrder.orderDetail?[0].imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.truckImage.setImage(url: url)
                }
            }
        }else{
            self.truckImage.image = UIImage(named: "Fastfood")
        }

    }
}
