//
//  User-OrderViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 29/08/2022.
//

import UIKit

class User_OrderViewController: BaseViewController {

    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var orders = [GetOrderByTruckModel]()
    var orderByTruckList = GetOrderByTruckModel()
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noResultLabel.isHidden = true
        self.getOrderList()
        self.tableView.reloadData()
    }
    

}


extension User_OrderViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orders.count > 0{
            self.noResultLabel.isHidden = true
            return self.orders.count
        }
        else{
            self.noResultLabel.isHidden = false
        }
        return orders.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User_OrderTableViewCell", for: indexPath) as! User_OrderTableViewCell
        let item = self.orders[indexPath.row]
        cell.configure(getOrder: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "User_Order_DetialViewController") as! User_Order_DetialViewController
        let order = self.orders[indexPath.row]
        vc.order = order
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension User_OrderViewController{
    
    func getOrderList(){
        
        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]
        
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            
            service.GetOrderByUserTwo(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
                        
                        if let orderList = serviceResponse.data as? [GetOrderByTruckModel] {
                            //                            print(orderList)
                            self.orders = orderList
                            self.tableView.reloadData()
                            print("list found")
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
