//
//  FriendTableViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 23/12/2020.
//

import UIKit
protocol FriendTableViewCellDelegate:AnyObject {
//    func inviteFriend(index: Int)
}

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var btnInvite: UIButton!
    
    var myData : GetUserViewModel?

    weak var delegate:FriendTableViewCellDelegate?
    var index = -1
    
    var onInvite: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func configure(friend: GetUserViewModel){
    func configure(friend: FriendListViewModel){
        self.nameLabel.text = friend.fullName
        
        
//        if friend.profileUrl != "" && friend.profileUrl != nil{
//            let url = URL(string: BASE_URL+friend.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            DispatchQueue.main.async {
//                self.friendImageView.setImage(url: url)
//            }
//        }else{
//            self.friendImageView.image = UIImage(named: "PlaceHolder2")
//        }
        
        if friend.profileUrl != "" && friend.profileUrl != nil{
            if let url = URL(string: friend.profileUrl   ?? "") {
                DispatchQueue.main.async {
                    self.friendImageView.setImage(url: url)
                }
            }
        }else{
            self.friendImageView.image = UIImage(named: "PlaceHolder2")
        }
        
//        if friend.profileUrl != ""{
//            let url = URL(string: BASE_URL+friend.profileUrl) ?? URL.init(string: "https://www.google.com")!
//            self.friendImageView.setImage(url: url)
//        }else{
//            self.friendImageView.image = UIImage(named: "eventPersonImage2")
//        }
    }
    @IBAction func actionInvite(_ sender: Any){
//        self.delegate?.inviteFriend(index: self.index)
        onInvite?()
    }
    
}
