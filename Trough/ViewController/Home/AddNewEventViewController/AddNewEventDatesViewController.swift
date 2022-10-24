//
//  AddNewEventDatesViewController.swift
//  Trough
//
//  Created by Irfan Malik on 29/12/2020.
//

import UIKit
import GoogleMaps
import GooglePlaces


class AddNewEventDatesViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var selectEventDateTextField: UITextField!
    @IBOutlet weak var selectEventTimeTextField: UITextField!
    @IBOutlet weak var selectEventEndTimeTextField: UITextField!
    @IBOutlet weak var selectEventLocationTextField: UITextField!
    @IBOutlet weak var enterEventLocation: UITextField!
    @IBOutlet weak var EnterAddressTextField: UITextField!
    @IBOutlet weak var eventAddressView: UIView!
    
    
    let myPickerView = UIPickerView()
    var currentList:[String] = []
    var activeTextField:UITextField!
    let locationList = ["New York","LA","CF"]
    var newEventModel = CreateEventViewModel()
    var locationManager = CLLocationManager()
    
    var dateString = ""
    
    let key = "AIzaSyBrMcsZZbYR-LL8bX4BAffCyWMTVlD4gbs"
    
    var lat:Double = 0.0
    var lng:Double = 0.0
    
    var timer : Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.EnterAddressTextField.delegate = self
        self.configure()
        self.askPermission()
        self.selectEventLocationTextField.isHidden = true
//        self.eventAddressView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
        self.mapView.delegate = self
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.selectEventLocationTextField.delegate = self
        self.selectEventLocationTextField.inputView = self.myPickerView
        
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
        
        self.selectEventLocationTextField.addTarget(self, action: #selector(self.editingEnding(textField:)), for: .editingDidEnd)
        
        
        timer = Timer.scheduledTimer(timeInterval: 3000.0, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
        timer?.tolerance = 0.2
        print("Timer fired!")
        
    }
    @objc func updateLocation(){
        self.locationManager.startUpdatingLocation()
    }

    
    @IBAction func actionBack(_ sender: Any){
        self.mainContainer.currenController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldTapped(_ sender: Any) {
        self.enterEventLocation.resignFirstResponder()
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func actionNext(_ sender: Any){
        let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier: "AddNewEventDetailsViewController") as! AddNewEventDetailsViewController
        self.newEventModel.EventSlots.removeAll()
        self.newEventModel.EventSlots.append(NewEventSlotsViewModel(sDate: dateString, sTime: self.selectEventTimeTextField.text!, eTime: self.selectEventEndTimeTextField.text!))
        
        if self.newEventModel.EventSlots[0].startDate == ""{
            simpleAlert(title: "Alert", msg: "Date is Required")
            return
        }
        if self.newEventModel.EventSlots[0].startTime == "Select Time" || self.newEventModel.EventSlots[0].endTime == "Select Time"{
            simpleAlert(title: "Alert", msg: "Time is Required")
            return
        }
        if self.lat == 0.0{
            simpleAlert(title: "Alert", msg: "Add Address")
            return
        }
        //self.newEventModel.Address = self.EnterAddressTextField.text ?? ""
        vc.newEventModel = self.newEventModel
        self.mainContainer.currenController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func dateIsChanged(sender: UIDatePicker){
        print("date is selected")
        let convertedDate = sender.date.string(with: .DATE_TIME_FORMAT_ISO8601)
        
        self.dateString = convertedDate
        
        let onlyDate = sender.date.string(with: .DATE_FORMAT_M)
        
        self.selectEventDateTextField.text = onlyDate
        print("Date: ", convertedDate)
        //        self.newEventModel.EventSlots.startDate = convertedDate
    }
    
    @objc func TimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.selectEventTimeTextField.text = convertedTime
        print("Time: ", convertedTime)
        //        self.newEventModel.EventSlots[0].startTime = convertedTime
        
    }
    
    @objc func EndTimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.selectEventEndTimeTextField.text = convertedTime
        print("Time: ", convertedTime)
        //        self.newEventModel.EventSlots[0].endTime = convertedTime
        
    }
    
    @objc func editingEnding(textField : UITextField) {
        if textField == self.selectEventLocationTextField{
            
        }
    }
    
    @IBAction func addDate(_ sender: Any) {
//        let convertedDate = Date().string(with: .DATE_TIME_FORMAT_ISO8601)
//        self.dateString = convertedDate
        if selectEventDateTextField.text == "Select Date" {
            let onlyDate = Date().string(with: .DATE_FORMAT_M)
            self.selectEventDateTextField.text = onlyDate
        }
    }
    @IBAction func addTime(_ sender: Any) {
        
        if selectEventTimeTextField.text == "Select Time"{
            let time = Date().string(with: .TIME_FORMAT_24)
            self.selectEventTimeTextField.text = time
        }
    }
    @IBAction func addEndTime(_ sender: Any) {
        
        if selectEventEndTimeTextField.text == "Select Time"{
            let converted = Date().string(with: .TIME_FORMAT_24)
            self.selectEventEndTimeTextField.text = converted
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
            self.mapView.settings.myLocationButton = true
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

extension AddNewEventDatesViewController:UITextFieldDelegate,LOCATIONEVENTSELECT{
    
    func locationSelect(address: String, latitude: Double, lognitude: Double) {
        self.EnterAddressTextField.text = address
        self.lat = latitude
        self.lng = lognitude
        
        self.newEventModel.Latitude     = self.lat
        self.newEventModel.Longitude    = self.lng
        self.newEventModel.Address      = address
    }
    
        
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        
        if textField.isEqual(EnterAddressTextField){
            getLocation()
            self.view.endEditing(true)
            return false
        }
        
        if textField == self.selectEventLocationTextField{
            self.currentList = self.locationList
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

extension AddNewEventDatesViewController: UIPickerViewDelegate,UIPickerViewDataSource{
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
        if activeTextField == self.selectEventLocationTextField{
            self.enterEventLocation.text = self.currentList[row]
        }else{
            self.activeTextField.text = self.currentList[row]
        }
        
        if self.activeTextField == self.selectEventLocationTextField {
            self.newEventModel.LocationName = self.currentList[row]
            self.newEventModel.Latitude     = 31.123
            self.newEventModel.Longitude    = 74.123
            self.newEventModel.Address      = "my address"
        }
    }
}

extension AddNewEventDatesViewController: GMSMapViewDelegate,CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        if location.coordinate.latitude != 0.0{
            print(location)
            print("Stop")
//            self.locationManager.stopUpdatingLocation()
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//        self.mapView.selectedMarker = nil
        self.mapView.clear()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        self.mapView.selectedMarker = nil
        
        self.getAddress(selectedLat: coordinate.latitude, selectedLon: coordinate.longitude) { (address,city) in
            self.enterEventLocation.text = "\(address)"
            self.marker(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.newEventModel.LocationName = "\(city)"
            self.newEventModel.Latitude     = coordinate.latitude
            self.newEventModel.Longitude    = coordinate.longitude
            self.newEventModel.Address      = "\(address)"
        }
    }
    
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        self.marker(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        self.getAddress(selectedLat: coordinate.latitude, selectedLon: coordinate.longitude) { (address) in
//            self.enterEventLocation.text = "\(address)"
//        }
//    }
    
    func marker(latitude : Double, longitude : Double){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.isDraggable = true
        marker.map = self.mapView
        self.mapView.selectedMarker = marker
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

extension AddNewEventDatesViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.enterEventLocation.text = place.formattedAddress
        self.marker(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.mapView.animate(to: GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        self.newEventModel.LocationName = "\(place.name ?? "")"
        self.newEventModel.Latitude     = place.coordinate.latitude
        self.newEventModel.Longitude    = place.coordinate.longitude
        self.newEventModel.Address      = "\(place.formattedAddress ?? "")"
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
