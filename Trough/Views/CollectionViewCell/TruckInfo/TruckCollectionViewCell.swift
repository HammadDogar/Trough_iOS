//
//  TruckCollectionViewCell.swift
//  Trough
//
//  Created by Imed on 21/06/2021.
//

import UIKit

class TruckCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var truckName: UILabel!
    @IBOutlet weak var truckImage: UIImageView!
    
    var indexPath: IndexPath? //<- Hold indexPath as an instance property    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(bannerUrl: String){
        
        print(BASE_URL)
        if bannerUrl == "https://troughapi.azurewebsites.net"{
            self.truckImage.image = UIImage(named: "truck1")
        }
        else{
            let url = URL.init(string: bannerUrl)
            self.truckImage.setImage(url: url!)
        }
    }
    
}
