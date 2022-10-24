//
//  PeopleComingViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 02/09/2022.
//

import UIKit

class PeopleComingViewController: BaseViewController {

    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var event :EventViewModel?
    
    var data = [ComingPeopleModel]()
    
    var idOfEvent = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noResultLabel.isHidden = true

        self.event?.eventId = idOfEvent
        userWhoAccepted()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PeopleComingViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data.count > 0{
            self.noResultLabel.isHidden = true
            return self.data.count
        }
        else{
            self.noResultLabel.isHidden = false
        }

        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComingPeopleCell", for: indexPath) as! ComingPeopleCell
        let item = self.data[indexPath.row]
        cell.configure(getDta: item)

        return cell
    }
    
}

extension PeopleComingViewController {
    
    func userWhoAccepted(){
        let params:[String:Any] = [:
            
        ]
        
        print(params)
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        
        service.getUserWhoAcceptedList(params: params, eventId: self.idOfEvent){ (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let list = serviceResponse.data as? [ComingPeopleModel] {
                                                    self.data = list
                                                    self.tableView.reloadData()
                    }
                    else {
                        print("No Friend Found!")
                    }
                    }

                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: serviceResponse.message)
                    }
                }
            }
        }
}