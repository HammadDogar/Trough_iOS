//
//  MyOrderViewController.swift
//  Trough
//
//  Created by Imed on 02/04/2021.
//

import UIKit

class MyOrderViewController: BaseViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    var userOrders = [GetOrderByUserModel]()
//    var orderByUserList = GetOrderByUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderList()
    }
    @IBAction func actionMyOrder(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension MyOrderViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyOrderTableViewCell
                let item = self.userOrders[indexPath.row]
                cell.configure(getOrder: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                if #available(iOS 13.0, *) {
                    let vc = sb.instantiateViewController(identifier: "OrderSummaryViewController") as! OrderSummaryViewController
                    let order = self.userOrders[indexPath.row]
                    vc.order = order
        
                    self.navigationController?.pushViewController( vc, animated: true)
                } else {
                    // Fallback on earlier versions
                }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension MyOrderViewController {
    
    func getOrderList(){
        
        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]
        
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            
            service.GetOrderByUser(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
                        
                        if let orderList = serviceResponse.data as? [GetOrderByUserModel] {
//                            print(orderList)
                            self.userOrders = orderList

                            
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
