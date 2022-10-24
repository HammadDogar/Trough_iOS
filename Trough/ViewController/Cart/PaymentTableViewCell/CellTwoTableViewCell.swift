//
//  CellTwoTableViewCell.swift
//  Trough
//
//  Created by Imed on 06/04/2021.
//

import UIKit

class CellTwoTableViewCell: UITableViewCell {

    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}
