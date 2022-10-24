//
//  FriendListTableViewCell.swift
//  Trough
//
//  Created by Imed on 08/04/2021.
//

import UIKit
import Kingfisher

class FriendListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func config(list:FriendListViewModel){
        
        self.friendName.text = list.fullName!
//        if list.profileUrl != "" && list.profileUrl != nil{
//            let url = URL(string: BASE_URL+list.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            print(url)
//            self.friendImage.setImage(url: url)
//        }else{
//            
//        }
//        if list.profileUrl != "" && list.profileUrl != nil{
//            let url = URL(string: BASE_URL+list.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//
//            DispatchQueue.main.async {
//                self.friendImage.setImage(url: url)
//            }
//        }else{
//            self.friendImage.image = UIImage(named: "personFilled")
//        }
        
        if list.profileUrl != "" && list.profileUrl != nil{
            if let url = URL(string: list.profileUrl  ?? "") {
                DispatchQueue.main.async {
                    self.friendImage.setImage(url: url)
                }
            }
        }else{
            self.friendImage.image = UIImage(named: "personFilled")
        }
        
    }

}
