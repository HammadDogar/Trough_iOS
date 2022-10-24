//
//  EventDetailsViewController.swift
//  Trough
//
//  Created by Irfan Malik on 19/12/2020.



import UIKit

class EventDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    var event :EventViewModel?
    
    var comment = [CommentViewModel]()
    var reply = [CommentViewModel]()
    
    var replymodel = [replyModel]()
    var commentmodel = [commentModel]()

    var nearByList = [NearbyTrucksViewModel]()
    
    var myEvent: EventViewModel?
    var myTrucks = [InvitedTrucks]()
    var truckInfo = [TruckInfoViewModel]()


    var id = 0
    var notifications = [NotificationViewModel]()
    var eventList = [EventViewModel]()
    
    var eventListFiltered = [EventViewModel]()
    var eventFilter : NearbyTrucksViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        
        self.navigationItem.hidesBackButton = true
        
        self.getComments()
        self.getEventsListing()
        
        self.tableView.register(UINib(nibName: "EventCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCommentsTableViewCell")

//        self.isFromNotification = true
    }
    
    func config(){
//        self.tableView.delegate   = self
//        self.tableView.dataSource = self
//        self.tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        
    }
        
    @IBAction func actionBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCommentBtn(_ sender: UIButton) {
        if commentTextField.isValidInput(){
            self.addCommentApi()
        }
    }
    
    func addCommentApi(){
        var params: [String:Any] = [String:Any]()
        params = [
            "commentId": 0,
            "comment": self.commentTextField.text ?? "",
            "eventId": self.event?.eventId! ?? -1,
              "commentTypeId": 5,
              
              "isDeleteComment": false
        ] as [String : Any]

        print(params)

        
        let service = EventsServices()
        
        
        GCD.async(.Default) {
            service.addCommentRequest(params: params) { (serviceResponse) in
                
            switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            print("Comment Added Successfully")
                            self.commentTextField.text = ""
                            self.getComments(scrolToBottom: true)
                        }
                        else {
                            print("Error adding Comment")
                        }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error adding Comment")
                    }
                default :
                    GCD.async(.Main) {
                        print("Error adding Comment")
                    }
                }
            }
        }
        
        
    }
}
//
//extension EventDetailsViewController:UITableViewDelegate,UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0{
//
//            // showing diff section
//            if event == nil{
//                return 0 }
//            else{
//                return 1
//            }
//
//        }else{
//            print(commentmodel.count)
//
//            return self.commentmodel.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
//            cell.backgroundColor = UIColor.white
//            cell.eventEditButton.isHidden = true
//            cell.mainView.shadow = false
//            cell.addTruckToEventButton.isHidden = true
//            cell.delegate = self
//            cell.configure(event: event!)
////            cell.index = indexPath.row
////            cell.delegate = self
////            cell.configure(nearBy: self.nearByList[indexPath.row])
//
//            return cell
//        }
//        else{
//            let cell  =  tableView.dequeueReusableCell(withIdentifier:
//                                                        "EventCommentsTableViewCell", for: indexPath) as! EventCommentsTableViewCell
//
//            cell.config(reples: self.commentmodel[indexPath.row])
//            cell.pos = indexPath.row
////            cell.delegate = self
//
//            if self.commentmodel[indexPath.row].replies.count > 0{
//
//                cell.tableViewHeigthConstraint.constant = self.commentmodel[indexPath.row].isSeeMore ? CGFloat(117 * self.commentmodel[indexPath.row].replies.count) : 44
//
//            }else{
//
//                cell.tableViewHeigthConstraint.constant = 0
//            }
//            cell.commentLabel.text = self.commentmodel[indexPath.row].comment
//            return cell
//        }
//    }
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////
////        let fulName = self.commentmodel[indexPath.row].fullName!
////        if let index = (fulName.range(of: " ")?.upperBound)
////        {
////          //prints "element="
////          let first = String(fulName.prefix(upTo: index))
////            self.commentTextField.text = "@\(first)"
////        }
////        else{
////            self.commentTextField.text = "@\(fulName) "
////        }
////    }
//
////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////
////        if indexPath.section == 1{
////            return 140 + self.comments[indexPath.row].commentText.heightWithConstrainedWidth(width: self.view.frame.width-125, font: UIFont.init(name: "poppins-regular", size: 8)!)
////        }else{
////            return UITableView.automaticDimension
////        }
////    }
//
//}
//extension EventDetailsViewController: EventCommentsTableViewCellDelegate{
//    func pleaseReloadSection(index: Int) {
////        let pos = self.comments.firstIndex{$0.commentId == index}
//
//        DispatchQueue.main.async {
//            let indexP = IndexPath(row: index, section: 1)
//            self.commentmodel[index].isSeeMore = true
//            self.tableView.reloadRows(at: [indexP], with: .automatic)
//        }
//
//    }
//}
extension EventDetailsViewController{
    
    func getComments(scrolToBottom: Bool = false){
        var params: [String:Any] = [String:Any]()
        params = [
            :
        ] as [String : Any]

        let service = EventsServices()
        GCD.async(.Default) {
            //to check is from notifications or events
            var newID: Int = 0
            if let id = self.event?.eventId {
                newID = id
            }else {
                newID = self.id
            }
            service.getCommentRequest(params: params,eventId: newID) { (serviceResponse) in
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let commentList = serviceResponse.data as? [CommentViewModel] {
                            self.comment.removeAll()
                            self.reply.removeAll()
                            for com in commentList{
                                print(com.parentId!)
                                if com.parentId! == -1{
                                    self.comment.append(com)

                                }
                                else{
                                    self.reply.append(com)
                                }
                            }
                            self.commentmodel.removeAll()
                            for comm in self.comment{
                                self.replymodel.removeAll()
                                for rep in self.reply{
                                    if comm.commentId! == rep.parentId{
                                        self.replymodel.append(replyModel.init(cId: rep.commentId!, c: rep.comment!, eId: rep.eventId!, ctId: rep.commentTypeId!, pId: rep.parentId!, cDate: rep.createdDate!, fName: rep.fullName!))
                                    }
                                }
                                self.commentmodel.append(commentModel.init(cId: comm.commentId!, c: comm.comment!, eId: comm.eventId!, ctId: comm.commentTypeId!, pId: comm.parentId ?? -1, cDate: comm.createdDate!, fName: comm.fullName!, iSMore: false, r: self.replymodel))

                            }
                            if scrolToBottom{
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    if self.commentmodel.count >= 3{
                                        let indexpath = IndexPath(row: self.commentmodel.count-1, section: 1)
                                        self.tableView.scrollToRow(at: indexpath, at: .top, animated: true)
                                        self.updateTableContentInset()
                                    }
                                    
                                }

                            }
                            else{
                                self.tableView.reloadData()
                            }
                            
                    }
                    else {
                        print("Error Fetching Comment!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Comment Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("Comment not Found!")
                    }
                }
            }
        }
    }
    
    func updateTableContentInset() {
        let numRows = self.tableView.numberOfRows(inSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
}

extension EventDetailsViewController: EventTableViewCellDelegate{
    //added today
    
    func didSelectTruck(truckId : Int,eventId : Int) {
        
        let sb = UIStoryboard(name: "Home", bundle: nil)
        if #available(iOS 13.0, *) {
            let vc = sb.instantiateViewController(identifier: "TruckInfoViewController") as! TruckInfoViewController
            vc.id = truckId
            vc.evntId = eventId
            print(eventId)
            vc.event = event
    
            self.navigationController?.pushViewController( vc, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func editEvent(index: Int) {
        //
    }
    func eventImageAction(index: Int) {
        print("Image")
    }
    
    func eventActionPerform(index: Int, btnTitle: String, complete: @escaping ((Bool) -> Void)) {
        switch btnTitle {
        case "like":
            print("\(btnTitle)")
            
            self.likeApiCall(event: self.event!, index: index)
            
        case "unlike":
            print("\(btnTitle)")
        case "comment":
            print("\(btnTitle)")
        case "going":
            print("\(btnTitle)")
            self.eventGoingOrMaybeStatus(event: self.event!,btn: btnTitle){ (succuess) in
                complete(true)
            }
        case "maybe":
            print("\(btnTitle)")
            self.eventGoingOrMaybeStatus(event: self.event!,btn: btnTitle) { (succuess) in
                complete(true)
            }
        case "share":
            print("\(btnTitle)")
            let activityVc = UIActivityViewController(activityItems: ["https://www.google.com/"], applicationActivities: nil)
            activityVc.popoverPresentationController?.sourceView = self.view
            self.present(activityVc, animated:true, completion: nil)
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
            self.event?.isLiked = false
        }
        else{
            params = ["commentId": 0,
                     "comment": "string",
                     "eventId": event.eventId!,
                     "commentTypeId": 6,
                     "isDeleteComment": false]
            self.event?.isLiked = true
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
                            self.view.isUserInteractionEnabled = true
                            //self.getEventsListing(isloader: false,isReloadData: false)
                            let path = NSIndexPath.init(row: 0, section: 0)
                            let cell = self.tableView.cellForRow(at: path as IndexPath) as! EventTableViewCell

                            if isLike{
                                cell.eventLikeImageView.image = UIImage(named: "likeButton")
                                cell.eventLikeCountLabel.text = String(event.likeCount! - 1)
                                self.event?.likeCount! = event.likeCount! - 1
                            }
                            else{
                                cell.eventLikeImageView.image = UIImage(named: "likedButton")
                                cell.eventLikeCountLabel.text = String(event.likeCount! + 1)
                                self.event?.likeCount! = event.likeCount! + 1
                                
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
}

// Event Going/Maybe Status Api Request
extension EventDetailsViewController{
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
extension EventDetailsViewController {
    func getEventsListing(){
        var params: [String:Any] = [String:Any]()
        if (event != nil){
            params = ["eventId": self.event?.eventId! ?? 0]
        }else{
            params = (["eventId" : id])
        }
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
                    if let eventsList = serviceResponse.data as? [EventViewModel] {
                        //for showing eventdetails
                        self.eventList = eventsList
                        if self.eventList.count > 0{
                            self.event = eventsList[0]
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

