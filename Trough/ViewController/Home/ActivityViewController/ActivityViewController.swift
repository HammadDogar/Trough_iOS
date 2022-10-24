//
//  ActivityViewController.swift
//  Trough
//
//  Created by Irfan Malik on 11/01/2021.
//

import UIKit

class ActivityViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResult: UILabel!
    
    var activityList = [EventViewModel]()
//    var newEventModel = CreateEventViewModel()
    var events = CreateEventViewModel()
    
    var eventList = [EventViewModel]()
    var eventListFiltered = [EventViewModel]()
    
    var friendList = [FriendListViewModel]()

    var firstCellVisible = false
    var isInvite = false
    var eventFilter : NearbyTrucksViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        tableView.reloadData()

        
    }
    
    func config(){
        self.getUserActivityListing()
        self.tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        
    }
    
    @IBAction func actionNotification(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as?         NotificationsViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension ActivityViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell{
            cell.collectionView.isHidden = true
            cell.collectionViewHeightConstraint.constant = 0
            cell.bottomViewHeightConstraint.constant = 0
            cell.mainViewhieght.constant = 290
            cell.eventDescriptionLabel.sizeToFit()
            cell.eventEditButton.isHidden = true
            cell.addTruckToEventButton.isHidden = true
            cell.selectionStyle = .none
            cell.delegate = self
            cell.index = indexPath.row
            let item = self.activityList[indexPath.row]
            cell.configure(event: item)
            cell.onEdited = { [self] in
                let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier:"EditedEventViewController") as! EditedEventViewController
                //passing data
                vc.newEventModel = item
                self.mainContainer.currenController?.pushViewController(vc, animated: true)
            }
//            let height = item.description?.heightWithConstrainedWidth(width: cell.eventDescriptionLabel.frame.width, font: UIFont(name: "Poppins-Medium", size: 10)!)
//
//            cell.eventDescriptionHeightConstraint.constant = (((height ?? 10) > 80 ? 80 : height) ?? 30)
            return cell
        }
        return UITableViewCell.init()
    }    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("hellop")
    }
}

// Get Activity Listing Api Request
extension ActivityViewController : EventTableViewCellDelegate {
    func didSelectTruck(truckId : Int, eventId : Int) {
        ///
    }
    
    
    func eventImageAction(index: Int) {
        //
    }
    
    func getUserActivityListing(){
        let params = [:] as [String: Any]
        let service = EventsServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.getActivityListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let activitiesList = serviceResponse.data as? [EventViewModel] {
                            self.activityList = activitiesList
                            if self.activityList.count > 0{
                                self.noResult.isHidden = true
                            }else{
                                self.noResult.isHidden = false
                            }
                            
                            self.tableView.reloadData()
                            self.stopActivity()
                        }
                        else {
                            self.noResult.isHidden = false
                            print("No Activity Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.noResult.isHidden = false
                        print("No Activity Found!,Failed")
                    }
                default :
                    GCD.async(.Main) {
                        self.noResult.isHidden = false
                        print("No Activity Found!")
                    }
                }
            }
        }
    }
    
        func eventActionPerform(index: Int, btnTitle: String, complete: @escaping ((Bool) -> Void)) {
            switch btnTitle {
            case "like":
                print("\(btnTitle)")
                
                var item : EventViewModel?
                item = self.activityList[index]
                
                self.likeApiCall(event: item!, index: index)
                
            case "unlike":
                print("\(btnTitle)")
            case "comment":
                print("\(btnTitle)")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewEventDetialsViewController") as! NewEventDetialsViewController
                let event = self.activityList[index]
                vc.event = event
                self.navigationController?.pushViewController(vc, animated: true)
            case "going":
                print("\(btnTitle)")
                self.eventGoingOrMaybeStatus(event: self.activityList[index],btn: btnTitle){ (succuess) in
                    complete(true)
                }
            case "maybe":
                print("\(btnTitle)")
                self.eventGoingOrMaybeStatus(event: self.activityList[index],btn: btnTitle) { (succuess) in
                    complete(true)
                }
            case "share":
                print("\(btnTitle)")
                let activityVc = UIActivityViewController(activityItems: ["https://www.google.com/"], applicationActivities: nil)
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
//                                self.getEventsListing(isloader: false,isReloadData: false)
                                let path = NSIndexPath.init(row: index, section: 0)
                                let cell = self.tableView.cellForRow(at: path as IndexPath) as! EventTableViewCell

                                if isLike{
                                    cell.eventLikeImageView.image = UIImage(named: "likeButton")
                                    cell.eventLikeCountLabel.text = String(event.likeCount! - 1)
                                    self.view.isUserInteractionEnabled = true
                                }
                                else{
                                    cell.eventLikeImageView.image = UIImage(named: "likedButton")
                                    cell.eventLikeCountLabel.text = String(event.likeCount! + 1)
                                }
                                self.view.isUserInteractionEnabled = true

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
    }
// Event Going/Maybe Status Api Request
extension ActivityViewController{
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
