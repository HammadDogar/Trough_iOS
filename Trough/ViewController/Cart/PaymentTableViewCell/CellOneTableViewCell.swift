//
//  CellOneTableViewCell.swift
//  Trough
//
//  Created by Imed on 06/04/2021.
//

import UIKit

class CellOneTableViewCell: UITableViewCell {

    
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
