//
//  FriendRequestCell.swift
//  Trough
//
//  Created by Mateen Nawaz on 29/08/2022.
//

import UIKit
protocol FriendRequestDelegate {
    func actionAcceptBtn(userRequestID:Int)
    func actionRejectBtn(userRequestID:Int)
}


class FriendRequestCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    var index = -1
    var userRequestID = -1
    
    var delegate: FriendRequestDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(list:FriendListViewModel){
        
        self.userRequestID = list.userId!
        self.userName.text = list.fullName!
        
//        if list.profileUrl != "" && list.profileUrl != nil{
//            let url = URL(string: BASE_URL+list.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            print(url)
//            self.userImage.setImage(url: url)
//        }else{}
        
        if list.profileUrl != "" && list.profileUrl != nil{
            if let url = URL(string: list.profileUrl  ?? "") {
                DispatchQueue.main.async {
                    self.userImage.setImage(url: url)
                }
            }
        }else{}
        
        
    }
    @IBAction func actionAccept(_ sender: Any) {
        print("accept button was preesed")
        delegate?.actionAcceptBtn(userRequestID: self.userRequestID)
    }
    @IBAction func actionReject(_ sender: Any) {
        print("reject button was preesed")
        delegate?.actionRejectBtn(userRequestID: self.userRequestID)
    }
    
}
