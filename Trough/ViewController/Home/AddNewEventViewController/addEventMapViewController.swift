//
//  addEventMapViewController.swift
//  Trough
//
//  Created by Macbook on 15/04/2021.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}

protocol LOCATIONEVENTSELECT {
    func locationSelect(address:String , latitude:Double , lognitude:Double)
}

class addEventMapViewController: UIViewController {
     
    var delegate: LOCATIONEVENTSELECT!
    var geoCoder = CLGeocoder()
    
    var lat = 0.0
    var long = 0.0
    var locationTitle:String = ""
    var locationManager = CLLocationManager()
    
    //added for locationlist
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
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
        
        //added for locationlist
        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        //
        
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
            
            self.addressLabel.text = address
            
        }
        
    }

    //added for locationlist
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    //

    @IBAction func actionConfirmButton(_ sender: UIButton) {
        
        self.delegate.locationSelect(address: self.addressLabel.text!, latitude: self.lat, lognitude: self.long)
        self.navigationController?.popViewController(animated: true)
    }
}




extension addEventMapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let coordinate  = mapView.region.center
       let latitude = coordinate.latitude
       let lognitude = coordinate.longitude
        
        lat = latitude
        long = lognitude
        
        let location = CLLocation(latitude: latitude , longitude: lognitude)
//              let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//                  self.mapView.setRegion(region, animated: true)
//
               self.parseAddress(location: location)
        
    }
}

//added for locationlist
extension addEventMapViewController :  CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error:: \(error.localizedDescription)")
       }

       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           if status == .authorizedWhenInUse {
               locationManager.requestLocation()
           }
       }

       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

           if locations.first != nil {
               print("location:: (location)")
           }

       }
}

//added for locationlist
extension addEventMapViewController :  HandleMapSearch{
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
}
