//
//  SavedLocationViewController.swift
//  Trough
//
//  Created by Macbook on 13/04/2021.
//

import UIKit

class SavedLocationViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var userFavouriteLocation = [favouriteLocationViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getUserFavouriteLocation()
    }
    
    func getUserFavouriteLocation(){

        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]

        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
          
        }
        GCD.async(.Default) {
            service.UsersFavouriteLocations(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let location = serviceResponse.data as? [favouriteLocationViewModel] {
                            self.userFavouriteLocation = location
                            
                            
                            self.tableView.reloadData()
                    }
                    else {
                        print("No Location1 Found!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Location2 Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Location3 Found!")
                    }
                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userFavouriteLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath) as! FavouriteLocationTableViewCell
        
        cell.locationTitle.text = self.userFavouriteLocation[indexPath.row].title
        cell.locationDescription.text = self.userFavouriteLocation[indexPath.row].addres
        
            return cell
        
    }

}
