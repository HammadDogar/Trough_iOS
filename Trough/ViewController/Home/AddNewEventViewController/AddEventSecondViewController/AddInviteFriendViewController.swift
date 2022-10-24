//
//  AddInviteFriendViewController.swift
//  Trough
//
//  Created by Imed on 20/08/2021.
//

import UIKit

protocol  AddInviteFriendViewControllerDelegate{
//    func addFriend(friendList : [GetUserViewModel])
    func addFriend(friendList : [FriendListViewModel])

}


class AddInviteFriendViewController: BaseViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextfield: UITextField!
    
    
//    var getUser = [GetUserViewModel]()
//    var searchedFriend = [GetUserViewModel]()
//    var selectionArray = [GetUserViewModel]()

    var newEventModel = CreateEventViewModel()
    
    var delegate : AddInviteFriendViewControllerDelegate?
    
    var getUser = [FriendListViewModel]()
    var searchedFriend = [FriendListViewModel]()
    var selectionArray = [FriendListViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        self.configure()
        self.getFriendList()
    }
    
//
//    func getAllUser(){
//        var params: [String:Any] = [String:Any]()
//        params = [:] as [String : Any]
//        let service = UserServices()
//        GCD.async(.Main) {
//            self.startActivityWithMessage(msg: "")
//        }
//        GCD.async(.Default) {
//            service.getAllUser(params: params) { (serviceResponse) in
//                GCD.async(.Main) {
//                    self.stopActivity()
//                }
//                switch serviceResponse.serviceResponseType {
//                case .Success :
//                    GCD.async(.Main) {
//                        if let userData = serviceResponse.data as? [GetUserViewModel] {
//                            self.getUser = userData
//                            self.getUser.sort(){
//                                $0.fullName ?? "" < $1.fullName ?? ""
//                            }
//                            self.searchedFriend = self.getUser
//                            print(userData)
//                            self.tableView.reloadData()
//                    }
//                    else {
//                        print("No User Found!")
//                    }
//                }
//                case .Failure :
//                    GCD.async(.Main) {
//                        print("No User Found!")
//                    }
//                default :
//                    GCD.async(.Main) {
//                        print("No User Found!")
//                    }
//                }
//            }
//        }
//    }
    
    func getFriendList(){

        var params: [String:Any] = [String:Any]()
        params = [:]

        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
          
        }
        GCD.async(.Default) {
            service.getFriendList(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                    //self.refreshControl.endRefreshing()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let friendList = serviceResponse.data as? [FriendListViewModel] {
                            self.getUser = friendList
                            
                            self.getUser.sort(){
                                $0.fullName ?? "" < $1.fullName ?? ""
                            }
                            self.searchedFriend = self.getUser

                            self.tableView.reloadData()
                    }
                    else {
                        print("No Friend Found!")
                    }
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
    func configure(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
    }
    
    
    @IBAction func actionSearch(_ sender: UITextField) {
        if sender.text == "" {
            getUser  = searchedFriend
        }else {
            getUser  = searchedFriend.filter({ (data) -> Bool in
//                return (data.fullName?.lowercased().contains(sender.text ?? ""))!
                (data.fullName?.lowercased().contains(sender.text?.lowercased() ?? ""))!
            })
        }
        tableView.reloadData()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.mainContainer.currenController?.popViewController(animated: true)
    }
    @IBAction func actionDone(_ sender: UIButton) {
        delegate?.addFriend(friendList: self.selectionArray)
        self.navigationController?.popViewController(animated: true)

    }
}

extension AddInviteFriendViewController : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.getUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        cell.selectionStyle = .none
//        cell.index = indexPath.row
//        cell.delegate = self
        
        let item = self.getUser[indexPath.row]
        cell.configure(friend: item)
        
        print(selectionArray)
        if self.selectionArray.contains(where: { $0.userId  ==  item.userId  ?? 0
        }){
            cell.btnInvite.backgroundColor = UIColor.clear
            cell.btnInvite.setTitle("", for: .normal)
            cell.btnInvite.setImage(UIImage(named: "greenTick"), for: .normal)
        }else{
            cell.btnInvite.backgroundColor = UIColor(named: "YellowColor")
            cell.btnInvite.setTitle("Invite", for: .normal)
            cell.btnInvite.setImage(UIImage(named: ""), for: .normal)
        }
        cell.onInvite = {
//            let id =  self.getUser[indexPath.row].userId  ??  -1
//            if self.newEventModel.userIds == "" {
//                self.newEventModel.userIds.append("\(id)")
//            }else {
//                self.newEventModel.userIds.append(",\(id)")
//            }
//            {
//                self.selectionArray.removeAll(where: {$0 == id})
//            }else{
//                self.selectionArray.append(id)
//            }
            if let obj = self.selectionArray.first(where: {$0.userId == item.userId}) {
                self.selectionArray.removeAll(where: {$0.userId == obj.userId})
            }else {
                self.selectionArray.append(item)
            }
            print(self.selectionArray.count)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
