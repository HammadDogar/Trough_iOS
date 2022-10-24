//
//  UserInvitationsViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 30/08/2022.
//

import UIKit
import SVProgressHUD


class UserInvitationsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    var eventList = [EventViewModel]()
    var isGoingEvent = [EventViewModel]()
    
    var isGoingIndex:Int = 0
    
    var currenController : BaseNavigationViewController?
    var previousController : BaseNavigationViewController?
    
    var isInvite = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.noResultLabel.isHidden = true
//        getActivityListing()
        getInvitationList()
        self.tableView.reloadData()
    }
    

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension UserInvitationsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//        return self.eventList.count //+ self.isGoingEvent.count
//
        if self.isInvite{
            (self.isGoingEvent.count > 0) ? (self.noResultLabel.isHidden = true) : (self.noResultLabel.isHidden = false)
            return self.isGoingEvent.count
        }else{
            (self.eventList.count > 0) ? (self.noResultLabel.isHidden = true) : (self.noResultLabel.isHidden = false)
            return self.eventList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInvitationsCell") as! UserInvitationsCell
        cell.index = indexPath.row
        cell.delegate = self
        var item: EventViewModel?
        item = self.eventList[indexPath.row]
        cell.configure(event: item!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: EventViewModel?
        item = self.eventList[indexPath.row]

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInvitationDetailViewController") as! UserInvitationDetailViewController
        vc.event = item

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension UserInvitationsViewController : InvitationBtnDelegate{
    
    func actionCancelBtn(eventId:Int) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to cancel the invitation", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle No logic here")
        }))

        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
        print(eventId)
//            self.AcceptOrCancelBtnApi(eventId: eventId, isGoing: false)
        }))

        present(alert, animated: true, completion: nil)
    }
    
    func actionAcceptBtn(eventId:Int) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to accept the invitation", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            
        }))

        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            print(eventId)
//            self.AcceptOrCancelBtnApi(eventId: eventId, isGoing: true)
            self.acceptEventInvitation(eventId: eventId)
        }))

        present(alert, animated: true, completion: nil)

    }

}


extension UserInvitationsViewController{
    
    func getInvitationList(){
        
        self.eventList.removeAll()
        var params: [String:Any] = [String:Any]()
        params = [
//                        "truckId" : Global.shared.currentUser.truckId!
            :
        ] as [String : Any]
        
        print(params)
        let service = UserServices()
//        SVProgressHUD.show()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            
//            getTruckInvitationList
            service.getUserInvitationList(params: params, userid: Global.shared.currentUser.userId!) { (serviceResponse) in
//            service.getInvitationList(params: params, truckId: Global.shared.currentUser.truckId!) { (serviceResponse) in
                GCD.async(.Main) {
//                    SVProgressHUD.dismiss()
                    self.stopActivity()

                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        
                        if let invitationList = serviceResponse.data as? [EventViewModel] {
                            print(invitationList)
                            self.eventList = invitationList
                            print(self.eventList)
                            self.tableView.reloadData()
                            print("Item found....")
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
    
    
    //acceptInvitationRequestOfEvent
    
    func acceptEventInvitation(eventId:Int){
        
        self.eventList.removeAll()
        var params: [String:Any] = [String:Any]()
        params = [ : ]  as [String : Any]
        
        let eventIdForInvitation = eventId
        print(params)
        let service = UserServices()
//        SVProgressHUD.show()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {

            service.acceptInvitationRequestOfEvent(params: params, eventId: eventIdForInvitation, userId: Global.shared.currentUser.userId!) { (serviceResponse) in

                GCD.async(.Main) {
//                    SVProgressHUD.dismiss()
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        
                        if let invitationList = serviceResponse.data as? [EventViewModel] {
                            print(invitationList)
                            self.eventList = invitationList
//                            print(self.eventList)
                            self.simpleAlert(title: "Alert", msg: "Invitation was accepeted successfully")
                            self.getInvitationList()
                            self.tableView.reloadData()
                            print("Item found....")
                        }
                        else {
                            self.simpleAlert(title: "Alert", msg: "Invitation was accepeted successfully")
                            self.getInvitationList()
                            self.tableView.reloadData()
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
