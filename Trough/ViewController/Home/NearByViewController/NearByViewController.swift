//
//  NearByViewController.swift
//  Trough
//
//  Created by Irfan Malik on 19/12/2020.
//

import UIKit
import GoogleMaps
import CoreLocation
import SVProgressHUD

class NearByViewController: BaseViewController{
   
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarBottom: NSLayoutConstraint!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var scrollButton: UIButton!
    
    var timer : Timer?
    
    @IBOutlet weak var mapView: GMSMapView!
   // @IBOutlet weak var truckViewBtn: UIView!
    //@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var EventsFilterBtnView: UIView!
    @IBOutlet weak var TrucksFilterBtnView: UIView!
   // @IBOutlet weak var titleImageView: UIImageView!
    //@IBOutlet weak var eventViewBtn: UIView!
    //@IBOutlet weak var btnNext: UIButton!
    //@IBOutlet weak var btnBack: UIButton!
    //@IBOutlet weak var btnFilter: UIButton!
   // @IBOutlet weak var stepperProgressBarView: UIView!
    @IBOutlet weak var mainTopViewHeightConstraint:NSLayoutConstraint!
   // @IBOutlet weak var stepperProgressBarViewHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var searchViewheightConstraint:NSLayoutConstraint!

    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var searchText: UITextField!
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    var typesArray = ["Open","Cuisine","French","Barbecue","TopRated"]
    
    var currentTruckLocation:CLLocation?
    
    var firstCellVisible = false
    private var shouldCalculateScrollDirection = false
    private var lastContentOffset: CGFloat = 0
    private var scrollDirection: ScrollDirection = .up
    var locationManager = CLLocationManager()
    var isCreateNew = false
    var newEventModel = CreateEventViewModel()
    var location:CLLocation!
    var nearByList = [NearbyTrucksViewModel]()
    var eventList = [EventViewModel]()
    var truckId:String?
    var eventId:String?
    var parameters :[String: Any] = [:]
    var selectionArray = [Int]()
    var searchedTruck = [NearbyTrucksViewModel]()

    var selectedCategories = [CategoriesViewModel]()
    var markers = [GMSMarker]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategoriesList()
        self.configure()
        
//        mark collectionview
        
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellTwo")
//        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "FilterTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterTypeCollectionViewCell")
        self.collectionView.register(UINib.init(nibName: "FiltersButtonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FiltersButtonCollectionViewCell")
                
        //mark searchfield
        self.searchText.addTarget(self, action: #selector(NearByViewController.textFieldDidChange(_:)),for: .editingChanged)
        
        timer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
        self.getActivityListing()

//        timer?.tolerance = 0.2
        print("Timer fired!")
    }
     
    @objc func updateLocation(){
        self.locationManager.startUpdatingLocation()
        self.getActivityListing()
    }

    
    @IBAction func actionSearchTruck(_ sender: UITextField) {
        if sender.text == "" {
            nearByList  = searchedTruck
        }else {
            nearByList  = searchedTruck.filter({ (data) -> Bool in
//                return (data.name?.lowercased().contains(sender.text ?? ""))!
                (data.name?.lowercased().contains(sender.text?.lowercased() ?? ""))!
            })
        }
        tableView.reloadData()
    }
    @IBAction func actionfilter(_ sender: Any){
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier:"FiltersViewController") as! FiltersViewController
            self.navigationController?.pushViewController(VC, animated:true)
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
/*
        if self.isCreateNew{
            self.titleLabel.text = "Invite Truck"
            self.EventsFilterBtnView.isHidden = true
            self.TrucksFilterBtnView.isHidden = true
            self.btnNext.isHidden = false
            self.stepperProgressBarViewHeightConstraint.constant = 90
            self.stepperProgressBarView.isHidden = false
            self.btnBack.isHidden = false
            self.btnFilter.isHidden = true
            navBarHeight.constant = 50
            searchBarBottom.constant = -20
            
        }else{
            self.titleLabel.text = "Map"
            self.titleLabel.isHidden = true
            self.titleImageView.isHidden = true
            self.btnFilter.isHidden = true
            self.view.backgroundColor = .clear
            self.EventsFilterBtnView.isHidden = false
            self.TrucksFilterBtnView.isHidden = false
            self.btnNext.isHidden = true
            self.stepperProgressBarViewHeightConstraint.constant = 0
            self.stepperProgressBarView.isHidden = true
            self.btnBack.isHidden = true
            self.btnFilter.isHidden = false
            navBarHeight.constant = 0
            searchBarBottom.constant = -60
            
        }*/
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.searchViewheightConstraint.constant = 40
        self.tableView.register(UINib(nibName: "NearByTableViewCell", bundle: nil), forCellReuseIdentifier: "NearByTableViewCell")
    }
    
    
    @objc func textFieldDidChange (_ textField : UITextField){
        if textField == self.searchText{
            if textField.text != ""{
                UIView.animate(withDuration: 0.5) {
                    self.collectionViewHeight.constant = 60
                }
            }else{
                UIView.animate(withDuration: 0.5) {
                    self.collectionViewHeight.constant = 0
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.askPermission()
    }
    
  /*
    @IBAction func actionBack(_ sender:Any){
        self.mainContainer.currenController?.popViewController(animated: true)
    }
    
    @IBAction func actionFilter(_ sender:Any){
        let vc = UIStoryboard.init(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.mainContainer.present(vc, animated: true, completion: nil)
    }

    
    @IBAction func actionNext(_ sender:Any){
        let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
        self.newEventModel.TrucksInEvents = self.selectionArray
        vc.newEventModel = self.newEventModel
        self.mainContainer.currenController?.pushViewController(vc, animated: true)

    }*/

    @IBAction func buttonPressToggle(_ sender: UIButton) {
        
        //buttons -> your outlet collection
            for btn in buttons {
                if btn == sender {
                    btn.backgroundColor = btn.backgroundColor ==  #colorLiteral(red: 0.9511117339, green: 0.7289424539, blue: 0.2410626411, alpha: 1)  ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9511117339, green: 0.7289424539, blue: 0.2410626411, alpha: 1)
                } else {
                    btn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
            }
    }
    
    @IBAction func actionEvents(_ sender: UIButton) {
        mapView.clear()
        self.getActivityListing()
    }
    
    @IBAction func actionTrucks(_ sender: UIButton) {
        mapView.clear()
        self.getNearByTruckListing(location: nil, params: parameters)
    }
    
    @IBAction func actionScroll(_ sender: UIButton) {
        print("1234534")
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.searchViewheightConstraint.constant = 40
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                print(1)
            }
            if self.mainTopViewHeightConstraint.constant == 220{
                self.mainTopViewHeightConstraint.constant = self.view.frame.height*0.7
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
                print(2)
            }
        } else{
            self.searchViewheightConstraint.constant = 40
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        if self.mainTopViewHeightConstraint.constant != 220{
            self.mainTopViewHeightConstraint.constant = 220
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            print(3)
        }
            print(5)
    }
}
    
 
    //MARK: - Ask Location Access Permission
    func askPermission() {
        let alertController = UIAlertController(title: "Turn on", message: "Please go to Settings and turn on the location permissions", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        // check the permission status
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorize.")
            // get the user location
//            self.locationManager.requestAlwaysAuthorization()
//            self.locationManager.startUpdatingLocation()
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            self.locationManager.startUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            self.mapView.mapType = .normal
            
            //5
            case .notDetermined, .restricted, .denied:
            // redirect the users to settings
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
//            self.askPermission()
//            self.present(alertController, animated: true, completion: nil)
       
        }
    }
}

extension NearByViewController: GMSMapViewDelegate,CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.mapView.clear()
        if location.coordinate.latitude != 0.0{
            print(location)
            print("Stop")
            self.currentTruckLocation = location
            self.locationManager.stopUpdatingLocation()
            let params =
                [
                    
                    "radius"        : 25
                    
                ] as [String : Any]
            self.getNearByTruckListing(location: location, params: params)
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let marker1 = GMSMarker()
        let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker1.position = currentLocation
//        marker1.title = "Map"
//        marker1.snippet = "My Location"
//        marker1.icon = UIImage(named: "blue dot")
        marker1.isDraggable = true
        marker1.map = self.mapView
        self.mapView.selectedMarker = marker1
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.mainTopViewHeightConstraint.constant == 220
        
        {
            self.mainTopViewHeightConstraint.constant = self.view.frame.height*0.7
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }else{
           
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if marker.title == "Truck"{
            
            for place in self.nearByList{
                
                let coordinate0 = CLLocation(latitude: (currentTruckLocation?.coordinate.latitude)!, longitude: (currentTruckLocation?.coordinate.longitude)!)
                let coordinate1 = CLLocation(latitude: place.permanentLatitude!, longitude: place.permanentLongitude!)
                let distanceInMeters = coordinate0.distance(from: coordinate1)
                let distanceInMiles = distanceInMeters/1609.34
                print(distanceInMiles)
                let y = Double(round(100*distanceInMiles)/100)
                    if marker.accessibilityLabel! == String(place.truckId!){
                        print(marker.accessibilityLabel!)
                        print(place.truckId!)
                        let markerWindowView = Bundle.main.loadNibNamed("MarkerTruckWindow", owner: self, options: nil)?.first as! MarkerTruckWindow
                        
                        let frame = CGRect(x: 10, y: 10, width: 150, height: markerWindowView.frame.height)
                        markerWindowView.lblDistance.text = "\(y) Miles Away"
                        markerWindowView.lblName.text = place.name ?? ""
                        markerWindowView.lblCity.text = place.address ?? ""
                        markerWindowView.frame = frame
                        
                        return markerWindowView
                }
            }

        }
        else if marker.title == "Event"{
            for event in self.eventList{
                
                if marker.accessibilityLabel! == String(event.eventId!){
                        print(marker.accessibilityLabel!)
                        print(event.eventId!)
                        let markerWindowView = Bundle.main.loadNibNamed("MarkerWindow", owner: self, options: nil)?.first as! MarkerWindow
                            
                        let frame = CGRect(x: 10, y: 10, width: 280, height: markerWindowView.frame.height)
                        markerWindowView.frame = frame
                    
                    let coordinate0 = CLLocation(latitude: (currentTruckLocation?.coordinate.latitude)!, longitude: (currentTruckLocation?.coordinate.longitude)!)
                    let coordinate1 = CLLocation(latitude: event.latitude!, longitude: event.longitude!)
                    let distanceInMeters = coordinate0.distance(from: coordinate1)
                    let distanceInMiles = distanceInMeters/1609.34
                    print(distanceInMiles)
                    
                    let y = Double(round(100*distanceInMiles)/100)

                    markerWindowView.lblDistance.text = "\(String(y)) Miles Away"
                    markerWindowView.lblEventName.text = event.eventName!
                    markerWindowView.lblLocation.text = event.locationName!
                    
                    
//                    if event.imageUrl != "" && event.imageUrl != nil{
//                        let url = URL(string: BASE_URL+event.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//                        markerWindowView.eventImage.setImage(url: url)
//                    }else{
//                        markerWindowView.eventImage.image = UIImage(named: "PlaceHolder2")
//                    }
                    
                    if event.imageUrl != "" && event.imageUrl != nil{
                        if let url = URL(string: event.imageUrl ?? "") {
                            DispatchQueue.main.async {
                                markerWindowView.eventImage.setImage(url: url)
                            }
                        }
                    }else{
                        markerWindowView.eventImage.image = UIImage(named: "PlaceHolder2")
                    }
                    
                    
                    markers.append(marker)

                    return markerWindowView
                    }
            }
        }
            return nil
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if marker.title == "Truck"{
            for place in self.nearByList{
                if marker.accessibilityLabel! == String(place.truckId!){
                    print(marker.accessibilityLabel!)
                    print(place.truckId!)
                    let sb = UIStoryboard(name: "Home", bundle: nil)
                    if #available(iOS 13.0, *) {
                        let vc = sb.instantiateViewController(identifier: "TruckInfoViewController") as! TruckInfoViewController
                        vc.id = place.truckId ?? 0
                        
                        
                        
                        self.navigationController?.pushViewController( vc, animated: true)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        else if marker.title == "Event"{
            for place in self.eventList{
                if marker.accessibilityLabel! == String(place.eventId!){
                    print(marker.accessibilityLabel!)
                    print(place.eventId!)

                    let sb = UIStoryboard(name: "Home", bundle: nil)
                    if #available(iOS 13.0, *) {
                        let vc = sb.instantiateViewController(identifier: "NewEventDetialsViewController") as! NewEventDetialsViewController
                        vc.id = place.eventId ?? 0

                        let tappedState = place// eventList[index]
                        vc.event = tappedState
                        
//                        if let index = markers.index(of: marker) {
//                                let tappedState = eventList[index]
//                                vc.event = tappedState
//                            }

//                        for i in 0 ..< eventList.count {
//                            print(i)
//                        }
//                        for (index, list) in eventList.enumerated() {
//                            vc.event = list
//                            print("Item \(index): \(list)")
//                        }
                        self.navigationController?.pushViewController( vc, animated: true)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
    }
}

extension NearByViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearByList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByTableViewCell", for: indexPath) as! NearByTableViewCell
        cell.selectionStyle = .none
//        cell.index = indexPath.row
        cell.delegate = self
        cell.configure(nearBy: self.nearByList[indexPath.row])
        cell.onInvite = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyTruckEventViewController") as! MyTruckEventViewController
            let item = self.nearByList[indexPath.row]
            vc.eventFilter = item
            print(vc.eventFilter)
            self.navigationController?.pushViewController(vc, animated: true)
        }

//        if self.isCreateNew{
//            if self.selectionArray.contains(indexPath.row){
//                cell.truckInviteImageView.image = UIImage(named: "greenTick")
//            }else{
//                cell.truckInviteImageView.image = UIImage(named: "inviteTruckImage")
//            }
//
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if self.mainTopViewHeightConstraint.constant != 220{
//            self.mainTopViewHeightConstraint.constant = 220
//            UIView.animate(withDuration: 0.2) {
//                self.view.layoutIfNeeded()
//            }
//        }
        let vc = self.storyboard?.instantiateViewController(identifier: "TruckInfoViewController") as! TruckInfoViewController
        print("65748390")
        vc.id = nearByList[indexPath.row].truckId ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.firstCellVisible = indexPath.row == 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  190
    }
}
extension NearByViewController: FiltersViewControllerDelegate{
    func apiCallWithFilters(userLat: Double?, userLong: Double?, rating: Int?, radius: Double?, Ids: [Int]?, workHours: WorkHours?, isFilter: Bool) {
        
        if isFilter{
            let encoder = JSONEncoder()
            let data = try! encoder.encode(workHours!)
            let slots = String(data: data, encoding: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : [.allowFragments]) as? AnyObject
                
                {
                    print(jsonArray) // use the json here
                    let params =
                        [
                            //                "userLatitude"  : userLat,
                            //                "userLongitude" : userLong,
                            "radius"        : radius!,
                            "rating"        : rating!,
                            "categoryIds"   : Ids!,
                            "truckSlot"     : jsonArray
                        ] as [String : Any]
                    self.getNearByTruckListing(location: nil,params: params)
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
        }else{
            let params =
                [
                    "userLatitude"  : nil,
                    "userLongitude" : nil,
                    "radius"        : 25,
                    "rating"        : nil,
                    "categoryIds"   : []
                ] as [String : Any]
            self.getNearByTruckListing(location: nil,params: params)
        }
    }
}

// Get Event Listing Api Request
extension NearByViewController{
    func getNearByTruckListing(location: CLLocation?,params: [String : Any]){
        
        let service = NearByServices()
//        GCD.async(.Main) {
//            self.startActivityWithMessage(msg: "")
//        }
        GCD.async(.Default) {
            service.getNearByTrucksListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let nearByTruckList = serviceResponse.data as? [NearbyTrucksViewModel] {
                            self.nearByList = nearByTruckList
                            
                            self.nearByList.sort(){
                                $0.name ?? ""  < $1.name ?? ""
                            }
                            self.searchedTruck = self.nearByList
                            
                            
                            self.trucksSlotCalculate()
                            self.tableView.reloadData()
                            self.placeMarkers()
                            self.stopActivity()
                        }
                        else {
                            print("No Events Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.stopActivity()
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
    
    func trucksSlotCalculate(){
        for slot in self.nearByList{
            let date = Date()
            let calendar = Calendar.current
            let weekDay = calendar.component(.weekday, from: date)
//            let time = (slot.workHours?.filter{$0.dayOfWeek == weekDay})!
//            if Global.shared.truckTimeSlot.count>0{
//                for truck in Global.shared.truckTimeSlot{
//                    if truck.startTime == time.first!.startTime && truck.endTime == time.first!.endTime {
//                        
//                    }else{
//                        Global.shared.truckTimeSlot.append(contentsOf: time)
//                    }
//                }
//            }else{
//                Global.shared.truckTimeSlot.append(contentsOf: time)
//            }
        }
    }
    
    func placeMarkers(){
        for place in self.nearByList{
            DispatchQueue.main.async
            {
                self.marker(latitude: place.permanentLatitude!, longitude: place.permanentLongitude!, truckId: place.truckId!)
            }
        }
    }
    
    func marker(latitude : Double, longitude : Double, truckId: Int){
        let coordinate0 = CLLocation(latitude: (self.currentTruckLocation?.coordinate.latitude)!, longitude: (self.currentTruckLocation?.coordinate.longitude)!)
        let coordinate1 = CLLocation(latitude: latitude, longitude: longitude)
        let distanceInMeters = coordinate0.distance(from: coordinate1)
        print(distanceInMeters)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.isDraggable = true
        marker.title = "Truck"
        //marker.snippet = "\(distanceInMeters / 1609.34) miles away"
        marker.icon = UIImage(named: "delivery-truck 2")
        marker.accessibilityLabel = String(truckId)
        marker.map = self.mapView
    }
}

extension NearByViewController {
    func getActivityListing(){
        var params: [String:Any] = [String:Any]()
        params = [
                        "radius" : 25
        ] as [String : Any]

        let service = EventsServices()
//        SVProgressHUD.show()
        GCD.async(.Default) {
            service.getEventsListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
//                    SVProgressHUD.dismiss()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let eventsList = serviceResponse.data as? [EventViewModel] {
                            self.eventList = eventsList

//                            SVProgressHUD.dismiss()
                            if GlobalVariable.isEventShow{
                                self.EventPlaceMarkers()
                            }
                            
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
    func EventPlaceMarkers(){
        
        
        for event in self.eventList{
            DispatchQueue.main.async
            {
                self.EventMarker(latitude: event.latitude!, longitude: event.longitude!, eventId: event.eventId!)
            }
        }
    }
    
    func EventMarker(latitude : Double, longitude : Double,eventId:Int){
        let marker = GMSMarker()
        let coordinate0 = CLLocation(latitude: (self.currentTruckLocation?.coordinate.latitude)!, longitude: (self.currentTruckLocation?.coordinate.longitude)!)
        let coordinate1 = CLLocation(latitude: latitude, longitude: longitude)
        let distanceInMeters = coordinate0.distance(from: coordinate1)
        
        if distanceInMeters >= GlobalVariable.totalRange * 1609.34{
            
        }
        else{
            print("Event: \(distanceInMeters)")
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.isDraggable = true
            //marker.title = "20 Min away"
//            marker.icon = UIImage(named: "locationIcon")
            marker.icon = UIImage(named: "eventsPic")

            marker.title = "Event"
            self.eventId = String(eventId)
            marker.accessibilityLabel = self.eventId!
            marker.map = self.mapView
            //self.mapView.selectedMarker = marker
        }
        
    }
}


extension NearByViewController: NearByTableViewCellDelegate{
    func actionAddInivite(eventId: Int, trucksId: String, isInviting: Bool) {
        // do odod od
    }
    
    func truckInvite(index: Int) {
        //        if self.isCreateNew{
        //            if self.selectionArray.contains(index){
        //                let pos = self.selectionArray.firstIndex(of:index)
        //                self.selectionArray.remove(at: pos!)
        //            }else{
        //                self.selectionArray.append(index)
        //            }
        //            let index = IndexPath(row: index, section: 0)
        //            self.tableView.reloadRows(at: [index], with: .automatic)
        //        }else{
        //            if let vc = storyboard?.instantiateViewController(withIdentifier: "EventsListViewController") as? EventsListViewController{
        //                vc.isInvite = false
        //                vc.eventFilter = self.nearByList[index]
        //                self.mainContainer.present(vc, animated: true, completion: nil)
        //            }
        //        }
        
        let id = "\(self.nearByList[index].truckId ?? -1)"
        
        if self.newEventModel.truckIds == "" {
            self.newEventModel.truckIds.append(id)
        }else {
            self.newEventModel.truckIds.append(",\(id)")
        }
        
        if let vc =  UIStoryboard.init(name: StoryBoard.Home.rawValue, bundle: nil) .instantiateViewController(withIdentifier: "AddingTruckViewController") as? AddingTruckViewController{
            vc.isInvite = false
            vc.eventFilter = self.nearByList[index]
            vc.truckIds = self.newEventModel.truckIds
            self.mainContainer.present(vc, animated: true, completion: nil)
        }
    }
}


extension NearByViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedCategories.count
//        return self.typesArray.count
//  return 5
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: 60, height: 60)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltersButtonCollectionViewCell", for: indexPath) as! FiltersButtonCollectionViewCell
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterTypeCollectionViewCell", for: indexPath) as! FilterTypeCollectionViewCell
            cell.filterTyoeLabel.text = self.selectedCategories[indexPath.row].name
//            cell.filterTyoeLabel.text = self.typesArray[indexPath.row]
            
            return cell
        }
//        var cellIdentifire = ""
//        if indexPath.row == 0 {
//            cellIdentifire = "cellTwo"
//        }else {
//            cellIdentifire = "cell"
//        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifire, for: indexPath)
// cell.contentView.backgroundColor = .systemRed
//        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
                    let vc = UIStoryboard.init(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        //            vc.selectedIndex = indexPath.row
                    vc.modalPresentationStyle = .fullScreen
                    self.mainContainer.present(vc, animated: true, completion: nil)
        }
        else{
            let vc = self.storyboard?.instantiateViewController(identifier: "SelectedCategoryListViewController") as! SelectedCategoryListViewController
            vc.text = selectedCategories[indexPath.row].name ?? ""
            vc.categoryID = selectedCategories[indexPath.row].categoryId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension NearByViewController{
    //GetFoodCategories
    func getCategoriesList(){
        
        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]
        
        let service = UserServices()
        GCD.async(.Main) {
        }
        GCD.async(.Default) {
            
            service.GetFoodCategories(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        
                        if let categoriesList = serviceResponse.data as? [CategoriesViewModel] {
                            self.selectedCategories = categoriesList
                            self.selectedCategories.sort(){
                                $0.name ?? ""  < $1.name ?? ""
                            }
                            
                            self.collectionView.reloadData()

                            print("------")
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
}
