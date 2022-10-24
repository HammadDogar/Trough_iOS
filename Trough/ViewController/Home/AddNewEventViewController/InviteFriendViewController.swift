//
//  InviteFriendViewController.swift
//  Trough
//
//  Created by Irfan Malik on 29/12/2020.
//

import UIKit

class InviteFriendViewController: BaseViewController {

    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var btnPost:UIButton!
    @IBOutlet weak var tableView:UITableView!
    
    var getUser = [GetUserViewModel]()
    
    var newEventModel = CreateEventViewModel()
    var selectionArray = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        
        getAllUser()
    }
    
    func getAllUser(){
        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.getAllUser(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let userData = serviceResponse.data as? [GetUserViewModel] {
                            
                            self.getUser = userData
                            print(userData)
                            
                            self.tableView.reloadData()
                    }
                    else {
                        print("No User Found!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No User Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No User Found!")
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
    
    @IBAction func actionPost(_ sender: Any){
        self.newEventModel.UsersInEvents = self.selectionArray
        
        self.createEvent()
//        self.mainContainer.currenController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actionCheckbox(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        } else{
            sender.isSelected = true
        }
    }
    
    
    @IBAction func actionBack(_ sender: Any){
        self.mainContainer.currenController?.popViewController(animated: true)
    }
}


extension InviteFriendViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.getUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        cell.selectionStyle = .none
        cell.index = indexPath.row
        let item = self.getUser[indexPath.row]
//        cell.configure(friend: item)
        cell.delegate = self
        print(selectionArray)
        if self.selectionArray.contains(indexPath.row){
            cell.btnInvite.backgroundColor = UIColor.clear
            cell.btnInvite.setTitle("", for: .normal)
            cell.btnInvite.setImage(UIImage(named: "greenTick"), for: .normal)
        }else{
            cell.btnInvite.backgroundColor = UIColor(named: "YellowColor")
            cell.btnInvite.setTitle("Invite", for: .normal)
            cell.btnInvite.setImage(UIImage(named: ""), for: .normal)
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

extension InviteFriendViewController: FriendTableViewCellDelegate{
    func inviteFriend(index: Int) {
        //self.selectionArray.append(index)
        if self.selectionArray.contains(index){
            let pos = self.selectionArray.firstIndex(of: index)
            self.selectionArray.remove(at: pos!)
        }else{
            self.selectionArray.append(index)
        }
        let index = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [index], with: .automatic)
    }
}

extension InviteFriendViewController{
    func createEvent(){
//        var finalSlot = [AnyObject]()
//        for slot in self.newEventModel.EventSlots{
//            let itemParams = [
//                "startDate" :slot.startDate,
//                "startTime" : slot.startTime,
//                "endTime" : slot.endTime
//            ] as [String: Any]
//          finalSlot.append(itemParams as [String: AnyObject] as AnyObject)
//        }
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self.newEventModel.EventSlots)
        let slots = String(data: data, encoding: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : [.allowFragments]) as? [String:AnyObject]
            {
               print(jsonArray) // use the json here
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
        let params = [
            
            "EventId"           : self.newEventModel.eventId,
            "EventName"         : self.newEventModel.EventName,
            "Description"       : self.newEventModel.Description,
            "LocationName"      : self.newEventModel.Address,
//                "Pakistan",
            "Address"           : self.newEventModel.Address,
            "Latitude"          : self.newEventModel.Latitude,
            "Longitude"         : self.newEventModel.Longitude,
            "Type"              : self.newEventModel.eventType,
            //"TrucksInEvents"    : self.newEventModel.TrucksInEvents,
            //"UsersInEvents"     : self.newEventModel.UsersInEvents,
            "EventSlots"        : slots,
            "ImageFile"         : self.newEventModel.ImageFile,
            "TruckIds"          : self.newEventModel.truckIds
            
        ] as [String : Any]
        let service = EventsServices()
        print(params)
        
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.postEventRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if "Added" == serviceResponse.message {
                            self.mainContainer.currenController?.popToRootViewController(animated: true)
                            print("success")
                    }
                    else {
                        print("Event is not created")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("Event is not created")
                    }
                default :
                    GCD.async(.Main) {
                        print("Event is not created")
                    }
                }
            }
        }
    }
}
