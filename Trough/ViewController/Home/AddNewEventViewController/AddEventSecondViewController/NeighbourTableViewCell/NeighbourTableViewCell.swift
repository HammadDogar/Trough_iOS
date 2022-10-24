//
//  NeighbourTableViewCell.swift
//  Trough
//
//  Created by Imed on 12/10/2021.
//

import UIKit

class NeighbourTableViewCell: UITableViewCell {

    
    @IBOutlet weak var neighbourImage: UIImageView!
    @IBOutlet weak var neighbourNameLabel: UILabel!
    @IBOutlet weak var neighbourAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
