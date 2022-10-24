//
//  User_PRE_Order_SummaryCell.swift
//  Trough
//
//  Created by Mateen Nawaz on 01/09/2022.
//

import UIKit

class User_PRE_Order_SummaryCell: UITableViewCell {

    @IBOutlet weak var pretotatquantity: UILabel!
    @IBOutlet weak var pretotalPrice: UILabel!
    @IBOutlet weak var preOrderMenuName: UILabel!
    
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
        self.pretotatquantity.text = "\(orders.quantity ?? 0)x"
        self.preOrderMenuName.text = "\(orders.title ?? "")"
        self.pretotalPrice.text = "$ \(orders.price ?? 0)"
    }
    

}
