//
//  mapViewController.swift
//  Trough
//
//  Created by Macbook on 13/04/2021.
//

import UIKit
import MapKit
import CoreLocation

protocol LOCATIONSELECT {
    func locationSelect(address:String , latitude:Double , lognitude:Double)
}

class mapViewController: UIViewController {
    
    var delegate: LOCATIONSELECT!
    var geoCoder = CLGeocoder()
    
    var lat = 0.0
    var long = 0.0
    var locationManager = CLLocationManager()
    

    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
              CLLocationManager.authorizationStatus() == .authorizedAlways) {
                 currentLoc = locationManager.location
                 lat = currentLoc.coordinate.latitude
                 long = currentLoc.coordinate.longitude
              }
        
        let location = CLLocation(latitude: lat , longitude: long)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        self.parseAddress(location: location)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Map View"
    }
    
    func parseAddress(location: CLLocation) {
        
        var address  = ""
        
        geoCoder.reverseGeocodeLocation(location) { (response, error) in

            if let name = response?.last?.name {
                print(name)
                address = name
            }
            
            if let subLocality = response?.last?.subLocality {
                print(subLocality)
                address.append(", " + subLocality)
            }
            
            if let locality = response?.last?.locality {
                print(locality)
               
                address.append(", " + locality)
            }
            
            if let postalCode = response?.last?.postalCode {
                print(postalCode)
                address.append(", " + postalCode)
            }
            
            if let administrativeArea = response?.last?.administrativeArea {
                print(administrativeArea)
                 address.append(", " + administrativeArea)
            }
            
            if let country = response?.last?.country {
                print(country)
                address.append(", " + country)
                
            }
            
            self.labelAddress.text = address
            
        }
        
    }

    

    @IBAction func actionConfirmButton(_ sender: UIButton) {
        
        self.delegate.locationSelect(address: self.labelAddress.text!, latitude: self.lat, lognitude: self.long)
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension mapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let coordinate  = mapView.region.center
       let latitude = coordinate.latitude
       let lognitude = coordinate.longitude
        
        lat = latitude
        long = lognitude
        
        
        let location = CLLocation(latitude: latitude , longitude: lognitude)
              let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                  self.mapView.setRegion(region, animated: true)
              
               self.parseAddress(location: location)
        
    }
}

