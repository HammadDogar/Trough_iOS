//
//  FirstTableViewCell.swift
//  Trough
//
//  Created by Imed on 05/04/2021.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var esstimatedTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
