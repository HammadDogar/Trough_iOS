//
//  UserInvitationsCell.swift
//  Trough
//
//  Created by Mateen Nawaz on 30/08/2022.
//

import UIKit

protocol InvitationBtnDelegate {
    func actionCancelBtn(eventId:Int)
    func actionAcceptBtn(eventId:Int)
//    func actionOpenMap(event:EventViewModel?)
//    func actionInvitationMessage(description:String)

}

class UserInvitationsCell: UITableViewCell {

    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPeople: UILabel!
    
    var index = -1
    var myEvent: EventViewModel?
    
    var eventDescription:String = ""

    var delegate:InvitationBtnDelegate?
    
    var eventId:Int = -1
    
    
    func configure(event: EventViewModel){
        
//        if event.isGoing!{
//            self.acceptAndCancelView.isHidden = true
//        }
//        else{
//            self.acceptAndCancelView.isHidden = false
//        }
        
        self.myEvent = event
        self.eventId = event.eventId!
        self.lblEventTitle.text = "\(event.eventName ?? "")"
        
        //self.eventCreaterNameLabel.text = "\(event.fullName ?? "")"
        
//        let startTime = "\(event.eventSlots?.first?.startTime ?? "") : \(event.eventSlots?.first?.startTime ?? "")".timeConversion12()
//        let endTime = "\(event.eventSlots?.first?.endTime ?? "") : \(event.eventSlots?.first?.endTime ?? "")".timeConversion12()
//
//        self.lblTime.text = "\(startTime) - \(endTime)"
        
        let startTime = event.eventSlots?.first?.startTime?.timeConversion12()
        let endTime = event.eventSlots?.first?.endTime?.timeConversion12()
        
        self.lblTime.text = "\(startTime ?? "") - \(endTime ?? "")"
        
        
        let eventStartDate = event.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        self.lblDate.text = "\(eventStartDate?.string(with: .custom("dd MMMM yyyy")) ?? "No Date Found")"
        self.lblCity.text = "\(event.locationName ?? "")"
        self.eventDescription = "\(event.description ?? "")"
        self.lblPeople.text = "\(event.peopleComing ?? 0)"
        
        
    }
        

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionAccept(_ sender: Any) {
        delegate?.actionAcceptBtn(eventId: self.eventId)

    }
    
    

}
