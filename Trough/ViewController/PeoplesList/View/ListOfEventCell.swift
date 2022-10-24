//
//  ListOfEventCell.swift
//  Trough
//
//  Created by Mateen Nawaz on 02/09/2022.
//

import UIKit

class ListOfEventCell: UITableViewCell {

    @IBOutlet weak var EventListLabel: UILabel!
    
    var onSelect: (() -> Void)?
    var onSelectTruck: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionFriend(sender : UIButton){
        onSelect?()
    }
    
    @IBAction func actionTruck(sender : UIButton){
        onSelectTruck?()
    }

}
