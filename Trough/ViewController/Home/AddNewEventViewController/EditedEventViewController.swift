//
//  EditedEventViewController.swift
//  Trough
//
//  Created by Imed on 02/06/2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import MobileCoreServices

protocol EditedEventViewDelegate {
    func didEdit(tapped : Bool)
}

class EditedEventViewController: BaseViewController, UITextViewDelegate, FriendTableViewCellDelegate, NearByTableViewCellDelegate {
    func truckInvite(index: Int) {
      
//      let alertController = UIAlertController(title: "Food Truck", message:
//              "Food Truck, added!", preferredStyle: .alert)
//          alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
//          self.present(alertController, animated: true, completion: {
              let id = "\(self.nearByList[index].truckId ?? -1)"
              if self.newEventViewModel.truckIds == "" {
                self.newEventViewModel.truckIds.append(id)
              }else {
                self.newEventViewModel.truckIds.append(",\(id)")
              }
                if self.selectionArray.contains(index){
                let pos = self.selectionArray.firstIndex(of: index)
                self.selectionArray.remove(at: pos!)
                }else{
                self.selectionArray.append(index)
                }
                let index = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [index], with: .automatic)
//          })
    }
    
    func actionAddInivite(eventId: Int, trucksId: String, isInviting: Bool) {
        // do do
    }
    func inviteFriend(index: Int) {
        //self.selectionArray.append(index)
        if self.selectionArray.contains(index){
            let pos = self.selectionArray.firstIndex(of: index)
            self.selectionArray.remove(at: pos!)
        }else{
            self.selectionArray.append(index)
        }
        let index = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [index], with: .automatic)
    }
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectEventDateTextField: UITextField!
    @IBOutlet weak var selectEventTimeTextField: UITextField!
    @IBOutlet weak var EnterAddressTextField: UITextField!
    @IBOutlet weak var selectEventEndTimeTextField: UITextField!
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var btnCameraImage: UIButton!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    let myPickerView = UIPickerView()
    var currentList:[String] = []
    var activeTextField:UITextField!
    var newEventModel = EventViewModel()
    var newEventViewModel = CreateEventViewModel()
    var dateString = ""
    let locationList = ["New York","LA","CF"]
    var locationManager = CLLocationManager()
    var isImageAdded : Bool = false
    var isCreateNew = false
    var location:CLLocation!
    var nearByList = [NearbyTrucksViewModel]()
    var parameters :[String: Any] = [:]
    var firstCellVisible = false
    var eventId:Int = -1
    var index = -1
    var myEvent: EventViewModel?
    var getUser = [GetUserViewModel]()
    var selectionArray = [Int]()
    var lat:Double = 0.0
    var lng:Double = 0.0
    
    var tapped = true
    
    var delegateEdit : EditedEventViewDelegate?
    
    weak var delegate:FriendTableViewCellDelegate?
    
    var addedTrucks = [InvitedTrucks]()
    
    let key = "AIzaSyBrMcsZZbYR-LL8bX4BAffCyWMTVlD4gbs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EnterAddressTextField.delegate = self
        self.configure()
        self.askPermission()
        self.mapping(event: newEventModel)
//        print(mapping(event: newEventModel))
        getAllUser()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.EnterAddressTextField.delegate = self
        self.navigationController?.isNavigationBarHidden = true

    }
        func getAllUser(){
        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.getAllUser(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let userData = serviceResponse.data as? [GetUserViewModel] {
                            
                            self.getUser = userData
                            print(userData)
                            
                            self.tableView.reloadData()
                    }
                    else {
                        print("No User Found!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No User Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No User Found!")
                    }
                }
            }
        }
    }
    
    func mapping(event: EventViewModel){
        
        self.eventId = event.eventId ?? -1
        self.myEvent = event
        
        self.eventTitleTextField.text = "\(event.eventName ?? "")"
        self.eventDetailsTextView.text = "\(event.description ?? "")"
        let eventStartDate = event.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        self.selectEventDateTextField.text = "\(eventStartDate?.string(with: .custom("MMMM-dd-yyyy")) ?? "")"
        self.EnterAddressTextField.text = "\(event.address ?? "")"
        self.selectEventTimeTextField.text = "\(event.eventSlots?.first?.startTime ?? "")"
//        event.eventSlots?.first?.startTime?.timeConversion12()
        self.selectEventEndTimeTextField.text = "\(event.eventSlots?.first?.endTime ?? "")"
//            event.eventSlots?.first?.endTime?.timeConversion12()
//
        
        
//         if event.imageUrl != "" && event.imageUrl != nil{
//             let url = URL(string: BASE_URL+event.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//             self.eventImageView.setImage(url: url)
//         }else{
//             self.eventImageView.image = UIImage(named: "PlaceHolder2")
//         }
        
        if event.imageUrl != "" && event.imageUrl != nil{
            if let url = URL(string: event.imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.eventImageView.setImage(url: url)
                }
            }
        }else{
            self.eventImageView!.image = UIImage(named: "PlaceHolder2")
        }
        
        self.addedTrucks = event.invitedTrucks ?? event.invitedTrucks as! [InvitedTrucks]
        
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
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UINib(nibName:"NearByTableViewCell", bundle: nil), forCellReuseIdentifier: "NearByTableViewCell")
        self.tableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        self.tableView.register(UINib(nibName: "AddedTrcuksCell", bundle: nil), forCellReuseIdentifier: "AddedTrcuksCell")
        
        
        self.mapView.delegate = self
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        
        let pickerDate = UIDatePicker()
        pickerDate.datePickerMode = .date
        pickerDate.minimumDate = Date()
        if #available(iOS 13.4, *) {
            pickerDate.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.selectEventDateTextField.inputView = pickerDate
        pickerDate.addTarget(self, action: #selector(dateIsChanged(sender:)), for: .valueChanged)
        
        let pickerTime = UIDatePicker()
        pickerTime.datePickerMode = .time
        pickerTime.locale = Locale.init(identifier: "en_gb")
        
        if #available(iOS 13.4, *) {
            pickerTime.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.selectEventTimeTextField.inputView = pickerTime
        pickerTime.addTarget(self, action: #selector(TimeIsChanged(sender:)), for: .valueChanged)
        
        let pickerEndTime = UIDatePicker()
        pickerEndTime.datePickerMode = .time
        pickerEndTime.locale = Locale.init(identifier: "en_gb")
        
        if #available(iOS 13.4, *) {
            pickerEndTime.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.selectEventEndTimeTextField.inputView = pickerEndTime
        pickerEndTime.addTarget(self, action: #selector(EndTimeIsChanged(sender:)), for: .valueChanged)
        
//        self.imageContainView.clipsToBounds = false
        self.eventDetailsTextView.delegate = self
        self.eventDetailsTextView.text = "Event Details..."
        self.eventDetailsTextView.textColor = UIColor.lightGray
    }
    @objc func dateIsChanged(sender: UIDatePicker){
        print("date is selected")
        let convertedDate = sender.date.string(with: .DATE_TIME_FORMAT_ISO8601)
        self.dateString = convertedDate
        let onlyDate = sender.date.string(with: .DATE_FORMAT_M)
        self.selectEventDateTextField.text = onlyDate
        print("Date: ", convertedDate)
    }
    @objc func TimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.selectEventTimeTextField.text = convertedTime
        print("Time: ", convertedTime)
    }
    @objc func EndTimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.selectEventEndTimeTextField.text = convertedTime
        print("Time: ", convertedTime)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.eventDetailsTextView.textColor == UIColor.lightGray {
            self.eventDetailsTextView.text = ""
            self.eventDetailsTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.eventDetailsTextView.text == "" {
            self.eventDetailsTextView.text = "Placeholder text ..."
            self.eventDetailsTextView.textColor = UIColor.lightGray
        }
    }

    @IBAction func actionBack(_ sender: UIButton) {
        self.mainContainer.currenController?.popViewController(animated: true)
    }
    
    @IBAction func addDate(_ sender: Any) {
        if selectEventDateTextField.text == "Select Date" {
        let onlyDate = Date().string(with: .DATE_FORMAT_M)
            self.selectEventDateTextField.text = onlyDate
        }
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
    
    @IBAction func addMoreTruck(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTruckInEditedEvent") as! AddTruckInEditedEvent
        vc.delegate = self
        vc.selectedTruck = self.addedTrucks
        vc.newEventModel = self.newEventModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        
        self.newEventModel.eventType = "public"
//        delegateEdit?.didEdit(tapped: tapped)
        self.editEvent()
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
            self.locationManager.startUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            self.mapView.mapType = .normal
        case .notDetermined, .restricted, .denied:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
        }
    }
}

extension EditedEventViewController : UITextFieldDelegate,LOCATIONEVENTSELECT{
    func locationSelect(address: String, latitude: Double, lognitude: Double) {
        self.EnterAddressTextField.text = address
        self.lat = latitude
        self.lng = lognitude
    }
func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    self.activeTextField = textField
    
    if textField.isEqual(EnterAddressTextField){
        getLocation()
        self.view.endEditing(true)
        return false
    }
    self.myPickerView.reloadAllComponents()
    self.myPickerView.selectRow(0, inComponent: 0, animated: true)
    return true
}
func getLocation(){
    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "addEventMapViewController") as? addEventMapViewController
    {
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension EditedEventViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currentList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.currentList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
extension EditedEventViewController:GMSMapViewDelegate,CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
        self.mapView.clear()
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        self.mapView.selectedMarker = nil
        
        self.getAddress(selectedLat: coordinate.latitude, selectedLon: coordinate.longitude) { (address,city) in
            self.marker(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    func getAddress(selectedLat: Double, selectedLon: Double, handler: @escaping (String,String) -> Void)
    {
        var address: String = ""
        var City = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: selectedLat, longitude: selectedLon)
        //selectedLat and selectedLon are double values set by the app in a previous process
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            // Address dictionary
            //print(placeMark.addressDictionary ?? "")
            // Location name
            if let locationName = placeMark?.name {
                address += locationName + ", "
            }
            // Street address
            if let street = placeMark?.thoroughfare {
                address += street + ", "
            }
            // City
            if let city = placeMark?.locality{
                address += city + ", "
                City = city
            }
            // Zip code
            if let zip = placeMark?.postalCode {
                address += zip + ", "
            }
            // Country
            if let country = placeMark?.country {
                address += country
            }
            // Passing address back
            handler(address,City)
        })
    }
}
extension EditedEventViewController{
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
        self.mapView.selectedMarker = marker
    }
}
extension EditedEventViewController{
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
extension EditedEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                self.eventImageView.image = image
                self.newEventViewModel.ImageFile = image
                self.isImageAdded = true
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditedEventViewController: UITableViewDelegate, UITableViewDataSource{
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return nearByList.count
        return addedTrucks.count
//        }
////        else {
//            return getUser.count
//        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddedTrcuksCell", for: indexPath) as! AddedTrcuksCell
            cell.selectionStyle = .none
        cell.truckNameLabel.text = self.addedTrucks[indexPath.row].name
//            cell.index = indexPath.row
//            cell.delegate = self
//            cell.configure(nearBy: self.nearByList[indexPath.row])
//            if self.isCreateNew{
//                if self.selectionArray.contains(indexPath.row){
//                    cell.truckInviteImageView.image = UIImage(named: "greenTick")
//                }else{
//                    cell.truckInviteImageView.image = UIImage(named: "inviteTruckImage")
//                }
//            }
            return cell
//        }
//        else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
//            cell.selectionStyle = .none
//            cell.index = indexPath.row
//            let item = self.getUser[indexPath.row]
////            cell.configure(friend: item)
//            cell.delegate = self
//            print(selectionArray)
//            if self.selectionArray.contains(indexPath.row){
//                cell.btnInvite.backgroundColor = UIColor.clear
//                cell.btnInvite.setTitle("", for: .normal)
//                cell.btnInvite.setImage(UIImage(named: "greenTick"), for: .normal)
//            }else{
//                cell.btnInvite.backgroundColor = UIColor(named: "YellowColor")
//                cell.btnInvite.setTitle("Invite", for: .normal)
//                cell.btnInvite.setImage(UIImage(named: ""), for: .normal)
//            }
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if indexPath.section == 0 {
//            return  190
//        }
//        else{
//            return 90
//        }
//    }
}
extension EditedEventViewController{
    func editEvent(){
        let eventModel = CreateEventViewModel()
        eventModel.EventSlots.removeAll()
        eventModel.EventSlots.append(NewEventSlotsViewModel(sDate: self.selectEventDateTextField.text ?? "", sTime: self.selectEventTimeTextField.text ?? "", eTime: self.selectEventEndTimeTextField.text ?? ""))
        let encoder = JSONEncoder()
        let data = try! encoder.encode(eventModel.EventSlots)
        let slots = String(data: data, encoding: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : [.allowFragments]) as? [String:AnyObject]
            {
               print(jsonArray) // use the json here
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        let params = [
            "EventId"           : self.newEventModel.eventId ?? 0,
            "EventName"         : self.eventTitleTextField.text ?? "",
            "Description"       : self.eventDetailsTextView.text ?? "",
            "LocationName"      : self.EnterAddressTextField.text ?? "",
            "Address"           : self.EnterAddressTextField.text ?? "",
            "Type"              : self.newEventModel.eventType,
            "EventSlots"        : slots,
            "ImageUrl"         : self.newEventModel.imageUrl ?? "",
            "ImageFile"        : self.eventImageView.image ?? UIImage(),
            "TruckIds"          : self.newEventModel.truckIds ?? "",
            "Latitude"          : self.newEventModel.Latitude,
            "Longitude"         : self.newEventModel.Longitude
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
//                        if "Upated" == serviceResponse.message {
//                            self.mainContainer.currenController?.popToRootViewController(animated: true)
                        self.tableView.reloadData()
                        self.delegateEdit?.didEdit(tapped: self.tapped)
                        self.navigationController?.popViewController(animated: true)
//                    }
//                    else {
//                        print("Event is not Saved")
//                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("Event is not Saved")
                    }
                default :
                    GCD.async(.Main) {
                        print("Event is not Saved")
                    }
                }
            }
        }
    }
}




extension EditedEventViewController : AddEditTruckViewControllerDelegate{
    func addEditTruck(truckList: [NearbyTrucksViewModel]) {
        let idArray = truckList.map({ (id: NearbyTrucksViewModel) -> Int in
            id.truckId ?? 0
        })
        let array = idArray.map{String($0)}.joined(separator: ",")
        self.newEventModel.truckIds = array
//        self.invitedTruckList = truckList
        print(truckList)
    }
}
    
