//
//  TruckMenuDetailViewController.swift
//  Trough
//
//  Created by Imed on 08/04/2021.
//

import UIKit
import Kingfisher

protocol MenuDetialDelegate {
    func didTapCartButton(tapped : Bool)
}

class TruckMenuDetailViewController: UIViewController {
    
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuName: UITextField!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIStackView!
    
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var minusBackGroundView: UIStackView!
    @IBOutlet weak var plusBackGroundView: UIStackView!
    
    var menu: MenuCategoryViewModel?
    var event :EventViewModel?
    var cart = AddtoCartViewModel()
    var addCart = [AddtoCartViewModel]()
    
    var id = 0
    var evntId = 0
    
    var truckID = 0
    var delegate : MenuDetialDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        getUserCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setData(){
        
//        self.menuImage.kf.setImage(with: URL(string: BASE_URL + (menu?.imageUrl!)!))
        
        if menu?.imageUrl != "" && menu?.imageUrl != nil{
            if let url = URL(string: menu?.imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.menuImage.setImage(url: url)
                }
            }
        }else{}
        
        self.menuName.text = menu?.title!
        self.descriptionView.text = menu?.description!
//        self.lblPrice.text = String((menu?.price!)!)
        self.lblPrice.text = "$ \(menu?.price ?? 0)"
        
//        "$ \(getCart.price ?? 0)"
        
    }
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
        delegate?.didTapCartButton(tapped: true)
        
//        if currentTruckID == previousTrcukid{
//            self.moveToCart()
//        }
//        else if currentTruckID != previousTrcukid{
        
//            let alert = UIAlertController(title: "Waring: item selected from different truck", message: "Previous item in cart will be removed", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
//            }))
//            self.present(alert, animated: true, completion: nil)
        
//        }
        
        if self.id == self.truckID{
            self.moveToCart()
        }
        else{
            let refreshAlert = UIAlertController(title: "Truck was changed", message: "Item will be removed if you select this item.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                self.moveToCart()

            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
        
//        self.moveToCart()
        
    }
    
    @IBAction func actionBtnPlus(_ sender: UIButton) {
        let quantity = Int(self.lblQuantity.text!)
        let price = Int(self.lblPrice.text!)
        self.lblQuantity.text = String(quantity! + 1)
        self.lblPrice.text = String(price ?? 0 * 2  )
//        self.minusButton.backgroundColor = #colorLiteral(red: 0.9511117339, green: 0.7289424539, blue:4 0.2410626411, alpha: 1)
//        self.addToCart.backgroundColor = #colorLiteral(red: 0.9511117339, green: 0.7289424539, blue: 0.2410626411, alpha: 1)
//        self.addto.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @IBAction func actionBtnMinus(_ sender: UIButton) {
        let quantity = Int(self.lblQuantity.text!)
        if quantity != 1 {
            self.lblQuantity.text = String(quantity! - 1)
//            self.minusButton.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            //            self.minusButton.backgroundColor = #colorLiteral(red: 0.9511117339, green: 0.7289424539, blue: 0.2410626411, alpha: 1)
        }
    }
}

extension TruckMenuDetailViewController {
    
    //    func cartDetailsDictionary() -> [[String:Any]] {
    //        var dict = [[String:Any]]()
    ////        self.cart.cartDetails?.forEach({ (cart) in
    //        self.menu?.categoryId?.forEach({ (cart) in
    //            dict.append(cart.toDictionary())
    //        })
    //        return dict
    //    }
    
    func moveToCart(){
        var params: [String:Any] = [String:Any]()
        if (event != nil){

            var cartD = CartDetails()
            cartD.categoryId = menu?.categoryId ?? 0
            cartD.quantity = Int(self.lblQuantity.text!)
            var cartParams = [[String:Any]]()
            cartParams.append(cartD.toDictionary())
            params = (["truckId" : id,
                       "eventId" : evntId,
                       "isConfirmToRemoveOtherCartItems" : true,
                       "cartDetails" : cartParams
                       //                    cartDetailsDictionary()
            ])
            as [String : Any]
        }else{
            var cartD = CartDetails()
            cartD.categoryId = menu?.categoryId ?? 0
            cartD.quantity = Int(self.lblQuantity.text!)
            var cartParams = [[String:Any]]()
            cartParams.append(cartD.toDictionary())
            params = (["truckId" : id,
                       "isConfirmToRemoveOtherCartItems" : true,
                       "cartDetails" : cartParams
                       //                    cartDetailsDictionary()
            ])
            as [String : Any]
        }
        
//        var params: [String:Any] = [String:Any]()
//        var cartD = CartDetails()
//        cartD.categoryId = menu?.categoryId ?? 0
//        cartD.quantity = Int(self.lblQuantity.text!)
//        var cartParams = [[String:Any]]()
//        cartParams.append(cartD.toDictionary())
//        params = (["truckId" : id,
//                   "eventId" : evntId,
//                   "isConfirmToRemoveOtherCartItems" : true,
//                   "cartDetails" : cartParams
//                   //                    cartDetailsDictionary()
//
//        ])
//
//        as [String : Any]
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.AddToCart(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data as? Bool{
                            if data == true{
                                let alert = UIAlertController(title: "Success", message: "Added To Cart", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(alert, animated: true, completion: nil)
//                                self.navigationController?.popViewController(animated: true)
                            }
                            print("Done")
                        }
                        else {
                            print("Error Not added.....")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error Not added----")
                    }
                default :
                    GCD.async(.Main) {
                        print("Error Not added")
                    }
                }
            }
        }
    }
}

extension TruckMenuDetailViewController{
    
    func getUserCart(){
        
        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]
        
        let service = UserServices()
        GCD.async(.Main) {
            
        }
        GCD.async(.Default) {
            
            service.UserCart(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
                        
                        if let cartList = serviceResponse.data as? GetUserCartViewModel {
                            if cartList.cartDetails?.count != 0 {
                                self.truckID = cartList.truckId
//                                print(self.truckID)
                            }
                        }
                        
                        else {
                            print("No Item Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Item Found!!!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Item Found!!")
                    }
                }
            }
        }
    }
}
