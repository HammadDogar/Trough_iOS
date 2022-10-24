//
//  OrderSummaryTableViewCell.swift
//  Trough
//
//  Created by Imed on 28/07/2021.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var totatquantity: UILabel!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
//    var orderDetial : GetOrderByUserModel?
    var userOrder : GetOrderByUserModelDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func orderDetial(orders : GetOrderByUserModelDetail){
        self.userOrder = orders
        
        self.totatquantity.text = "\(orders.quantity ?? 0)"
        self.totalPrice.text = "\(orders.price ?? 0)"
        self.menuName.text = "\(orders.title ?? "")"
    }
    
}
