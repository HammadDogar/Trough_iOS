//
//  ExtraNotificationViewController.swift
//  Trough
//
//  Created by Imed on 13/10/2021.
//

import UIKit

class ExtraNotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var friendName = ["ASD","test user","Advil"]
    var message = ["You have been invited to an event","You have been invited to an event","You have been invited to an event"]
var time = ["11:50pm","10:00am","12:00pm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
    }

}

extension ExtraNotificationViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExtraNotificationTableViewCell", for: indexPath) as! ExtraNotificationTableViewCell
        cell.timeLabel.text = time[indexPath.row]
        cell.nameLabel.text = friendName[indexPath.row]
        cell.messageLabel.text = message[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }

}
