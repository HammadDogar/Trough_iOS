//
//  AddedItemPopupViewController.swift
//  Trough
//
//  Created by Imed on 12/10/2021.
//

import UIKit

class AddedItemPopupViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var invitedFriend = ["Asd","test","test user"]
    var invitedTruck = ["truck named none","pizza truck","butger man"]
    
//    var invitedfiendlist = [GetUserViewModel]()
    var invitedfiendlist = [FriendListViewModel]()
    var invitedTruckList = [NearbyTrucksViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
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
    
}

extension AddedItemPopupViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return invitedfiendlist.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedFriendCollectionViewCell", for: indexPath) as! AddedFriendCollectionViewCell
        cell.friendNameLabel.text = invitedfiendlist[indexPath.row].fullName ?? ""
        
//
//        if invitedfiendlist[indexPath.row].profileUrl != "" && invitedfiendlist[indexPath.row].profileUrl != nil{
//            let url = URL(string: BASE_URL+invitedfiendlist[indexPath.row].profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            print(url)
//            cell.friendImageViiew.setImage(url: url)
//        }else{}
        
        if invitedfiendlist[indexPath.row].profileUrl != "" && invitedfiendlist[indexPath.row].profileUrl != nil{
            if let url = URL(string: invitedfiendlist[indexPath.row].profileUrl ?? "") {
                DispatchQueue.main.async {
                    cell.friendImageViiew.setImage(url: url)
                }
            }
        }else{}
        
        return cell
    }
    
}

extension AddedItemPopupViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(invitedTruckList)
        return invitedTruckList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddedTruckTableViewCell", for: indexPath) as! AddedTruckTableViewCell
        cell.truckNameLabel.text = invitedTruckList[indexPath.row].name
        cell.truckAddessLabel.text = invitedTruckList[indexPath.row].address
        return cell
    }
    
}
