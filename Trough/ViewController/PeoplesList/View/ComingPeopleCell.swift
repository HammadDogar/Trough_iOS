//
//  ComingPeopleCell.swift
//  Trough
//
//  Created by Mateen Nawaz on 02/09/2022.
//

import UIKit

class ComingPeopleCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var comingImageView: UIImageView!
    @IBOutlet weak var statusLabel: UIImageView!
    
    var myData : ComingPeopleModel?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(getDta : ComingPeopleModel){
        self.myData = getDta
       
        self.userNameLabel.text = "\(getDta.fullName ?? "")"
        
//        if getDta.profilePicture != "" && getDta.profilePicture != nil{
//            let url = URL(string: BASE_URL+(getDta.profilePicture)!) ?? URL.init(string: "https://www.google.com")!
//            self.comingImageView.setImage(url: url)
//        }else{
//            self.comingImageView.image = UIImage(named: "Fastfood")
//        }
        
        if getDta.profilePicture != "" && getDta.profilePicture != nil{
            if let url = URL(string: getDta.profilePicture ?? "") {
                DispatchQueue.main.async {
                    self.comingImageView.setImage(url: url)
                }
            }
        }else{
            self.comingImageView.image = UIImage(named: "Fastfood")
        }
        
        
        
        if getDta.pending == true{
            self.statusLabel.image = UIImage(named: "g1")
        }
        else if getDta.accepted == true{
            self.statusLabel.image = UIImage(named: "g3")
        }
    }

}
