//
//  InviteTruckViewController.swift
//  Trough
//
//  Created by Irfan Malik on 27/01/2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class InviteTruckViewController: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate{

    
      @IBOutlet weak var searchBarBottom: NSLayoutConstraint!
      @IBOutlet weak var navBarHeight: NSLayoutConstraint!
      @IBOutlet weak var tableView: UITableView!
      @IBOutlet weak var mapView: GMSMapView!
     // @IBOutlet weak var truckViewBtn: UIView!
      @IBOutlet weak var titleLabel: UILabel!
      @IBOutlet weak var EventsFilterBtnView: UIView!
      @IBOutlet weak var TrucksFilterBtnView: UIView!
      @IBOutlet weak var titleImageView: UIImageView!
      //@IBOutlet weak var eventViewBtn: UIView!
      @IBOutlet weak var btnNext: UIButton!
      @IBOutlet weak var btnBack: UIButton!
      @IBOutlet weak var btnFilter: UIButton!
      @IBOutlet weak var stepperProgressBarView: UIView!
      @IBOutlet weak var mainTopViewHeightConstraint:NSLayoutConstraint!
      @IBOutlet weak var stepperProgressBarViewHeightConstraint:NSLayoutConstraint!
      @IBOutlet weak var searchViewheightConstraint:NSLayoutConstraint!

    @IBOutlet weak var scrollButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
      
      
      var firstCellVisible = false
      private var shouldCalculateScrollDirection = false
      private var lastContentOffset: CGFloat = 0
      private var scrollDirection: ScrollDirection = .up
      var locationManager = CLLocationManager()
      var isCreateNew = false
      var newEventModel = CreateEventViewModel()
      var location:CLLocation!
      var nearByList = [NearbyTrucksViewModel]()
      var parameters : [String: Any] = [:]
      var selectionArray = [Int]()
    

      override func viewDidLoad() {
          super.viewDidLoad()
          self.configure()
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
              
          }
        
          self.locationManager.delegate = self
          self.mapView.delegate = self
          self.searchViewheightConstraint.constant = 40
          self.tableView.register(UINib(nibName: "NearByTableViewCell", bundle: nil), forCellReuseIdentifier: "NearByTableViewCell")
      }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          self.askPermission()
      }
      
      @IBAction func actionBack(_ sender:Any){
          self.mainContainer.currenController?.popViewController(animated: true)
      }
      
      @IBAction func actionFilter(_ sender:Any){
          let vc = UIStoryboard.init(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
          //vc.delegate = self
          vc.modalPresentationStyle = .fullScreen
          self.mainContainer.present(vc, animated: true, completion: nil)
      }

      
      @IBAction func actionNext(_ sender:Any){
          let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
          self.newEventModel.TrucksInEvents = self.selectionArray
          vc.newEventModel = self.newEventModel
          self.mainContainer.currenController?.pushViewController(vc, animated: true)

      }
    @IBAction func actionScroll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.searchViewheightConstraint.constant = 40
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            if self.mainTopViewHeightConstraint.constant == 220{
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
        if self.mainTopViewHeightConstraint.constant != 220{
            self.mainTopViewHeightConstraint.constant = 220
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
            }
    }
    
      @IBAction func buttonPressToggle(_ sender: UIButton) {
          
          //buttons -> your outlet collection
              for btn in buttons {
                  if btn == sender {
                      btn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                  } else {
                    btn.backgroundColor = #colorLiteral(red: 0.9511117339, green: 0.7289424539, blue: 0.2410626411, alpha: 1)
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

  extension InviteTruckViewController//: GMSMapViewDelegate,CLLocationManagerDelegate
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
          if self.mainTopViewHeightConstraint.constant == 220
          
          {
              self.mainTopViewHeightConstraint.constant = self.view.frame.height*0.7
              UIView.animate(withDuration: 0.2) {
                  self.view.layoutIfNeeded()
              }
          }else{
             
          }
      }
  }


  extension InviteTruckViewController: UITableViewDelegate,UITableViewDataSource{
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.nearByList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "NearByTableViewCell", for: indexPath) as! NearByTableViewCell
          cell.selectionStyle = .none
//          cell.index = indexPath.row
          cell.delegate = self
          cell.configure(nearBy: self.nearByList[indexPath.row])
//          if self.isCreateNew{
              if self.selectionArray.contains(indexPath.row){
                  cell.truckInviteImageView.image = UIImage(named: "tickGray")
              }else{
                  cell.truckInviteImageView.image = UIImage(named: "inviteTruckImage")
              }
        if selectionArray.count == 3{
                let alertController = UIAlertController(title: "Added Trucks", message:
                        "Third Truck added anymore Truck will not be added", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            cell.truckInviteImageView.isHidden = true
            cell.btnInvite.isEnabled = false
            cell.btnInvite.isHidden = true
            self.present(alertController, animated: true)
        }
          else if selectionArray.count < 3 {
              cell.truckInviteImageView.isHidden = false
              cell.btnInvite.isEnabled = true
          }
          
//          }
          
          return cell
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
          if self.mainTopViewHeightConstraint.constant != 220{
              self.mainTopViewHeightConstraint.constant = 220
              UIView.animate(withDuration: 0.2) {
                  self.view.layoutIfNeeded()
              }
          }
      }
      
      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          self.firstCellVisible = indexPath.row == 0 ? true : false
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return  190
      }
  }

  extension InviteTruckViewController: FiltersViewControllerDelegate{
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
  extension InviteTruckViewController{
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
//              let time = (slot.workHours?.filter{$0.dayOfWeek == weekDay})!
//              if Global.shared.truckTimeSlot.count>0{
//                  for truck in Global.shared.truckTimeSlot{
//                      if truck.startTime == time.first!.startTime && truck.endTime == time.first!.endTime {
//                          
//                      }else{
//                          Global.shared.truckTimeSlot.append(contentsOf: time)
//                      }
//                  }
//              }else{
//                  Global.shared.truckTimeSlot.append(contentsOf: time)
//              }
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



extension InviteTruckViewController: NearByTableViewCellDelegate{
    func actionAddInivite(eventId: Int, trucksId: String, isInviting: Bool) {
        // do do
    }
      func truckInvite(index: Int) {
                let id = "\(self.nearByList[index].truckId ?? -1)"
                if self.newEventModel.truckIds == "" {
                    self.newEventModel.truckIds.append(id)
                }else {
                    self.newEventModel.truckIds.append(",\(id)")
                }
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
 
