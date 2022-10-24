//
//  NotificationsViewController.swift
//  Trough
//
//  Created by Irfan Malik on 05/01/2021.
//

import UIKit

class NotificationsViewController: BaseViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var notifications = [NotificationViewModel]()
    
    var notify : NotificationViewModel?
    
    var id = 0
    var orderID = 0
    var preOrderID = 0
    var isInvite = false
    
//    var eventList = [EventViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.config()
        self.getNotificationList()
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
       if BReachability.isConnectedToNetwork(){
        self.getNotificationList()

       }else{
           
        self.simpleAlert(title: "Alert", msg: "Please check Your Internet Connection")
        self.refreshControl.endRefreshing()
       }
    }

    
    func config(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        
    }

    
    func getNotificationList(){

        var params: [String:Any] = [String:Any]()
        params = [
                "take" : 50
        ] as [String : Any]

        let service = Notifications()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
          
        }
        GCD.async(.Default) {
            service.notificatons(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.refreshControl.endRefreshing()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let notificationList = serviceResponse.data as? [NotificationViewModel] {
                            self.notifications = notificationList
                            print(notificationList)
                            let sortedNotififactionByDate = self.notifications.sorted { (date1, date2) -> Bool in
                                date1.createdDate! > date2.createdDate!
                             }
                            
                            
                            self.notifications = sortedNotififactionByDate
                            
                            self.tableView.reloadData()
                    }
                    else {
                        print("No Notification Found!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Notification Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Notification Found!")
                    }
                }
            }
        }
    }
}


extension NotificationsViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
//        return self.notifi.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        cell.selectionStyle = .none
        let item = self.notifications[indexPath.row]
        cell.configure(notification: item)
        
        
//        let not =  notifi[indexPath.row]
//        cell.configure(notification: not)
        
        
        //cell.configureWithItem(item: dataArray[indexPath.item])

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.notifications[indexPath.row].isFriendRequest == true &&  self.notifications[indexPath.row].redirectionId != 0{
            print("---- to friends request")
            let sb = UIStoryboard(name: "Settings", bundle: nil)
            if #available(iOS 13.0, *) {
                let vc = sb.instantiateViewController(identifier: "FriendsViewController") as! FriendsViewController
                self.navigationController?.pushViewController( vc, animated: true)
            } else {
                // Fallback on earlier versions
            }
        }
        
        else if self.notifications[indexPath.row].redirectionId != 0 {
            print("---- to event details")
            let eventid = self.notifications[indexPath.row].redirectionId ?? 0
            self.id = eventid
            self.getEventsListing()
        }
        
        else if  self.notifications[indexPath.row].preOrderId != 0  {
            print("----  to pre order details")
            let order = self.notifications[indexPath.row].preOrderId ?? 0
            self.preOrderID = order
            self.getPreOrderList()
        }
        
        else if self.notifications[indexPath.row].orderId != 0 {
            print("---- to order details")
            let order = self.notifications[indexPath.row].orderId ?? 0
            self.orderID = order
            self.getOrderList()
        }
        
//        else if self.notifications[indexPath.row].isFriendRequest == true &&  self.notifications[indexPath.row].redirectionId != 0{
//            print("---- to friends request")
//            let sb = UIStoryboard(name: "Settings", bundle: nil)
//            if #available(iOS 13.0, *) {
//                let vc = sb.instantiateViewController(identifier: "FriendRequestViewController") as! FriendRequestViewController
//                self.navigationController?.pushViewController( vc, animated: true)
//            } else {
//                // Fallback on earlier versions
//            }
//        }
        
        
//        else if  self.notifications[indexPath.row].preOrderId != 0 && self.notifications[indexPath.row].isReadyPickUp == true  {
//            print("----  to pre order details from notification")
//            let order = self.notifications[indexPath.row].preOrderId ?? 0
//            self.preOrderID = order
//            self.getPreOrderList()
//        }
//
//        else if self.notifications[indexPath.row].orderId != 0  && self.notifications[indexPath.row].isReadyPickUp == true {
//            print("---- to order details from notification")
//            let order = self.notifications[indexPath.row].orderId ?? 0
//            self.orderID = order
//            self.getOrderList()
//        }
//
    }
//    {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let eventid = self.notifications[indexPath.row].redirectionId ?? 0
//        self.id = eventid
//        self.getEventsListing()
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
}

extension NotificationsViewController{
    func getEventsListing(){
        var params: [String:Any] = [String:Any]()
            params = (["eventId" : id])
        print(params)
        let service = EventsServices()
            GCD.async(.Default) {
            service.getEventsListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.view.isUserInteractionEnabled = true
                }
            switch serviceResponse.serviceResponseType {
            case .Success :
                GCD.async(.Main) {
                    if let eventsDetials = serviceResponse.data as? [EventViewModel] {
                        //for showing eventdetails
                        if let obj = eventsDetials.first(where: {$0.eventId == self.id}) {
                            let sb = UIStoryboard(name: "Home", bundle: nil)
                            if #available(iOS 13.0, *) {
                                let vc = sb.instantiateViewController(identifier: "NewEventDetialsViewController") as! NewEventDetialsViewController
                                vc.event = obj
                                self.navigationController?.pushViewController( vc, animated: true)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                        self.tableView.reloadData()
                        self.stopActivity()
                }
                else {
                    self.tableView.reloadData()
                    print("No Events Found!")
                }
            }
            case .Failure :
                GCD.async(.Main) {
                    print("No Events Found!,Failed")
                }
            default :
                GCD.async(.Main) {
                    print("No Events Found!")
                }
            }
        }
    }
  }
}


extension NotificationsViewController {
    
    func getOrderList(){
        
        var params: [String:Any] = [String:Any]()
        params =
            [:] as [String : Any]
        let service = UserServices()
        GCD.async(.Main) {
        }
        GCD.async(.Default) {
            service.GetOrderByUserTwo(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
//                        if let orderList = serviceResponse.data as? [GetOrderByTruckModel] {
//                            //print(orderList)
//                            self.orders = orderList
//                            self.tableView.reloadData()
//                            print("order list found")
//                        }
                        if let ordersDetials = serviceResponse.data as? [GetOrderByTruckModel] {
                            //for showing orderdetails
                            if let obj = ordersDetials.first(where: {$0.orderId == self.orderID}) {
                                let sb = UIStoryboard(name: "PreOrder", bundle: nil)
                                if #available(iOS 13.0, *) {
                                    let vc = sb.instantiateViewController(identifier: "User_Order_DetialViewController") as! User_Order_DetialViewController
                                    vc.order = obj
                                    self.navigationController?.pushViewController( vc, animated: true)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                            self.tableView.reloadData()
                            self.stopActivity()
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
    
    
    
    func getPreOrderList(){
        
        var params: [String:Any] = [String:Any]()
        params =
            [:] as [String : Any]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.GetPreOrderByUser(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()

                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
//                        if let orderList = serviceResponse.data as? [GetOrderByTruckModel] {
//                            //print(orderList)
//                            self.orders = orderList
//                            self.tableView.reloadData()
//                            print("order list found")
//                        }
//                        else {
//                            print("order list not found!")
//                        }
                        if let ordersDetials = serviceResponse.data as? [GetOrderByTruckModel] {
                            //for showing orderdetails
                            if let obj = ordersDetials.first(where: {$0.preOrderId == self.preOrderID}) {
                                let sb = UIStoryboard(name: "PreOrder", bundle: nil)
                                if #available(iOS 13.0, *) {
                                    let vc = sb.instantiateViewController(identifier: "User_Pre_Order_DetailViewController") as! User_Pre_Order_DetailViewController
                                    vc.order = obj
                                    self.navigationController?.pushViewController( vc, animated: true)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                            self.tableView.reloadData()
                            self.stopActivity()
                    }
                        else {
                            print("No Item Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("order list not found!!")
                    }
                default :
                    GCD.async(.Main) {
                        print("order list not found!!!")
                    }
                }
            }
        }
    }
    
}
