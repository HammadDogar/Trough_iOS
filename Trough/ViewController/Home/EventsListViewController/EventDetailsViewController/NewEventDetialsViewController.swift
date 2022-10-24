//
//  NewEventDetialsViewController.swift
//  Trough
//
//  Created by Imed on 08/10/2021.
//

import UIKit
import Kingfisher
import SVProgressHUD

protocol newEventDetailsDelegate {
    func didSelectTruck(truckId: Int,eventId: Int)
}

class NewEventDetialsViewController: BaseViewController {
    
    
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var eventUserImage: UIImageView!
    @IBOutlet weak var eventUserName: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventCreatedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var eventLikeImageView: UIImageView!
    @IBOutlet weak var eventMayBeImageView: UIImageView!
    @IBOutlet weak var eventGoingImageView: UIImageView!
    @IBOutlet weak var eventLikeCountLabel: UILabel!
    @IBOutlet weak var eventCommentCountLabel: UILabel!
    @IBOutlet weak var eventDetailsView: UIView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
    var delegate : newEventDetailsDelegate?
    var event :EventViewModel?
    var comment = [CommentViewModel]()
    var reply = [CommentViewModel]()
    var replymodel = [replyModel]()
    var commentmodel : [commentModel] = []
    var nearByList = [NearbyTrucksViewModel]()
    var myEvent: EventViewModel?
    var myTrucks = [InvitedTrucks]()
    var truckInfo = [TruckInfoViewModel]()
    var eventId:Int = -1
    var index = -1
    var id = 0
    var notifications = [NotificationViewModel]()
    var eventList = [EventViewModel]()
    var eventListFiltered = [EventViewModel]()
    var eventFilter : NearbyTrucksViewModel?
    
    var commentID = 0
    
    let ccomment : CommentViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        
        
        self.eventDescriptionLabel.sizeToFit()
        self.eventDescriptionLabel.adjustsFontForContentSizeCategory  = (11 != 0)
        
        self.tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        self.collectionView.register(UINib(nibName: "TruckCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TruckCollectionViewCell")
        self.tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        
        
        self.config()
        self.getComments()
        self.getEventsListing()
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        
        //        self.eventMapping(data: event!)
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.eventMapping(data: event!)
        tableView.reloadData()
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        
    }
    //
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Show the navigation bar on other view controllers
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    
    func eventMapping(data : EventViewModel){
        self.eventId = data.eventId ?? -1
        self.event = data
        
        
        self.eventNameLabel.text = "\(data.eventName ??  "")"
        self.eventUserName.text = "\(data.fullName ?? "")"
        
        let eventStartDate = data.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        self.eventDateLabel.text = "\(eventStartDate?.string(with: .custom("dd MMMM yyyy")) ?? "")"
        
        let startTime = data.eventSlots?.first?.startTime?.timeConversion12()
        let endTime = data.eventSlots?.first?.endTime?.timeConversion12()
        self.eventTimeLabel.text = "\(startTime ?? "") - \(endTime ?? "")"
        
        self.eventDescriptionLabel.text = "\(data.description ?? "")"
        self.eventAddressLabel.text = "\(data.address ?? "")"
        
        //        let eventcreateDateWithTime = data.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        //        let createDate = eventcreateDateWithTime?.getOnlyDate()
        //        self.eventCreatedLabel.text = "\(createDate?.getPastTime() ?? "")"
        
        let timeArray  : String = data.createdDate ?? ""
        let dateTime = timeArray.components(separatedBy: ".")
        let eventDate : String = dateTime[0]
        
        self.eventCreatedLabel.text  = eventDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.toLocalTime().getPastTime()
        
        
//        if data.imageUrl != "" && data.imageUrl != nil{
//            let url = URL(string: BASE_URL+data.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.eventImageView.setImage(url: url)
//        }else{
//            self.eventImageView.image = UIImage(named: "PlaceHolder2")
//        }
        
        if data.imageUrl != "" && data.imageUrl != nil{
            if let url = URL(string: data.imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.eventImageView.setImage(url: url)
                }
            }
        }else{}
        
//        if data.profileUrl != "" && data.profileUrl != nil{
//            let url = URL(string: BASE_URL+data.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            DispatchQueue.main.async {
//                self.eventUserImage.setImage(url: url)
//            }
//        }else{
//            self.eventUserImage.image = UIImage(named: "personFilled")
//        }
        
        if data.profileUrl != "" && data.profileUrl != nil{
            if let url = URL(string: data.profileUrl ?? "") {
                DispatchQueue.main.async {
                    self.eventUserImage.setImage(url: url)
                }
            }
        }else{
            self.eventUserImage.image = UIImage(named: "personFilled")
            }
        
        if data.isLiked ?? false{
            self.eventLikeImageView.image = UIImage(named: "likedButton")
        }else{
            self.eventLikeImageView.image = UIImage(named: "likeButton")
        }
        if data.isGoing ?? false {
            self.eventGoingImageView.image = UIImage(named: "orangeIcon")
        }else{
            self.eventGoingImageView.image = UIImage(named: "tickGray")
        }
        
        if data.isMaybe ?? false {
            self.eventMayBeImageView.image = UIImage(named: "orangeIcon")
        }else{
            self.eventMayBeImageView.image = UIImage(named: "tickGray")
        }
        if ((data.isGoing ?? false) == false) && ((data.isMaybe ?? false) == false){
            self.eventGoingImageView.image = UIImage(named: "tickGray")
            self.eventMayBeImageView.image = UIImage(named: "tickGray")
        }
        self.eventLikeCountLabel.text = "\(data.likeCount ?? 0)"
        self.eventCommentCountLabel.text = "\(data.commentCount ?? 0)"
        
        self.updateStatus(event: data)
        
    }
    
    func updateStatus(event: EventViewModel){
        if event.isGoing ?? false {
            self.eventGoingImageView.image = UIImage(named: "orangeIcon")
        }else{
            self.eventGoingImageView.image = UIImage(named: "tickGray")
        }
        
        if event.isMaybe ?? false {
            self.eventMayBeImageView.image = UIImage(named: "orangeIcon")
        }else{
            self.eventMayBeImageView.image = UIImage(named: "tickGray")
        }
        if ((event.isGoing ?? false) == false) && ((event.isMaybe ?? false) == false){
            self.eventGoingImageView.image = UIImage(named: "tickGray")
            self.eventMayBeImageView.image = UIImage(named: "tickGray")
        }
    }
    
    func config(){
        //        self.tableView.delegate   = self
        //        self.tableView.dataSource = self
        //        self.collectionView.register(UINib(nibName: "TruckCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TruckCollectionViewCell")
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionCommentButton(_ sender: Any) {
        if commentTextField.isValidInput(){
            self.addCommentApi()
        }
    }
    
    @IBAction func actionImageView(_ sender: Any) {
        let imageInfo = GSImageInfo(image: self.eventImageView.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: self.eventImageView)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
    }
    @IBAction func actionLike(_ sender: Any) {
        let index = 0
        var item : EventViewModel?
        item = self.eventList[index]
        
        self.likeApi(event: item!, index: index)
    }
    @IBAction func actiongoing(_ sender: Any) {
        let btn = "going"
        
        self.eventGoingOrMaybeStatus(event: self.event!, btn: btn){(success) in
            if success{
                if self.event?.isGoing ?? false{
                    self.event?.isGoing = false
                }else{
                    self.event?.isGoing = true
                    self.event?.isMaybe = false
                }
                self.updateStatus(event: self.event!)
            }
        }
        print("hahah")
    }
    @IBAction func actionMaybe(_ sender: Any) {
        let btn = "maybe"
        self.eventGoingOrMaybeStatus(event: self.event!, btn: btn){(success) in
            if success{
                if self.event?.isMaybe ?? false{
                    self.event?.isMaybe = false
                }else{
                    self.event?.isMaybe = true
                    self.event?.isGoing = false
                }
                self.updateStatus(event: self.event!)
            }
        }
        print("done")
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

extension NewEventDetialsViewController : UITableViewDelegate,UITableViewDataSource {

    // commented for get index
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 2
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //commented for get index
        //        if section == 0{
        //            return 0
        //        }
        //        else {
        //            return self.commentmodel.count
        //
        //        }
        return self.commentmodel.count
        //        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.config(reples: self.commentmodel[indexPath.row])
        cell.pos = indexPath.row
        cell.configureDate(data: comment[indexPath.row])
        //        cell.delegate = self
        if self.commentmodel[indexPath.row].replies.count > 0{
            //            cell.tableViewHeigthConstraint.constant = self.commentmodel[indexPath.row].isSeeMore ? CGFloat(117 * self.commentmodel[indexPath.row].replies.count) : 44
        }else{
            //            cell.tableViewHeigthConstraint.constant = 0
        }
        
        cell.commentLabel.sizeToFit()
        cell.commentLabel.text = self.commentmodel[indexPath.row].comment
        cell.userNameLabel.text = self.commentmodel[indexPath.row].fullName
        let timeArray  : String = commentmodel[indexPath.row].createdDate ?? ""
        let dateTime = timeArray.components(separatedBy: ".")
        let commentDate : String = dateTime[0]
        cell.commentDateLAbel.text  = commentDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.toLocalTime().getPastTime()
        
        
        
        cell.onInvite = {
            self.commentTextField.becomeFirstResponder()
        }
        
        cell.onLike = {
            self.commentID = self.commentmodel[indexPath.row].commentId ?? 0
            let indexValue =  indexPath.row

            self.LikeCommentApi(index: indexValue)
            //            self.LikeCommentApi(comment: self.currentComment!)
        }
        return cell
    }
}

extension NewEventDetialsViewController {
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
                            //code 29-04-2022
                            self.tableView.reloadData()
                            
                            self.stopActivity()
                            //
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

extension NewEventDetialsViewController {
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

extension NewEventDetialsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return event?.invitedTrucks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TruckCollectionViewCell", for: indexPath) as! TruckCollectionViewCell
        
        //zSet indexPath of the cell
        cell.indexPath = indexPath
        //        cell.truckName.text = self.myEvent?.invitedTrucks?[indexPath.row].name
        //        cell.configure(bannerUrl: BASE_URL+((self.myEvent?.invitedTrucks?[indexPath.row].bannerUrl ?? "" )))
        cell.truckName.text = self.event?.invitedTrucks?[indexPath.row].name
        
        
        cell.configure(bannerUrl: BASE_URL+((self.event?.invitedTrucks?[indexPath.row].bannerUrl ?? "" )))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width/2.2
        return CGSize(width: width, height: width-20)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        delegate?.didSelectTruck(truckId: self.myEvent?.invitedTrucks?[indexPath.row].truckId ?? 0, eventId: myEvent?.eventId ?? 0)
        //        delegate?.didSelectTruck(truckId: self.event?.invitedTrucks?[indexPath.row].truckId ?? 0, eventId: event?.eventId ?? 0)
        let vc = self.storyboard?.instantiateViewController(identifier: "TruckMenuViewController")as! TruckMenuViewController
        vc.id = event?.invitedTrucks?[indexPath.row].truckId ?? 0
        vc.evntId = self.eventId
        vc.event = self.event
        self.navigationController?.pushViewController(vc, animated: true)
        print("-------->")
    }
}

extension NewEventDetialsViewController {
    
    func likeApi(event:EventViewModel,index:Int){
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
                            self.getEventsListing()
                            if isLike{
                                self.eventLikeImageView.image = UIImage(named: "likeButton")
                                self.eventLikeCountLabel.text = String(event.likeCount! - 1)
                            }
                            else{
                                self.eventLikeImageView.image = UIImage(named: "likedButton")
                                self.eventLikeCountLabel.text = String(event.likeCount! + 1)
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

extension NewEventDetialsViewController{
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

extension NewEventDetialsViewController {
    
    
    func LikeCommentApi(index : Int){
        
        var params : [String:Any] = [:]
        self.view.isUserInteractionEnabled = false
        var isLike = false
        
        if ccomment?.isCommentLiked == true{
            params = [
                "commentId" : self.commentID,
                "isDeleteComment": true,
                "commentTypeId" : 6
            ]
            isLike = true
        }
        else{
            params = [
                "commentId" : self.commentID,
                "isDeleteComment": false,
                "commentTypeId" : 6
            ]
            isLike = false
        }
        let service = EventsServices()
        SVProgressHUD.show()

        print(params)
        GCD.async(.Default) {
            service.LikeCommentApiRequest(params: params) { (serviceResponse) in
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
                        if let data = serviceResponse.data{
                            print(data)
                            self.getComments()
                            let path = NSIndexPath.init(row: index, section: 0)
                            print(path)
                            let cell = self.tableView.cellForRow(at: path as IndexPath) as! CommentTableViewCell
                            self.tableView.reloadData()

                            if isLike{
                                cell.likedButtonImageView.image = UIImage(named: "likeButton")
                                cell.commentLikeCountLabel.text = String((self.ccomment?.commentLikeCount! ?? 0) - 1)
                            }
                            else{
                                cell.likedButtonImageView.image = UIImage(named: "likedButton")
                                cell.commentLikeCountLabel.text = String((self.ccomment?.commentLikeCount! ?? 0) + 1)
                            }
                            SVProgressHUD.dismiss()
                            self.view.isUserInteractionEnabled = true
                            self.tableView.reloadData()
                        }
                        else {
                            print("Error in Liking")
                            self.view.isUserInteractionEnabled = true
                        }
                        self.tableView.reloadData()
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
//extension UITableView {
//    func returnIndexPath(cell: UITableViewCell) -> IndexPath?{
//        guard let indexPath = self.indexPath(for: cell) else {
//            return nil
//        }
//        return indexPath
//    }
//}
//
