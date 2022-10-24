//
//  NearByCollectionViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 21/12/2020.
//

import UIKit

class NearByCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var truckImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(bannerUrl: String){
//        print(BASE_URL)
        if bannerUrl == "https://troughapi.azurewebsites.net"{
            self.truckImageView.image = UIImage(named: "PlaceHolder2")
        }
        else{
            let url = URL.init(string: bannerUrl)
            self.truckImageView.setImage(url: url!)
        }
    }
}
