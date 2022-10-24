//
//  TruckInviteTableViewCell.swift
//  Trough
//
//  Created by Imed on 17/05/2021.
//

import UIKit

class AddingTruckTableViewCell: UITableViewCell {

    var eventId:Int = -1
    var index = -1
    var myEvent: EventViewModel?
//    weak var delegate: EventTableViewCellDelegate?
    weak var delegate: NearByTableViewCellDelegate?
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventCreaterNameLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var eventImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configure(event: EventViewModel){
        
        self.eventId = event.eventId ?? -1
        
        self.myEvent = event
        
        
        self.eventTitleLabel.text = "\(event.eventName ?? "")"
        self.eventCreaterNameLabel.text = "\(event.fullName ?? "")"
        
        let startTime = event.eventSlots?.first?.startTime?.timeConversion12()
        let endTime = event.eventSlots?.first?.endTime?.timeConversion12()

        self.eventTimeLabel.text = "\(startTime ?? "") - \(endTime ?? "")"
        let eventStartDate = event.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        self.eventDateLabel.text = "\(eventStartDate?.string(with: .custom("dd MMMM yyyy")) ?? "")"
        self.eventLocationLabel.text = "\(event.locationName ?? "")"
        
//         if event.imageUrl != "" && event.imageUrl != nil{
//             let url = URL(string: BASE_URL+event.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//             self.eventImageView.setImage(url: url)
//         }else{
//             self.eventImageView.image = UIImage(named: "PlaceHolder2")
//         }
        
        if event.imageUrl != "" && event.imageUrl != nil{
            if let url = URL(string: event.imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.eventImageView.setImage(url: url)
                }
            }
        }else{
            self.eventImageView!.image = UIImage(named: "PlaceHolder2")
        }
        
        
    }
    
    @IBAction func actioninviteBtn(_ sender: UIButton)
    {
        delegate?.actionAddInivite(eventId: self.eventId, trucksId: "", isInviting: true)

    }
    
}
