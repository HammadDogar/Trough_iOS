//
//  TruckMenuTableViewCell.swift
//  Trough
//
//  Created by Macbook on 30/03/2021.
//

import UIKit

protocol AddToCartBtnClickDelegate {
//    func actionAddToCartBtn(menu:MenuCategoryViewModel)
    func actionAddtoCartBtn(menu: MenuCategoryViewModel,eventTruckID: NearbyTrucksViewModel, eventId: EventViewModel)
    
}

class TruckMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishDesLabel: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    
    var delegate : AddToCartBtnClickDelegate?
    
    var menu : MenuCategoryViewModel?
    var event : EventViewModel?
    var eventTruck : NearbyTrucksViewModel?
    
//    var nearTrucks : NearbyTrucksViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUpData(dish: MenuCategoryViewModel){
        
        menu = dish
        
//        if dish.imageUrl != "" && dish.imageUrl != nil{
//            let url = URL(string: BASE_URL+dish.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.dishImage.setImage(url: url)
//        }else{
//            self.dishImage.image = UIImage(named: "PlaceHolder2")
//        }
        
        if dish.imageUrl != "" && dish.imageUrl != nil{
            if let url = URL(string: dish.imageUrl! ) {
                DispatchQueue.main.async {
                    self.dishImage.setImage(url: url)
                }
            }
        }else{
            self.dishImage.image = UIImage(named: "PlaceHolder2")
        }
        
        dishNameLabel.text = dish.title
        dishDesLabel.text = dish.description
        dishPrice.text = String(dish.price!)
    }
    
    
    @IBAction func actionAddToCart(_ sender: UIButton) {
//        delegate?.actionAddToCartBtn(menu: menu!)
        delegate?.actionAddtoCartBtn(menu: menu!, eventTruckID: eventTruck ?? NearbyTrucksViewModel(), eventId: event ?? EventViewModel())
    }
}


