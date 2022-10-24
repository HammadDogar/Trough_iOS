//
//  NotificationsTableViewCell.swift
//  traf
//
//  Created by Mateen Nawaz on 05/01/2021.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationStatusLabel: UILabel!
    @IBOutlet weak var notifictionTitleLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var notificationContentLabel: UILabel!

    var mynotification : NotificationViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(notification: NotificationViewModel){

        self.mynotification = notification
        let notificationcreateDateWithTime = notification.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .TIME_FORMAT) ?? ""
        self.notificationStatusLabel.isHidden = true
        self.notifictionTitleLabel.text = "\(notification.notificationTitle ?? "")"
        self.notificationContentLabel.text = "\(notification.notificationBody ?? "")"
        self.notificationTimeLabel.text = "\(notificationcreateDateWithTime )" //"\(notification.createdDate)"

    }
    
}
