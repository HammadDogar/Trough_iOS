//
//  MyEventViewController.swift
//  Trough
//
//  Created by Imed on 16/09/2021.
//

import UIKit


class MyEventViewController: BaseViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var eventList = [EventViewModel]()
    
    var eventListFiltered = [EventViewModel]()

    var isInvite = false
    var eventFilter : NearbyTrucksViewModel?
    var tapped = true
    
    var filterArray = [EventViewModel]()
    var truckString = String()
    var currentEvent = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
        self.noResultLabel.isHidden = true
        self.getEventsListing()
        self.tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        tableView.reloadData()
        self.didEdit(tapped: tapped)
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
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension MyEventViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //       return self.eventList.count
        if self.filterArray.count > 0{
            self.noResultLabel.isHidden = true
            return self.filterArray.count
        }
        else{
            self.noResultLabel.isHidden = false
        }
        return self.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell{
   
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.mainView.shadow = true
            cell.collectionView.isHidden = true
            cell.bottomViewHeightConstraint.constant = 0
            cell.collectionViewHeightConstraint.constant = 0
            cell.mainViewhieght.constant = 290
            cell.addTruckToEventButton.isHidden = true
            cell.eventEditButton.isHidden = false
            cell.delegate = self
            
            let   item = self.eventList[indexPath.row]
            cell.configure(event: item)
            
            cell.onEdited = { [self] in
                let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier:"EditedEventViewController") as! EditedEventViewController
                vc.newEventModel = item
                vc.delegateEdit = self
                self.mainContainer.currenController?.pushViewController(vc, animated: true)
            }
            
            cell.onAdd = {
                self.currentEvent = self.eventList[indexPath.row].eventId ?? 0
//                self.addSelectedTruck()
            }
            let height = item.description?.heightWithConstrainedWidth(width: cell.eventDescriptionLabel.frame.width, font: UIFont(name: "Poppins-Medium", size: 10)!)
//            cell.eventDescriptionHeightConstraint.constant = (((height ?? 10) > 80 ? 80 : height) ?? 30)
            return cell
        }
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewEventDetialsViewController") as! NewEventDetialsViewController
            let event = self.eventList[indexPath.row]
            vc.event = event
            self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension MyEventViewController {
    func  getEventsListing(isloader:Bool = true,isReloadData:Bool = true){
        var params: [String:Any] = [String:Any]()
        
        params = ["createdById": Global.shared.currentUser.userId!]
            as [String : Any]
        
        let service = EventsServices()
        if isloader{
            GCD.async(.Main) {
                self.startActivityWithMessage(msg: "")
            }
        }
        GCD.async(.Default) {
            
            service.getEventsListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.view.isUserInteractionEnabled = true
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let eventsList = serviceResponse.data as? [EventViewModel] {
                            self.eventList = eventsList
                            
                            let truckId = self.eventFilter?.truckId ?? 0
                            let truckIDString = String(truckId)
                            let array = eventsList.filter { event -> Bool in
                                let trucks = event.invitedTrucks ?? []
                                if trucks.contains(where: { (truck) -> Bool in
                                    (truck.truckId ?? 0) == truckId
                                }) {
                                    return false
                                }
                                return true
                            }
                            print(array)
                            self.filterArray = array
                            self.truckString = truckIDString
                            self.tableView.reloadData()
                            self.stopActivity()
                        }
                        else {
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
extension MyEventViewController :  EventTableViewCellDelegate {
    func eventImageAction(index: Int) {
        //////
    }
    
    func eventActionPerform(index: Int, btnTitle: String, complete: @escaping ((Bool) -> Void)) {
        switch btnTitle {
        case "like":
            print("\(btnTitle)")
            
            var item : EventViewModel?
            item = self.eventList[index]
            
            self.likeApiCall(event: item!, index: index)
            
        case "unlike":
            print("\(btnTitle)")
        case "comment":
            print("\(btnTitle)")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewEventDetialsViewController") as! NewEventDetialsViewController
            let event = self.eventList[index]
            vc.event = event
            self.navigationController?.pushViewController(vc, animated: true)
        case "going":
            print("\(btnTitle)")
            self.eventGoingOrMaybeStatus(event: self.eventList[index],btn: btnTitle){ (succuess) in
                complete(true)
            }
        case "maybe":
            print("\(btnTitle)")
            self.eventGoingOrMaybeStatus(event: self.eventList[index],btn: btnTitle) { (succuess) in
                complete(true)
            }
        case "share":
            print("\(btnTitle)")
            let activityVc = UIActivityViewController(activityItems: ["Trough Event"], applicationActivities: nil)
            activityVc.popoverPresentationController?.sourceView = self.view
            self.present(activityVc, animated:true, completion: nil)
            complete(true)
        default:
            print("\(btnTitle)")
        }
    }
    
    func likeApiCall(event:EventViewModel,index:Int){
        var params : [String:Any] = [:]
        self.view.isUserInteractionEnabled = false
        var isLike = false
        
        if event.isLiked == true{
            params = ["commentId": 0,
                     "comment": "string",
                     "eventId": event.eventId!,
                     "commentTypeId": 6,
                     "isDeleteComment": true]
            isLike = true
        }
        else{
            params = ["commentId": 0,
                     "comment": "string",
                     "eventId": event.eventId!,
                     "commentTypeId": 6,
                     "isDeleteComment": false]
            isLike = false
        }
        
        let service = EventsServices()
        print(params)
        GCD.async(.Default) {
            service.LikeApiRequest(params: params) { (serviceResponse) in
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            self.getEventsListing(isloader: false,isReloadData: false)
                            let path = NSIndexPath.init(row: index, section: 0)
                            let cell = self.tableView.cellForRow(at: path as IndexPath) as! EventTableViewCell

                            if isLike{
                                cell.eventLikeImageView.image = UIImage(named: "likeButton")
                                cell.eventLikeCountLabel.text = String(event.likeCount! - 1)
                            }
                            else{
                                cell.eventLikeImageView.image = UIImage(named: "likedButton")
                                cell.eventLikeCountLabel.text = String(event.likeCount! + 1)
                                
                            }
                        }
                        else {
                            print("Error in Liking")
                            self.view.isUserInteractionEnabled = true
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error in Liking")
                        self.view.isUserInteractionEnabled = true
                    }
                default :
                    GCD.async(.Main) {
                        print("Error in Liking")
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    func didSelectTruck(truckId: Int, eventId: Int) {
        //
    }
}

extension  MyEventViewController : EditedEventViewDelegate{
    func didEdit(tapped: Bool) {
        if (self.tapped == tapped){
            self.getEventsListing()
        }
    }
}

// Event Going/Maybe Status Api Request
extension MyEventViewController{
    func eventGoingOrMaybeStatus(event: EventViewModel,btn: String,complete: @escaping ((Bool) -> Void)){
        var isgoing = false
        var ismaybe = false

        if btn == "going"{
            if event.isGoing ?? false{
                isgoing = false
            }else{
                isgoing = true
                ismaybe = false
            }
        }else{
            if event.isMaybe ?? false{
                ismaybe = false
            }else{
                ismaybe = true
                isgoing = false
            }
        }
        
        let params =
            [
                "eventId" : event.eventId ?? -1,
                "isGoing" : isgoing,
                "isMaybe" : ismaybe
            ] as [String : Any]
        let service = EventsServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.eventGoingOrMaybeRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        complete(true)
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Events Found!,Failed")
                        complete(false)
                    }
                default :
                    GCD.async(.Main) {
                        print("No Events Found!")
                        complete(false)
                    }
                }
            }
        }
    }
}
