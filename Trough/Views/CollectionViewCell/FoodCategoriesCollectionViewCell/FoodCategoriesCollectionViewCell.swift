//
//  FoodCategoriesCollectionViewCell.swift
//  Trough
//
//  Created on 05/01/2021.
//

import UIKit
protocol FoodCategoriesCollectionViewCellDelegate:AnyObject {
    func selectFood(index: Int)
}

class FoodCategoriesCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var btnCategory:UIButton!
    @IBOutlet weak var foodLabel: UILabel!
    var index = -1
    var onClick: (()->())?
    
    weak var delegate: FoodCategoriesCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionSelectFoodCategory(_ sender: Any){
//        self.delegate?.selectFood(index: Global.shared.foodCategoriesList[self.index].categoryID!)
        onClick?()
    }
    
    func config(category: String){
        self.btnCategory.setTitle(" \(category)", for: .normal)
    }

}
