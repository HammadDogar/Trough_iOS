//
//  SecondTableViewCell.swift
//  Trough
//
//  Created by Imed on 05/04/2021.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    
    @IBOutlet weak var totakNumber: UILabel!
    @IBOutlet weak var dealName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var dealImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
