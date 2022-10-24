//
//  SeeReplyTableViewCell.swift
//  traf
//
//  Created by Mateen Nawaz on 13/01/2021.
//

import UIKit
protocol SeeReplyTableViewCellDelegate {
    func seeMorePressed(index:Int)
}

class SeeReplyTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var seeButton : UIButton!
    
    var index = -1
    var delegate: SeeReplyTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionSeeMore(_ sender: Any){
        self.delegate?.seeMorePressed(index: self.index)
    }
}

