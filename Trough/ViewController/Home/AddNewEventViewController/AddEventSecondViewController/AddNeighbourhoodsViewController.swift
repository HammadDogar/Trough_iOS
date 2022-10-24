//
//  AddNeighbourhoodsViewController.swift
//  Trough
//
//  Created by Imed on 12/10/2021.
//

import UIKit

class AddNeighbourhoodsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var neighbourArray = ["Allen","Levi","Howard","Chirsten","Adam"]
    var neighbourAddress = ["Weston","Huston","New Hmapshire","Orange County","New york"]
    var neighbourImage = [#imageLiteral(resourceName: "logout-2"),#imageLiteral(resourceName: "logout-3"),#imageLiteral(resourceName: "personFilled"),#imageLiteral(resourceName: "googlee"),#imageLiteral(resourceName: "clockIcon")]
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionDone(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AddNeighbourhoodsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return neighbourArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NeighbourTableViewCell", for: indexPath) as! NeighbourTableViewCell
        cell.neighbourNameLabel.text = neighbourArray[indexPath.row]
        cell.neighbourAddressLabel.text = neighbourAddress[indexPath.row]
        cell.neighbourImage.image = neighbourImage[indexPath.row]
        return cell
    }
    
    
}
