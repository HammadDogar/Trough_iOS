//
//  NewCartTableViewCell.swift
//  Trough
//
//  Created by Imed on 08/07/2021.
//

import UIKit

protocol CartItemDelegate : AnyObject {
    func removeFromCartButton(id : Int)
}

class NewCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var priceName: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    var cartList : GetCartDetails?
    var delegate : CartItemDelegate?
    var onClick: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(getCart : GetCartDetails){
        self.cartList = getCart
        self.menuName.text = "\(getCart.title ?? "")"
        self.priceName.text = "$ \(getCart.price ?? 0)"
        self.quantityLabel.text = " \( getCart.quantity ?? 0)"
    }
    
    
    @IBAction func actionRemoveCartItem(_ sender: UIButton) {
//        self.delegate?.removeFromCartButton(id: cartList?.id ?? 0)
        onClick?()
    }
}
