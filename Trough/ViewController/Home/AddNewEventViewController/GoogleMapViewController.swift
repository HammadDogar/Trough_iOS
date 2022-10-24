//
//  GoogleMapViewController.swift
//  Trough
//
//  Created by Imed on 13/08/2021.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol LocationFromGoogleMap {
    func location(address:String , latitude:Double , lognitude:Double)
}


class GoogleMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressComfirmButton: UIButton!
    
    var delegate : LocationFromGoogleMap!
    
    var lat = 0.0
    var long = 0.0
    var locationTitle:String = ""
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        }
    @objc func updateLocation(){
        self.locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func actionConfirm(_ sender: UIButton) {
        
        self.delegate.location(address: self.addressLabel.text!, latitude: self.lat, lognitude: self.long)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
