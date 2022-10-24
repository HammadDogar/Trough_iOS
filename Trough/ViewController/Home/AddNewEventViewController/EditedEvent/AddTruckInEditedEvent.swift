//
//  AddTruckInEditedEvent.swift
//  Trough
//
//  Created by Mateen Nawaz on 22/08/2022.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol AddEditTruckViewControllerDelegate  {
    func addEditTruck(truckList : [NearbyTrucksViewModel])
}

class AddTruckInEditedEvent: BaseViewController,CLLocationManagerDelegate {

    @IBOutlet var tableView : UITableView!
    
    var nearByList = [NearbyTrucksViewModel]()
    
    var selectionArray = [NearbyTrucksViewModel]()

    var selectedTruck = [InvitedTrucks]()
    
    var location:CLLocation!
    
    var delegate : AddEditTruckViewControllerDelegate?
    
    var newEventModel = EventViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        getNearByTruckListing()
        print(selectedTruck)
        
        
    

        
        tableView.register(UINib(nibName: "NearByTableViewCell", bundle: nil), forCellReuseIdentifier: "NearByTableViewCell")
        tableView.register(UINib(nibName: "AddTruckInEditedFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "AddTruckInEditedFooter")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Hide the navigation bar on the this view controller
           self.navigationController?.setNavigationBarHidden(true, animated: animated)
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Show the navigation bar on other view controllers
           self.navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    
    

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func savebutton(_ sender: Any) {
            delegate?.addEditTruck(truckList: self.selectionArray)
        self.navigationController?.popViewController(animated: true)
    }

    
}

extension AddTruckInEditedEvent : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearByList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByTableViewCell", for: indexPath) as! NearByTableViewCell
        cell.selectionStyle = .none
        let item = self.nearByList[indexPath.row]
//        let obj = self.selectedTruck[indexPath.row]
        cell.configure(nearBy: item)
            
        
        if  self.selectedTruck.contains(where: {$0.truckId == item.truckId }){
             cell.truckInviteImageView.image = UIImage(named: "foodCheckedBox")
             cell.truckInviteImageViewHeight.constant = 40
             cell.truckInviteImageViewWidth.constant = 40
         }
        else{
            cell.truckInviteImageView.image = UIImage(named: "inviteTruckImage")
        }

        if self.selectionArray.contains(where: { $0.truckId  ==  item.truckId  ?? 0
        }) {
            cell.truckInviteImageView.image = UIImage(named: "foodCheckedBox")
            cell.truckInviteImageViewHeight.constant = 40
            cell.truckInviteImageViewWidth.constant = 40
        }
        cell.onInvite = { [weak self] in
            guard let self = self else {return}
            if self.selectionArray.count + self.selectedTruck.count >= 3 {
                if let obj = self.selectionArray.first(where: {$0.truckId == item.truckId}) {
                    self.selectionArray.removeAll(where: {$0.truckId == obj.truckId})
                    self.selectedTruck.removeAll(where: {$0.truckId == obj.truckId})
                }
                else {
                    let alertController = UIAlertController(title: "Added Trucks", message:
                                                                "Third Truck added anymore Truck will not be added", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true)
                    return
                }
            }else {
                
                self.selectionArray.append(item) 
//                self.selectionArray.append(obj)
                
            }
              self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  190
    }

}


extension AddTruckInEditedEvent {
    func getNearByTruckListing(){
        
        var params: [String:Any] = [String:Any]()
        params = [:]
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
                            self.tableView.reloadData()
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
}

