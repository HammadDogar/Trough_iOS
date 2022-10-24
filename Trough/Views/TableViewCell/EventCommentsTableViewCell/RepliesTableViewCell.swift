//
//  CommentsTableViewCell.swift
//  traf
//
//  Created by Mateen Nawaz on 13/01/2021.
//

import UIKit

class RepliesTableViewCell: UITableViewCell {

    

    @IBOutlet weak var commentPersonImageView: UIImageView!
    @IBOutlet weak var replyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
