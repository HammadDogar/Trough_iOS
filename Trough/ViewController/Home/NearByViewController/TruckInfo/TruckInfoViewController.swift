//
//  TruckInfoViewController.swift
//  Trough
//
//  Created by Macbook on 30/03/2021.
//

import UIKit
import Kingfisher
import GoogleMaps
import CoreLocation
import MapKit

class TruckInfoViewController: BaseViewController, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationTwo = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        print(locationTwo)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
//    weak var delegate: EventTableViewCellDelegate?

    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var truckName: UILabel!
    @IBOutlet weak var openingTime: UILabel!
    @IBOutlet weak var milesAwayLabel: UILabel!
    @IBOutlet weak var truckAddress: UILabel!
    @IBOutlet weak var truckDescription: UILabel!
    
    var truckId:String = ""
//    var truckId:Int = 0
    
    var myEvent: EventViewModel?
    var myTrucks = [InvitedTrucks]()

    var nearByList = [NearbyTrucksViewModel]()
    var nearTrucks : NearbyTrucksViewModel?
    var trucks = NearbyTrucksViewModel()
        
    var id = 0
    var evntId = 0
    
    var event :EventViewModel?
    
    let locationManager = CLLocationManager()
    var locationTwo = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.getTruckInfomation()
    }
    
    func configure() {
        
        self.truckName.text = "\(nearTrucks?.name ?? "")"
        self.truckAddress.text = "\(nearTrucks?.address ?? "")"
        self.truckDescription.text = "\(nearTrucks?.description ?? "")"
        //        self.truckImage.kf.setImage(with: URL(string: BASE_URL + (nearTrucks?.bannerUrl ?? "")))
        
//        if nearTrucks?.bannerUrl != "" && nearTrucks?.bannerUrl != nil{
//            let url = URL(string: BASE_URL+(nearTrucks?.bannerUrl!)! ) ?? URL.init(string: "https://www.google.com")!
//            self.truckImage.setImage(url: url)
//        }else{
//            self.truckImage.image = UIImage(named: "PlaceHolder2")
//        }
        
        if nearTrucks?.bannerUrl != "" && nearTrucks?.bannerUrl != nil{
            if let url = URL(string: nearTrucks?.bannerUrl ?? "") {
                DispatchQueue.main.async {
                    self.truckImage.setImage(url: url)
                }
            }
        }else{
                self.truckImage.image = UIImage(named: "PlaceHolder2")
        }
        
        
        let locationOne = CLLocation(latitude: (nearTrucks?.permanentLatitude ?? 0.0) , longitude: nearTrucks?.permanentLongitude ?? 0.0)
        print(locationOne)
//        let distance = locationOne.distance(from: locationTwo) * 0.000621371
//        print(distance)
        
        let distanceInMeters = locationOne.distance(from: locationTwo)
        let distanceInMiles = distanceInMeters/1609.34
        print(distanceInMiles)
        let y = Double(round(100*distanceInMiles)/100)
//       let distance =  distanceInMeters/1609.344
        print(y)
//        let miles = Measurement(value: distance, unit: UnitLength.meters).converted(to: UnitLength.miles).value
//        print(miles)
        
        self.milesAwayLabel.text = "\(y) Miles Away"
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionMenuBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        
        if #available(iOS 13.0, *) {
            let vc = sb.instantiateViewController(identifier: "TruckMenuViewController") as! TruckMenuViewController
    
//            mainVC.truckId = self.truckId
            vc.id = self.id
            vc.evntId = self.evntId
            
            print(vc.evntId)
            vc.event = event

            self.navigationController?.pushViewController( vc, animated: true)
            
        } else {
            // Fallback on earlier versions
        }
    }
}

extension TruckInfoViewController {
    
    func getTruckInfomation() {

        var params: [String:Any] = [String:Any]()
        params = (["truckId" : id]) as [String : Any]
        let service = NearByServices()
        print(params)
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
           GCD.async(.Default) {
                service.getNearByTrucksListRequest(params: params) { (serviceResponse) in
                    GCD.async(.Main) {
                        self.stopActivity()
                        self.view.isUserInteractionEnabled = true
                    }
                    switch serviceResponse.serviceResponseType {
                    case .Success :
                        GCD.async(.Main) {
                            if let truckslist = serviceResponse.data as? [NearbyTrucksViewModel]{
                                self.nearByList = truckslist
                                if self.nearByList.count > 0 {
                                    self.nearTrucks = truckslist[0]
                                }
                                self.configure()
                                print("Done")
                            }
                            else{
                                print("Truck Infomation Not Found!")
                            }
                        }
                    case .Failure :
                        GCD.async(.Main) {
                            self.stopActivity()
                            print("Truck Info Not Found!,Failed")
                        }
                    default :
                        GCD.async(.Main) {
                            print("Truck Info Not Found!")
                        }
                    }
                }
            }
        }
}
