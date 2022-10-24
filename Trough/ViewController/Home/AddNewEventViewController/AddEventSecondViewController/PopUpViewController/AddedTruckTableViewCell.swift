//
//  AddedTruckTableViewCell.swift
//  Trough
//
//  Created by Imed on 12/10/2021.
//

import UIKit

class AddedTruckTableViewCell: UITableViewCell {

    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var truckNameLabel: UILabel!
    @IBOutlet weak var truckAddessLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
