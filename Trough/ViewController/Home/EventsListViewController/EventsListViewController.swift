//
//  EventsListViewController.swift
//  Trough
//
//  Created by Irfan Malik on 18/12/2020.
//

import UIKit
import CoreLocation

class EventsListViewController: BaseViewController, EventTableViewCellDelegate {
    func didSelectTruck(truckId : Int,eventId : Int) {
        //        let vc  = UIViewController()
        //        vc.id = myTrucks
        //        navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
    
    func editEvent(index: Int) {
        ///
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchViewheightConstraint:NSLayoutConstraint!
    @IBOutlet weak var btnAddEvent: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var userID = ""
    var locationManager: CLLocationManager!
    var eventList = [EventViewModel]()
    var eventListFiltered = [EventViewModel]()
    
    var searchedEvent = [EventViewModel]()
    
    var friendList = [FriendListViewModel]()
    
    var firstCellVisible = false
    var isInvite = false
    var eventFilter : NearbyTrucksViewModel?
    
    var newEventModel = CreateEventViewModel()
    
    
    private var shouldCalculateScrollDirection = false
    private var lastContentOffset: CGFloat = 0
    private var scrollDirection: ScrollDirection = .up
    
    // For City
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    let geoCoder = CLGeocoder()
    var latitude =  0.0
    var longitude =  0.0
    var userCity = ""
    var cityList = [ServicesCitesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.searchViewheightConstraint.constant = 0
        self.noResultLabel.isHidden = true
        self.searchTextField.autocapitalizationType = .none
        self.searchTextField.autocorrectionType = .no
        tableView.reloadData()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if (CLLocationManager.locationServicesEnabled())
        {
            locManager = CLLocationManager()
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.requestAlwaysAuthorization()
            locManager.startUpdatingLocation()
        }
        self.getEventsListing()
        self.getFriendList()
        if Global.shared.currentUser.serviceCityName != "" {
             addCity()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        self.getEventsListing()
//        self.getFriendList()
        if self.isInvite{
            self.btnAddEvent.isHidden = true
            self.searchView.isHidden = true
        }else{}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configure(){
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        
    }
    @IBAction func actionNotification(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionSearch(_ sender: UITextField) {
        if sender.text == "" {
            eventList  = searchedEvent
        }else {
            eventList  = searchedEvent.filter({ (data) -> Bool in
                //                return (data.eventName!.lowercased().contains(sender.text ?? ""))
                (data.eventName?.lowercased().contains(sender.text?.lowercased() ?? ""))!
            })
        }
        tableView.reloadData()
    }
    @IBAction func actionMyEvent(_ sender: Any) {
        let vc =  UIStoryboard.init(name: StoryBoard.Home.rawValue, bundle: nil) .instantiateViewController(withIdentifier:"MyEventViewController") as! MyEventViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionNewEvent(_ sender: Any){
        
        let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier:"EventAddDateTimeViewController") as! EventAddDateTimeViewController
        //        self.mainContainer.currenController?.pushViewController(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
        //
        //        let alert = UIAlertController(title: "Alert", message: "New Add-Event Flow is in Making", preferredStyle: UIAlertController.Style.alert)
        //
        //        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
        //        }))
        //        self.present(alert, animated: true, completion: nil)
        
    }
}

// MARK:- Table View Delegate

extension EventsListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isInvite{
            (self.eventListFiltered.count > 0) ? (self.noResultLabel.isHidden = true) : (self.noResultLabel.isHidden = false)
            return self.eventListFiltered.count
        }else{
            (self.eventList.count > 0) ? (self.noResultLabel.isHidden = true) : (self.noResultLabel.isHidden = false)
            return self.eventList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell{
            cell.eventEditButton.isHidden = true
            
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.mainView.shadow = true
            cell.collectionView.isHidden = true
            cell.mainViewhieght.constant = 290
            
            cell.bottomViewHeightConstraint.constant = 0
            cell.collectionViewHeightConstraint.constant = 0
            cell.addTruckToEventButton.isHidden = true
            cell.eventDescriptionLabel.sizeToFit()
            cell.delegate = self
            
            var item: EventViewModel?
            if self.isInvite{
                item = self.eventListFiltered[indexPath.row]
            }else{
                item = self.eventList[indexPath.row]
            }
            cell.configure(event: item!)
            
            //            let height = item?.description?.heightWithConstrainedWidth(width: cell.eventDescriptionLabel.frame.width, font: UIFont(name: "Poppins-Medium", size: 10)!)
            //            cell.eventDescriptionHeightConstraint.constant = (((height ?? 10) > 80 ? 80 : height) ?? 30)
            
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.firstCellVisible = indexPath.row == 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        if self.isInvite{
        //            // call truck invitation api
        //            let idsTrucks = [self.eventFilter?.truckId] as! [Int]
        //            self.truckInviteEvents(eventId: self.eventListFiltered[indexPath.row].eventId!, trucksId: idsTrucks)
        //        }else{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewEventDetialsViewController") as! NewEventDetialsViewController
        
        //commented for new view
        
        let event = self.eventList[indexPath.row]
        vc.event = event
        //
        self.navigationController?.pushViewController(vc, animated: true)
        //        }
        //    var vc: UIViewController = UIViewController()
        //        vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

// MARK:- Event List delegate

extension EventsListViewController: AddOrRemoveFriendDelgeate{
    
    func AddRemoveFriend() {
        self.getFriendList()
        self.getEventsListing()
        
    }
    
    func eventImageAction(index: Int) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as? AddFriendViewController{
            vc.delegate = self
            for friendList in self.friendList{
                print(eventList[index].createdById!)
                print(friendList.userId!)
                if eventList[index].createdById! == friendList.userId!{
                    vc.isFriend = true
                }
            }
            vc.list = eventList[index]
            self.present(vc, animated: true, completion: nil)
        }
        
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
                            print(path)
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
}

extension EventsListViewController {
    func perfromNotificationAction() {
        if self.isFromNotification {
            //show details screen
            let myEvent = eventList.first
            
            if let vc =  UIStoryboard.init(name: StoryBoard.Home.rawValue, bundle: nil) .instantiateViewController(withIdentifier: "NewEventDetialsViewController") as? NewEventDetialsViewController  {
                
                vc.event = myEvent
                self.mainContainer.currenController?.pushViewController(vc, animated: true)
            }
            self.resetNotificationFlag()
        }
    }
}
// Event Going/Maybe Status Api Request
extension EventsListViewController{
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

// Get Event Listing Api Request
extension EventsListViewController{
    func getEventsListing(isloader:Bool = true,isReloadData:Bool = true){
        var params: [String:Any] = [String:Any]()
        if self.isInvite{
            params = ["createdById": Global.shared.currentUser.userId!]
        }else{
            params = [:
                        //            "userId" : "",
                      //            "userLatitude" : 31.43123116444423,
                      //            "userLongitude" : 74.2935532173374,
                      //            "radius" : 25
            ] as [String : Any]
        }
        
        let service = EventsServices()
//        if isloader{
//            GCD.async(.Main) {
//                self.startActivityWithMessage(msg: "")
//            }
//        }
        
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
                            
                            self.searchedEvent = self.eventList
                            
                            if self.isInvite{
                                if self.eventFilter?.eventIds?.count != nil{
                                    self.eventListFiltered = self.eventList.filter{ event in
                                        for id in self.eventFilter!.eventIds!{
                                            return event.eventId != id.eventId
                                        }
                                        return false
                                    }
                                }
                            }
                            
                            if isReloadData{
                                self.tableView.reloadData()
                            }
                            self.perfromNotificationAction()
                            
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

extension EventsListViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // The current offset
        let offset = scrollView.contentOffset.y
        
        // Determine the scolling direction
        if lastContentOffset > offset && shouldCalculateScrollDirection {
            scrollDirection = .down
        }
        else if lastContentOffset < offset && shouldCalculateScrollDirection {
            scrollDirection = .up
        }
        switch scrollDirection {
        case .down:
            // Do something for scollDirection up
            if self.firstCellVisible{
                self.searchViewheightConstraint.constant = 40
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        case .up:
            // Do something for scollDirection down
            if !self.firstCellVisible{
                self.searchViewheightConstraint.constant = 0
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        // This needs to be in the last line
        lastContentOffset = offset
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        shouldCalculateScrollDirection = false
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        shouldCalculateScrollDirection = false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shouldCalculateScrollDirection = true
    }
}
extension EventsListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        if location.coordinate.latitude != 0.0{
            print(location)
            print("Stop")
            self.locationManager.stopUpdatingLocation()
            self.getEventsListing()
            
            /* you can use these values*/
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            
            self.latitude = lat
            self.longitude = long
            
                        let location = CLLocation(latitude: self.latitude, longitude:  self.longitude) // <- New York
//            let location = CLLocation(latitude: 40.730610, longitude:  -73.935242) // <- New York
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
                placemarks?.forEach { (placemark) in
                    if let city = placemark.locality { print(city)
                        self.userCity = city
                    } // Prints "user current city"
                  
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
}


// MARK:- Get Friend List

extension EventsListViewController{
    
    func getFriendList(){
        
        var params: [String:Any] = [String:Any]()
        params = [:]
        
        let service = UserServices()
        GCD.async(.Main) {
            
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
                            self.friendList = friendList
                            
                            
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
    
}

//MARK:- Stripe

extension EventsListViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func addCity(){
        let params =
            [
                "ServicesCity"        : self.userCity
            ] as [String : Any]
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.addServicesCity(params: params, ServicesCity:  self.userCity) { serviceResponse in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            self.simpleAlert(title: "Success", msg: "done done")
                        }
                        else {
                            self.simpleAlert(title: "Services", msg: "Couldn't find your city in our services area ")
                            print("Error adding city")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error adding city")
                        self.simpleAlert(title: "Services", msg: "Couldn't find your city in our services area but we have requested your city to admin for approval in our services area")
//                        self.requestCity()
                    }
                default :
                    GCD.async(.Main) {
                        print("Error adding city")
                    }
                }
            }
        }
    }
    
    
    func requestCity(){
        let params =
            [
                "ServicesCity"        : self.userCity
//                "userRoleId"        : 3
            ] as [String : Any]
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        print(params)
        let city : String = self.userCity
        let service = UserServices()
        
        GCD.async(.Default) {
            service.requestServicesCity(params: params, ServicesCity: city) { serviceResponse in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            let alert = UIAlertController(title: "Success", message: "Your city was requested to the admin", preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (_) in
                      
                            self.moveToHome(isFromNotification: false)
    
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            print("Error adding city")
                        }

                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error adding city")
                    }
                default :
                    GCD.async(.Main) {
                        print("Error adding city")
                        
                    }
                }
            }
        }
    }
    
}
