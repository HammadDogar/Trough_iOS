//
//  PaymentMethodTableViewCell.swift
//  Resi
//
//  Created by Zuhaib  Imtiaz on 4/3/21.
//

import UIKit



class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var cardTypeImageView:UIImageView!
    @IBOutlet weak var selectedImageView:UIImageView!
    @IBOutlet weak var cardNumberLabel:UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
