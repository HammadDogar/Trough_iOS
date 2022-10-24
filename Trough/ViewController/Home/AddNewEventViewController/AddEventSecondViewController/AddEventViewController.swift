//
//  AddEventViewController.swift
//  Trough
//
//  Created by Imed on 20/08/2021.
//

import UIKit
import MapKit
import MobileCoreServices
import GoogleMaps
import CoreLocation
import GooglePlaces


class AddEventViewController: BaseViewController, UITextViewDelegate  {
    
    
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var AddLocationButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addDateTimePicker: UITextField!
    @IBOutlet weak var InviteFriendButton: UIButton!
    @IBOutlet weak var InviteTruckButton: UIButton!
    @IBOutlet weak var addPhotoButton: NSLayoutConstraint!
    @IBOutlet weak var addDateTimeButton: UIButton!
    
    @IBOutlet weak var imageContainView: UIImageView!
    @IBOutlet weak var imageContainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var eventImage: UIImageView!
    
    var isImageAdded : Bool = false
    
    var locationManager = CLLocationManager()
    var location:CLLocation!
    var parameters :[String: Any] = [:]
    
    var truckIDS  : [Int] = []
    var selectedTruck = 0
    
    let key = "AIzaSyBrMcsZZbYR-LL8bX4BAffCyWMTVlD4gbs"
    
    var lat:Double = 0.0
    var lng:Double = 0.0
    var newEventModel = CreateEventViewModel()
    
//    var invitedfiendlist = [GetUserViewModel]()
    var invitedfiendlist = [FriendListViewModel]()

    var invitedTruckList = [NearbyTrucksViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        addDateTimePicker.inputView = dateTimePicker.inputView
        self.navigationItem.hidesBackButton = true
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Show the navigation bar on other view controllers
           self.navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! AddedItemPopupViewController
//        vc.invitedFriendList = self.newEventModel.userIds
//        vc.invitedTruckList = self.newEventModel.truckIds
//    }
//
    
    func configure(){
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        self.locationManager.delegate = self
        self.mapView.delegate = self
        
        self.newEventModel.EventName = eventTitleTextField.text ?? ""
        self.eventDetailsTextView.delegate = self
        self.eventDetailsTextView.text = "Event Details..."
        self.eventDetailsTextView.textColor = UIColor.lightGray
        self.mapView.isHidden = true
        self.mapViewHeight.constant = 1
        self.imageContainView.clipsToBounds = false
        self.imageContainView.isHidden = true
        self.imageContainViewHeight.constant = 1
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.eventDetailsTextView.textColor == UIColor.lightGray {
            self.eventDetailsTextView.text = ""
            self.eventDetailsTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.eventDetailsTextView.text == "" {
            self.eventDetailsTextView.text = "Event Details...."
            self.eventDetailsTextView.textColor = UIColor.lightGray
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
            // self.locationManager.requestAlwaysAuthorization()
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
    
    private lazy var dateTimePicker : DateTimePicker = {
        let picker = DateTimePicker()
        picker.setup()
        picker.didSelectDates = { [weak self] (startDate , endDate) in let text = Date.buildTimeRangeString(startDate: startDate, endDate: endDate)
            self?.addDateTimePicker.text = text
        }
        return picker
    }()
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPostEvent(_ sender: UIButton) {
        
        if eventTitleTextField.text!.isEmpty {
            simpleAlert(title: "Alert", msg: "Event name is missing")
        }
        
        if eventDetailsTextView.text!.isEmpty {
            simpleAlert(title: "Alert", msg: "Event detials name is missing")
        }
        if  self.newEventModel.Address.isEmpty {
            simpleAlert(title: "Alert", msg: "Event location name is missing")
        }
        
        if isImageAdded == false{
            simpleAlert(title: "Alert", msg: "Please add Event Image")
            return
        }
//        if self.eventTitleTextField.text  == ""{
//            simpleAlert(title: "Alert", msg: "Please add Event name")
//            return
//        }
//        createEvent()
        self.uploadImage()
    }
    
    @IBAction func actionAddLocation(_ sender: UIButton) {
        getLocation()
        self.mapView.isHidden = false
        self.mapViewHeight.constant = 160
    }
    
    func getLocation(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "addEventMapViewController") as? addEventMapViewController {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionInviteFriend(_ sender: UIButton) {
        let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier:"AddInviteFriendViewController") as! AddInviteFriendViewController
        vc.delegate = self
        self.mainContainer.currenController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionInviteTruck(_ sender: UIButton) {
        let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier:"AddTruckViewController") as! AddTruckViewController
        vc.delegate = self
        self.mainContainer.currenController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionInviteNeighbour(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddNeighbourhoodsViewController") as! AddNeighbourhoodsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAddedList(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddedItemPopupViewController") as! AddedItemPopupViewController
        vc.invitedfiendlist = self.invitedfiendlist
        vc.invitedTruckList = self.invitedTruckList
        present(vc, animated: (popoverPresentationController != nil), completion: nil)
    }
    
    @IBAction func actionCamera(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (action) in
            self.chooseFromLibrary(presentFrom: sender)
        }))
        alert.addAction(UIAlertAction(title: "Capture", style: .default, handler: { (action) in
            self.capturePhoto(presentFrom: sender)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension AddEventViewController {
    
    func chooseFromLibrary(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func capturePhoto(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension AddEventViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                
                self.eventImage.image = image
                
//                self.newEventModel.ImageFile = image
                
                
                
                print(self.newEventModel.ImageFile)
                self.isImageAdded = true
                
                self.imageContainView.isHidden = false
                self.imageContainViewHeight.constant = 160
                
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddEventViewController : CLLocationManagerDelegate, GMSMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        //        self.mapView.selectedMarker = nil
        self.mapView.clear()
    }
    
    func marker(latitude : Double, longitude : Double){
        let marker = GMSMarker()
        mapView.clear()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.isDraggable = true
        marker.map = self.mapView
        marker.icon = UIImage(named:  "blue dot")
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        self.mapView?.animate(to: camera)
      //  self.mapView.selectedMarker = marker
       
        //        marker(latitude: self.lat, longitude: self.lng)
        }
}
extension AddEventViewController : LOCATIONEVENTSELECT {
    func locationSelect(address: String, latitude: Double, lognitude: Double) {
        
        self.lat = latitude
        self.lng = lognitude
        
        mapView.clear()
        marker(latitude: latitude, longitude: lognitude)
        
        self.newEventModel.Latitude     = self.lat
        self.newEventModel.Longitude    = self.lng
        self.newEventModel.Address      = address
        
    }
}

extension AddEventViewController {
    
    //    func createNewEvent(){
    ////        let encoder = JSONEncoder()
    ////        let data = try! encoder.encode(self.newEventModel.EventSlots)
    //        let slots =  self.newEventModel.EventSlots.map({ $0.toDictionary() }) //String(data: data, encoding: .utf8)!
    ////        do {
    ////            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : [.allowFragments]) as? [String:AnyObject]
    ////            {
    ////               print(jsonArray) // use the json here
    ////            } else {
    ////                print("bad json")
    ////            }
    ////        } catch let error as NSError {
    ////            print(error)
    ////        }
    //
    
    func uploadImage(){
        if let image = self.eventImage.image {
            BlobUploadManager.shared.uploadFile(fileData: image.jpegData(compressionQuality: 0.5) ?? Data() , fileName: UUID().uuidString + ".jpg", folder: "User") { fileUrl, isCompleted in
                if isCompleted {
                    let urlString = BlobUploadManager.shared.imagesBaseUrl + fileUrl
                    self.createEvent(urlString: urlString)
                }
            }
        }
    }

    
    func createEvent(urlString: String){
        
        //        let encoder = JSONEncoder()
        //        let data = try! encoder.encode(self.newEventModel.EventSlots)
        //        let slots = String(data: data, encoding: .utf8)!
        //        do {
        //            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : [.allowFragments]) as? [String:AnyObject]
        //            {
        //               print(jsonArray) // use the json here
        //            } else {
        //                print("bad json")
        //            }
        //        } catch let error as NSError {
        //            print(error)
        //        }
        let slots =  self.newEventModel.EventSlots.map({ $0.toDictionary() })
        
        let params = [
            "EventId"           : self.newEventModel.eventId,
            "EventName"         : self.eventTitleTextField.text ?? "",
            "Description"       : self.eventDetailsTextView.text ?? "",
            "LocationName"      : self.newEventModel.Address,
            //                "Pakistan",
            "Address"           : self.newEventModel.Address,
            "Latitude"          : self.newEventModel.Latitude,
            "Longitude"         : self.newEventModel.Longitude,
            "Type"              : "public",
            //"TrucksInEvents"    : self.newEventModel.TrucksInEvents,
            //"UsersInEvents"     : self.newEventModel.UsersInEvents,
            "EventSlots"        : slots,
//            "ImageFile"         : self.newEventModel.ImageFile,
            "ImageFile": urlString,

            "TruckIds"          :  self.newEventModel.truckIds,
            "UserIds"               : self.newEventModel.userIds
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
                        }
                        else {
                            print("Event is not created")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Event", msg: "Event was not created")
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


extension AddEventViewController :  AddTruckViewControllerDelegate    {
    func addTruck(truckList: [NearbyTrucksViewModel]) {
    
        let idArray = truckList.map({ (id: NearbyTrucksViewModel) -> Int in
            id.truckId ?? 0
            
        })
        let array = idArray.map{String($0)}.joined(separator: ",")
        self.newEventModel.truckIds = array
        self.invitedTruckList = truckList
        print(truckList)
    }
//    func addTruck(truckID: [Int]) {
//        let array  = truckID.map{String($0)}.joined(separator: ",")
//        self.newEventModel.truckIds = array
//
//    }
}

extension AddEventViewController : AddInviteFriendViewControllerDelegate{

//    func addFriend(friendList : [GetUserViewModel]) {
//
//        let idArray = friendList.map({ (id: GetUserViewModel) -> Int in
//            id.userId ?? 0
//
//        })
//        let array = idArray.map{String($0)}.joined(separator: ",")
//        self.newEventModel.userIds = array
//
//        self.invitedfiendlist = friendList
//        print(friendList)
//
//    }
    func addFriend(friendList : [FriendListViewModel]) {

        let idArray = friendList.map({ (id: FriendListViewModel) -> Int in
            id.userId ?? 0
            
        })
        let array = idArray.map{String($0)}.joined(separator: ",")
        self.newEventModel.userIds = array
        
        self.invitedfiendlist = friendList
        print(friendList)
        
    }
//    func addFriend(friendID: [Int]) {
//        let array  = friendID.map{String($0)}.joined(separator: ",")
//        self.newEventModel.userIds = array
//
//    }
}
