//
//  FavouriteLocationTableViewCell.swift
//  Trough
//
//  Created by Macbook on 13/04/2021.
//

import UIKit

class FavouriteLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
