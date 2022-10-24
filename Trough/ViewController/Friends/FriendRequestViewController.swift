//
//  FriendRequestViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 29/08/2022.
//

import UIKit

class FriendRequestViewController: BaseViewController {

    @IBOutlet weak var totalFriendRequestCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var friendList = [FriendListViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFriendrequests()

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
    

    
}

extension FriendRequestViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.totalFriendRequestCount.text = String(self.friendList.count)
        return self.friendList.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestCell
        
        cell.index = indexPath.row
        cell.delegate = self
        var item : FriendListViewModel?
       item = self.friendList[indexPath.row]
        cell.config(list: item!)
        return cell
    }
    
    
}

extension FriendRequestViewController{
    func getFriendrequests(){
        var params: [String:Any] = [String:Any]()
        params = [:]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.getFriendRequestList(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let friendList = serviceResponse.data as? [FriendListViewModel] {
                            self.friendList = friendList
                            self.friendList.sort(){
                                $0.fullName ?? "" < $1.fullName ?? ""
                            }
                            self.tableView.reloadData()
                    }
                    else {
                        print("No Friend Found!")
                    }
                    self.tableView.reloadData()
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Friend Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Friend Found!")
                    }
                }
            }
        }
    }

    func acceptOrRejectasFriend(userRequestID:Int,acceptOrReject:Bool){
        let params:[String:Any] = [
            "userRequestID": userRequestID,
            "acceptOrReject" : acceptOrReject
        ]
        
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.acceptOrRejectFriendRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        print("Success")
                        self.simpleAlert(title: "Alert", msg: "Added as friend")
                        self.dismiss(animated: true, completion: nil)
                        self.tableView.reloadData()
                    }
                    self.tableView.reloadData()
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



extension FriendRequestViewController : FriendRequestDelegate{
    
    func actionAcceptBtn(userRequestID: Int) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to accept this request", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            
        }))

        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            print(userRequestID)
            self.acceptOrRejectasFriend(userRequestID: userRequestID, acceptOrReject: true)
        }))

        present(alert, animated: true, completion: nil)

    }
    
    func actionRejectBtn(userRequestID: Int) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to reject this request", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle No logic here")
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
        print(userRequestID)
            self.acceptOrRejectasFriend(userRequestID: userRequestID, acceptOrReject: false)
        }))

        present(alert, animated: true, completion: nil)
    }
    
    
}
