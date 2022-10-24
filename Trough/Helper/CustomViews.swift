//
//  CustomViews.swift
//  Trough
//
//  Created by Macbook on 17/03/2021.
//

import UIKit

class customCellView1 : UIView {
   override func awakeFromNib() {
       super.awakeFromNib()
        
       //self.layer.cornerRadius = 15
        
       self.layer.shadowRadius = 2
       self.layer.shadowOpacity = 0.5
       self.layer.shadowColor = UIColor.lightGray.cgColor
       self.layer.shadowOffset = CGSize(width: 0, height: 2)
    
    self.layer.borderWidth = 0.5
    self.layer.borderColor = UIColor.black.cgColor
        
    }
    
}
