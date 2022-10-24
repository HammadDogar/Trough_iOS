//
//  NewCartViewController.swift
//  Trough
//
//  Created by Imed on 07/07/2021.
//

import UIKit

protocol CartViewDelgate {
    func didTapButton(cartID : [GetCartDetails])
}

class NewCartViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var totalPricelabel: UILabel!
    @IBOutlet weak var truckNameLabel: UILabel!
    @IBOutlet weak var comfirmPaymentButton: UIButton!
    
    var buttonTag = 0
    
    var cartMenu = [GetCartDetails]()
    var cartList : [GetCartDetails]?
    
    var userCartList = [GetUserCartViewModel]()
    
    var id = 0
    var evntId = 0

    var delagte  : CartViewDelgate?
    
    var event :EventViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        getUserCart()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.sizeToFit()
    }
    
    func getUserCart(){
        
        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]
        
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            
            service.UserCart(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
                        
                        if let cartList = serviceResponse.data as? GetUserCartViewModel {
                            print(cartList)
                            
                            if cartList.cartDetails?.count != 0 {
                                self.cartMenu = cartList.cartDetails!
                                self.truckNameLabel.text = cartList.fullName
                                
                            }
                            
                            var price = 0
                            for i in 0...self.cartMenu.count - 1 {
                                price += self.cartMenu[i].price!
                            }
                            self.totalPricelabel.text = "$ \(price)"
                            
                            self.tableView.reloadData()
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
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func moveToPaymentButton(_ sender: UIButton) {
        
        delagte?.didTapButton(cartID: self.cartMenu)
        
        print("wrt")
        dismiss(animated: true, completion: nil)
//        let sb = UIStoryboard(name: "Cart", bundle: nil)
//        if #available(iOS 13.0, *) {
//            let vc = sb.instantiateViewController(identifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
//            vc.cart = self.cartMenu
//
//            vc.id = self.id
//            vc.evntId = self.evntId
//            print(vc.id)
//            print(vc.evntId)
//
////            print(vc.cart)
////            present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController( vc, animated: true)
//        } else {
//            // Fallback on earlier versions
//        }
    }
}

extension NewCartViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCartCell", for: indexPath) as! NewCartTableViewCell
        let item = self.cartMenu[indexPath.row]
        cell.configure(getCart: item)
//        cell.removeItemButton.tag = cartMenu[indexPath.row].id ?? 0
//        let cartID = cell.removeItemButton.tag
//        self.buttonTag = cartID
//        cell.removeItemButton.addTarget(self, action: #selector(cellRemoveItenButtonTapped(sender:)), for: .touchUpInside)
        self.buttonTag = cartMenu[indexPath.row].id ?? 0
        print(self.buttonTag)
        cell.onClick = {
            self.removeCartItem()
        }
        return cell
    }
    
//    @objc
//    func cellRemoveItenButtonTapped(sender : UIButton)
//    {
//        print(sender.tag)
//        self.removeCartItem()
//    }
}

extension NewCartViewController {
    
    func removeCartItem(){
        print(buttonTag)
        let params:[String:Any] = [
            "id" : buttonTag
        ]
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.removeCartItem(params: params, id: self.buttonTag) { (serviceResponse) in
                GCD.async(.Main) {}
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        self.getUserCart()
                        print("Success")
//                        self.dismiss(animated: true, completion: nil)
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: serviceResponse.message)
                    }
                }
            }
        }
    }
}

//extension NewCartViewController : CartItemDelegate{
//    func removeFromCartButton(id: Int) {
//
//        let item = self.cartList?[id] ?? GetCartDetails.init()
//        self.removeCartItem(id:item.id ?? 0)
//    }
    
    

