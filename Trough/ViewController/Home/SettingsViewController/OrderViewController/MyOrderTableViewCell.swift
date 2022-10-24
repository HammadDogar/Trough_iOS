//
//  MyOrderTableViewCell.swift
//  Trough
//
//  Created by Imed on 02/04/2021.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TruckNameLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!

    var myOrder : GetOrderByUserModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(getOrder : GetOrderByUserModel){
        self.myOrder = getOrder
        self.TruckNameLabel.text = "\(getOrder.fullName ?? "")"
        self.deliveryAddressLabel.text = "\(getOrder.deliveryAddress ?? "")"
        self.totalPrice.text = "$ \(getOrder.totalAmount ?? 0)"
    }
    
    
//
//    func setData(dish: MyOrder){
//        dishImage.image = UIImage(named: dish.image)
//        dishNameLabel.text = dish.name
//        dishNumberLabel.text = dish.number
//        dishPrice.text = "\(dish.price)"
//    }

}
//
//struct MyOrder {
//    let image: String
//    let name: String
//    let number: String
//    let price: Double
//}
