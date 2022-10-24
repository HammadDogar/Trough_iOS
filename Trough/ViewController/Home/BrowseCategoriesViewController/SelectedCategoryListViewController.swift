//
//  SelectedCategoryListViewController.swift
//  Trough
//
//  Created by Imed on 16/09/2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class SelectedCategoryListViewController: BaseViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var newEventModel = CreateEventViewModel()
    var nearByList = [NearbyTrucksViewModel]()
    
    var category = [CategoriesViewModel]()
    
    var isCreateNew = false
    var selectionArray = [Int]()
    var params = [String : Any]()
    var text = ""

    var categoryID = 0
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTruckByCategory()
        
    self.tableView.register(UINib(nibName: "NearByTableViewCell", bundle: nil), forCellReuseIdentifier: "NearByTableViewCell")
//        self.getNearByTruckListing(location: nil, params: params)
        self.titleLabel.text = self.text
        self.noResultLabel.isHidden = true
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension SelectedCategoryListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if nearByList.count > 0 {
            self.noResultLabel.isHidden = true
            return self.nearByList.count
        }
        else {
            self.noResultLabel.isHidden = false
        }
        return self.nearByList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByTableViewCell", for: indexPath) as! NearByTableViewCell
        cell.selectionStyle = .none
//        cell.index = indexPath.row
        cell.delegate = self
        cell.truckInviteImageView.isHidden = true
        cell.configure(nearBy: self.nearByList[indexPath.row])
        
        
//        if self.isCreateNew{
//            if self.selectionArray.contains(indexPath.row){
//                cell.truckInviteImageView.image = UIImage(named: "greenTick")
//            }else{
//                cell.truckInviteImageView.image = UIImage(named: "inviteTruckImage")
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  190
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "TruckInfoViewController") as! TruckInfoViewController
        vc.id = self.nearByList[indexPath.row].truckId ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//extension SelectedCategoryListViewController{
//    func getNearByTruckListing(location: CLLocation?,params: [String : Any]){
//
//        let service = NearByServices()
////        GCD.async(.Main) {
////            self.startActivityWithMessage(msg: "")
////        }
//        GCD.async(.Default) {
//            service.getNearByTrucksListRequest(params: params) { (serviceResponse) in
//                GCD.async(.Main) {
//                    self.stopActivity()
//                }
//                switch serviceResponse.serviceResponseType {
//                case .Success :
//                    GCD.async(.Main) {
//                        if let nearByTruckList = serviceResponse.data as? [NearbyTrucksViewModel] {
//                            self.nearByList = nearByTruckList
//                            self.nearByList.sort(){
//                                $0.name ?? ""  > $1.name ?? ""
//                            }
//                            self.trucksSlotCalculate()
//                            self.tableView.reloadData()
////                            self.placeMarkers()
//                            self.stopActivity()
//                        }
//                        else {
//                            print("No Events Found!")
//                        }
//                    }
//                case .Failure :
//                    GCD.async(.Main) {
//                        self.stopActivity()
//                        print("No Events Found!,Failed")
//                    }
//                default :
//                    GCD.async(.Main) {
//                        print("No Events Found!")
//                    }
//                }
//            }
//        }
//    }
//
//    func trucksSlotCalculate(){
//        for slot in self.nearByList{
//            let date = Date()
//            let calendar = Calendar.current
//            let weekDay = calendar.component(.weekday, from: date)
//        }
//    }
//}

extension SelectedCategoryListViewController :  NearByTableViewCellDelegate{
    
    func actionAddInivite(eventId: Int, trucksId: String, isInviting: Bool) {
        //////
    }
}

extension SelectedCategoryListViewController {
    
    func getTruckByCategory(){
        
        var params: [String:Any] = [String:Any]()
      
        params = (["categoryId" : categoryID]) as [String : Any]
        
        let service = UserServices()
        print(params)
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.GetTruckByFoodCategory(params: params, categoryId: Int(self.categoryID)) { (serviceResponse) in

                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let list = serviceResponse.data as? [NearbyTrucksViewModel] {
                            self.nearByList = list
                            
                      
                            self.tableView.reloadData()
                            print("done")
                        }
                        else {
                            print("No truck Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No truck Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No truck Found!")
                    }
                }
            }
        }
    }
}
