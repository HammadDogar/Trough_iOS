//
//  ComingTruckCell.swift
//  Trough
//
//  Created by Mateen Nawaz on 02/09/2022.
//

import UIKit

class ComingTruckCell: UITableViewCell {
    
    @IBOutlet weak var truckImageView: UIImageView!
    @IBOutlet weak var stausLabel: UIImageView!
    @IBOutlet weak var userNameLAbel: UILabel!
    
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
        self.userNameLAbel.text = "\(getDta.fullName ?? "")"
        
        
//        if getDta.profilePicture != "" && getDta.profilePicture != nil{
//            let url = URL(string: BASE_URL+(getDta.profilePicture)!) ?? URL.init(string: "https://www.google.com")!
//            self.truckImageView.setImage(url: url)
//        }else{
//            self.truckImageView.image = UIImage(named: "Fastfood")
//        }
//
        
        if getDta.profilePicture != "" && getDta.profilePicture != nil{
            if let url = URL(string: getDta.profilePicture ?? "") {
                DispatchQueue.main.async {
                    self.truckImageView.setImage(url: url)
                }
            }
        }else{
            self.truckImageView.image = UIImage(named: "Fastfood")
        }
        
        
        if getDta.pending == true{
            self.stausLabel.image = UIImage(named: "g1")
        }
        else if getDta.accepted == true{
            self.stausLabel.image = UIImage(named: "g3")
        }
        else if getDta.rejected == true{
            self.stausLabel.image = UIImage(named: "g2")
        }
        
    }

}
