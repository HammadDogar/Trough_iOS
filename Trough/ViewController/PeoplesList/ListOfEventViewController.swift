//
//  ListOfEventViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 02/09/2022.
//

import UIKit

class ListOfEventViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel : UILabel!
    
    var eventList = [EventViewModel]()
    var isInvite = false
    var eventFilter : NearbyTrucksViewModel?
    var tapped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noResultLabel.isHidden = true

        getEventsListing()
        tableView.reloadData()

    }
    


}


extension ListOfEventViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.eventList.count > 0{
            self.noResultLabel.isHidden = true
            return self.eventList.count
        }
        else{
            self.noResultLabel.isHidden = false
        }
        return self.eventList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfEventCell", for: indexPath) as! ListOfEventCell
//        let  item = self.eventList[indexPath.row]
        cell.EventListLabel.text = eventList[indexPath.row].eventName
        cell.onSelect = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PeopleComingViewController") as! PeopleComingViewController

            vc.idOfEvent = self.eventList[indexPath.row].eventId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.onSelectTruck = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PeopleTruckViewController") as! PeopleTruckViewController
            
            vc.idOfEvent = self.eventList[indexPath.row].eventId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AttendingPeopleListViewController") as! AttendingPeopleListViewController
//        let event = self.eventList[indexPath.row]
//        vc.event = event
//        vc.iD = self.eventList[indexPath.row].eventId ?? 0
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
    
    
}


extension ListOfEventViewController{
    func getEventsListing(isloader:Bool = true,isReloadData:Bool = true){
        var params: [String:Any] = [String:Any]()

            params = ["createdById": Global.shared.currentUser.userId!]
                as [String : Any]
        
        let service = EventsServices()
        if isloader{
            GCD.async(.Main) {
                self.startActivityWithMessage(msg: "")
            }
        }
        GCD.async(.Default) {
            
            service.getEventsListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.view.isUserInteractionEnabled = true
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let eventsList = serviceResponse.data as? [EventViewModel] {
                            self.eventList = eventsList
                            
//                            let truckId = self.eventFilter?.truckId ?? 0
//                            var array = eventsList.filter { event -> Bool in
//                                let trucks = event.invitedTrucks ?? []
//                                if trucks.contains(where: { (truck) -> Bool in
//                                    (truck.truckId ?? 0) == truckId
//                                }) {
//                                    return false
//                                }
//                                return true
//                            }
                            
//                            print(array)
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
