//
//  User_Order_SummaryCell.swift
//  Trough
//
//  Created by Mateen Nawaz on 29/08/2022.
//

import UIKit

class User_Order_SummaryCell: UITableViewCell {
    
    @IBOutlet weak var usertotatquantity: UILabel!
    @IBOutlet weak var usermenuName: UILabel!
    @IBOutlet weak var usertotalPrice: UILabel!

    var userOrder : GetOrderByTruckModelDetail?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func orderDetial(orders : GetOrderByTruckModelDetail){
        self.userOrder = orders
        self.usertotatquantity.text = "\(orders.quantity ?? 0)x"
        self.usermenuName.text = "\(orders.title ?? "")"
        self.usertotalPrice.text = "$ \(orders.price ?? 0)"
    }
    

}
