//
//  TruckInviteViewController.swift
//  Trough
//
//  Created by Imed on 17/05/2021.
//

import UIKit


class AddingTruckViewController: BaseViewController {
   
    var eventList = [EventViewModel]()
    var eventListFiltered = [EventViewModel]()
    
//    var locationManager: CLLocationManager!
    var firstCellVisible = false
    
    var isInvite = false
    
    var eventFilter : NearbyTrucksViewModel?
    var truckIds = ""
    var isInviting = true
    
    private var shouldCalculateScrollDirection = false
    private var lastContentOffset: CGFloat = 0
    private var scrollDirection: ScrollDirection = .up
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noResultLabel.isHidden = true
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getEventsListing()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
}

extension AddingTruckViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isInvite{
            (self.eventListFiltered.count > 0) ? (self.noResultLabel.isHidden = true) : (self.noResultLabel.isHidden = false)
            return self.eventListFiltered.count
        }else{
            (self.eventList.count > 0) ? (self.noResultLabel.isHidden = true) : (self.noResultLabel.isHidden = false)
            return self.eventList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "truckCell", for: indexPath) as? AddingTruckTableViewCell{
            cell.selectionStyle = .none
            cell.index = indexPath.row
            
            cell.delegate = self
            var item: EventViewModel?
            if self.isInvite{
                item = self.eventListFiltered[indexPath.row]
            }else{
                item = self.eventList[indexPath.row]
            }
            cell.configure(event: item!)
        
            return cell
        }
        return UITableViewCell.init()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.firstCellVisible = indexPath.row == 0 ? true : false
    }
}

extension AddingTruckViewController: NearByTableViewCellDelegate {
    func truckInvite(index: Int) {
        // dod ododod
    }
    
    
    func actionAddInivite(eventId:Int,trucksId: String, isInviting: Bool) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to add this Food Truck!", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Food Truck, added!")
            print(eventId)
            
            self.truckInviteEvents(eventId: eventId, trucksId: self.truckIds, isInviting: isInviting)

        }))
        
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Canceled")
            
        }))
        present(alert, animated: true, completion: nil)

    }
    
    
    // TRUCK INVITATION CALL
    func truckInviteEvents(eventId: Int,trucksId: String, isInviting: Bool){
        let params = [
            "eventId"       : eventId,
            "truckIds"      : trucksId,
            "isInviting"    : isInviting
        ] as [String : Any]
        
        let service = EventsServices()
        print(params)

        GCD.async(.Main) {
  
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.truckInviteRequest(params: params) { (serviceResponse) in
                self.eventList = self.eventList.filter {
                    return $0.eventId != eventId
                }

                // for error back thread to main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                // for error back thread to main thread
                
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        self.stopActivity()
                        if USER_SUCCESS == serviceResponse.message {
                            self.dismiss(animated: true, completion: nil)
                          
                        }
                        else {
                            print("INVITE NOT SEND!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("INVITE NOT SEND!,Failed")
                    }
                default :
                    GCD.async(.Main) {
                        print("INVITE NOT SEND!")
                    }
                }
            }
        }
    }
    
}
// Get Event Listing Api Request
extension AddingTruckViewController{
    func getEventsListing(isloader:Bool = true,isReloadData:Bool = true){
        var params: [String:Any] = [String:Any]()
        if self.isInvite{
            params = ["createdById": Global.shared.currentUser.userId!]
        }else{
            params = [:
                //            "userId" : "",
                //            "userLatitude" : 31.43123116444423,
                //            "userLongitude" : 74.2935532173374,
                //            "radius" : 25
            ] as [String : Any]
        }
        
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
                            if self.isInvite{
                                if self.eventFilter?.eventIds?.count != nil{
                                    self.eventListFiltered = self.eventList.filter{ event in
                                        for id in self.eventFilter!.eventIds!{
                                            return event.eventId != id.eventId
                                        }
                                        return false
                                    }
                                }
                            }
                            if isReloadData{
                                self.tableView.reloadData()
                            }
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

extension AddingTruckViewController: UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // The current offset
        let offset = scrollView.contentOffset.y

        // Determine the scolling direction
        if lastContentOffset > offset && shouldCalculateScrollDirection {
            scrollDirection = .down
        }
        else if lastContentOffset < offset && shouldCalculateScrollDirection {
            scrollDirection = .up
        }
        switch scrollDirection {
        case .down:
            // Do something for scollDirection up
            if self.firstCellVisible{
//                self.searchViewheightConstraint.constant = 40
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        case .up:
            // Do something for scollDirection down
            if !self.firstCellVisible{
//                self.searchViewheightConstraint.constant = 0
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        }

        // This needs to be in the last line
        lastContentOffset = offset
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        shouldCalculateScrollDirection = false
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        shouldCalculateScrollDirection = false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shouldCalculateScrollDirection = true
    }
}
