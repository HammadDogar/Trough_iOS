//
//  SettingsTableViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 06/01/2021.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
