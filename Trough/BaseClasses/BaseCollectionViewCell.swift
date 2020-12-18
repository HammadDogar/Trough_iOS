//
//  BaseCollectionViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import UIKit
import SDWebImage

class BaseCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    func setImage(imageView:UIImageView,url:URL)  {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageIndicator?.startAnimatingIndicator()
        
        imageView.sd_setImage(with: url) { (img, err, cahce, URI) in
            imageView.sd_imageIndicator?.stopAnimatingIndicator()
            if err == nil{
                imageView.image = img
            }else{
                imageView.image = UIImage(named: "Dummy")
            }
            
            
        }
    }
}
