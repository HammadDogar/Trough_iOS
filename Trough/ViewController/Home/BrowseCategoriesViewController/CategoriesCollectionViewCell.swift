//
//  CategoriesCollectionViewCell.swift
//  Trough
//
//  Created by Imed on 15/09/2021.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet  var imageView : UIImageView?
    @IBOutlet weak var nameLabel: UILabel!
    
    var categories : CategoriesViewModel?

    func configure(getCategories : CategoriesViewModel){
        self.categories = getCategories
        self.nameLabel.text = "\(getCategories.name ?? "")"
        
//        if getCategories.imageUrl != "" && getCategories.imageUrl != nil{
//            let url = URL(string: BASE_URL+getCategories.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.imageView?.setImage(url: url)
//        }else{
//            self.imageView!.image = UIImage(named: "PlaceHolder2")
//        }
        
        if getCategories.imageUrl != "" && getCategories.imageUrl != nil{
            if let url = URL(string: getCategories.imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.imageView?.setImage(url: url)
                }
            }
        }else{
            self.imageView!.image = UIImage(named: "PlaceHolder2")
        }
        
    }
    
}
