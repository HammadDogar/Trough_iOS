//
//  AddTruckViewController.swift
//  Trough
//
//  Created by Imed on 20/08/2021.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol AddTruckViewControllerDelegate  {
    func addTruck(truckList : [NearbyTrucksViewModel])
}


class AddTruckViewController :  BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var scrollButton: UIButton!
    @IBOutlet weak var mainTopViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewheightConstraint: NSLayoutConstraint!
    
    var firstCellVisible = false
    private var shouldCalculateScrollDirection = false
    private var lastContentOffset: CGFloat = 0
    private var scrollDirection: ScrollDirection = .up
    var locationManager = CLLocationManager()
    var isCreateNew = false
    var newEventModel = CreateEventViewModel()
    var location:CLLocation!
    var nearByList = [NearbyTrucksViewModel]()
    var parameters :[String: Any] = [:]
    var selectionArray = [NearbyTrucksViewModel]()
    
    var delegate : AddTruckViewControllerDelegate?
    
    var searchedTruck = [NearbyTrucksViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.configure()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.askPermission()
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
        if self.isCreateNew{
            
            self.titleLabel.text = "Add Truck"
            self.filterButton.isHidden = true
            
        }
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.tableView.register(UINib(nibName: "NearByTableViewCell", bundle: nil), forCellReuseIdentifier: "NearByTableViewCell")
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.mainContainer.currenController?.popViewController(animated: true)
    }
    
    @IBAction func actionDone(_ sender: UIButton) {

        delegate?.addTruck(truckList: self.selectionArray)
        
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func actionFilter(_ sender: UIButton){
        
        let vc = UIStoryboard.init(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        //vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.mainContainer.present(vc, animated: true, completion: nil)
    }
    @IBAction func actionScroll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.searchViewheightConstraint.constant = 40
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            if self.mainTopViewHeightConstraint.constant == 200
            {
                self.mainTopViewHeightConstraint.constant = self.view.frame.height*0.7
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        } else{
            self.searchViewheightConstraint.constant = 40
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            if self.mainTopViewHeightConstraint.constant != 200{
                self.mainTopViewHeightConstraint.constant = 200
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
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
            self.locationManager.startUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.mapView.isMyLocationEnabled = true
            self.mapView.mapType = .normal
            //5
//            self.mapView.settings.myLocationButton = true
        case .notDetermined, .restricted, .denied:
            // redirect the users to settings
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
//            self.askPermission()
//            self.present(alertController, animated: true, completion: nil)
       
        }
    }
}

extension  AddTruckViewController//: GMSMapViewDelegate,CLLocationManagerDelegate
{
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        guard let location = locations.first else {
            return
        }
        if location.coordinate.latitude != 0.0{
            print(location)
            print("Stop")
            self.locationManager.stopUpdatingLocation()
            let params =
                [
                    "userLatitude"  : nil,
                    "userLongitude" : nil,
                    "radius"        : 25,
                    "rating"        : nil,
                    "categoryIds"   : []
                ] as [String : Any]
            self.getNearByTruckListing(location: location, params: params)
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.mapView.selectedMarker = nil
        self.mapView.clear()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.mainTopViewHeightConstraint.constant == 200
        
        {
            self.mainTopViewHeightConstraint.constant = self.view.frame.height*0.7
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }else{
           
        }
    }
}

// Get Event Listing Api Request
extension AddTruckViewController{
    func getNearByTruckListing(location: CLLocation?,params: [String : Any]){
        
        let service = NearByServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
          
        }
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
        }
    }
    
    func placeMarkers(){
        for place in self.nearByList{
            DispatchQueue.main.async
            {
                self.marker(latitude: place.permanentLatitude!, longitude: place.permanentLongitude!)
            }
        }
    }
    
    func marker(latitude : Double, longitude : Double){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.isDraggable = true
        marker.title = "20 Min away"
        marker.map = self.mapView
      marker.icon = UIImage(named: "delivery-truck 2")
        self.mapView.selectedMarker = marker
    }
}

@available(iOS 13.0, *)
extension AddTruckViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearByList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByTableViewCell", for: indexPath) as! NearByTableViewCell
        cell.selectionStyle = .none
        
        let item = self.nearByList[indexPath.row]
        cell.configure(nearBy: item)

//        cell.index = indexPath.row
//        cell.delegate = self
//in previous flow
//        cell.configure(nearBy: self.nearByList[indexPath.row])
//        if self.selectionArray.contains(self.nearByList[indexPath.row].truckId ?? 0){
        
            if self.selectionArray.contains(where: { $0.truckId  ==  item.truckId  ?? 0
            }){
            cell.truckInviteImageView.image = UIImage(named: "foodCheckedBox")
            cell.truckInviteImageViewHeight.constant = 40
            cell.truckInviteImageViewWidth.constant = 40
        }else{
            cell.truckInviteImageView.image = UIImage(named: "inviteTruckImage")
        }

        cell.onInvite = { [weak self] in
            
            guard let self = self else {return}
            
            if self.selectionArray.count >= 3{
                
                if let obj = self.selectionArray.first(where: {$0.truckId == item.truckId}) {
                    self.selectionArray.removeAll(where: {$0.truckId == obj.truckId})
                }else {
                    let alertController = UIAlertController(title: "Added Trucks", message:
                                                                "Third Truck added anymore Truck will not be added", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true)
                    return
                }
            }else {
                self.selectionArray.append(item)
            }
              self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
//            let id =  self.nearByList[indexPath.row].truckId  ??  -1
//            if self.newEventModel.truckIds == "" {
//                self.newEventModel.truckIds.append("\(id)")
//            }else {
//                self.newEventModel.truckIds.append(",\(id)")
//            }
//            if self.selectionArray.contains(id){
//                self.selectionArray.removeAll(where: {$0 == id})
//            }else{
//                self.selectionArray.append(id)
//            }
        }
        
        return cell
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
//            if self.mainTopViewHeightConstraint.constant != 200{
//                self.mainTopViewHeightConstraint.constant = 200
//                UIView.animate(withDuration: 0.2) {
//                    self.view.layoutIfNeeded()
//                }
//            }
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "TruckMenuViewController") as TruckMenuViewController
            vc.id = nearByList[indexPath.row].truckId ?? 0
            
//            vc.cartButton.isEnabled = false
            self.navigationController?.pushViewController(vc, animated: true)

        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.firstCellVisible = indexPath.row == 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  190
    }
}

