//
//  UserInvitationDetailCell.swift
//  Trough
//
//  Created by Mateen Nawaz on 30/08/2022.
//

import UIKit

class UserInvitationDetailCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblEventDateAndTime: UILabel!
    @IBOutlet weak var lblEventFullName: UILabel!
    @IBOutlet weak var lblEventLocation: UILabel!
    @IBOutlet weak var lblEventTotalPerson: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventDes: UILabel!
    
    
    var lat:Double?
    var long:Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
