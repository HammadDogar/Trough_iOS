//
//  ConfirmPaymentTableViewCell.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import UIKit

class ConfirmPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var menuName: UILabel!
    
    
    var userCart : GetCartDetails?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func cartlist(cart : GetCartDetails){
        self.userCart = cart
        
        self.totalCount.text = "\(cart.quantity ?? 0)"
        self.totalPrice.text = "$ \(cart.price ?? 0)"
        self.menuName.text = "\(cart.title ?? "")"
    }

}
