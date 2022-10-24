//
//  SettingsViewController.swift
//  Trough
//
//  Created by Irfan Malik on 06/01/2021.
//

import UIKit
import Firebase
import FacebookLogin
import SwiftUI

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var settingsArray = ["My Events Invitations","My Locations","Friend List","Invitations ","Orders","User Settings","Logout"]
//    var settingImageArray = [#imageLiteral(resourceName: "locationiiCon"),#imageLiteral(resourceName: "hand shake"),#imageLiteral(resourceName: "settingsIcon"),#imageLiteral(resourceName: "logoutCircle")]
    
    var settingImageArray : [UIImage] = [UIImage(named: "Event")!, UIImage(named: "locationiiCon")!,
                                                        UIImage(named: "hand shake")!,
                                                        UIImage(named: "eventIcon")!,
                                                        UIImage(named: "orders")!,
                                                        UIImage(named: "settingsIcon")!
                                                        ,UIImage(named: "logoutCircle")!,]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        
    }
    @IBAction func actionNotification(_ sender: Any) {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        if #available(iOS 13.0, *) {
            let mainVC = sb.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController

            self.navigationController?.pushViewController( mainVC, animated: true)

        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func actionLogout(_ sender: UIButton) {
        Global.shared.currentUser = UserViewModel.init()
                    Global.shared.saveLoginUserData()
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: "userIdentifier1")
                    defaults.synchronize()
        
                    self.mainContainer.navigationController?.popToRootViewController(animated: true)
    }
    
    func config(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
    }
}


extension SettingsViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = "\(self.settingsArray[indexPath.row])"
        cell.settingImageView.image = settingImageArray[indexPath.row]

        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row ==  self.settingsArray.count-1{
            Global.shared.currentUser = UserViewModel.init()
            Global.shared.saveLoginUserData()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "userIdentifier1")
            defaults.synchronize()

            self.mainContainer.navigationController?.popToRootViewController(animated: true)
        }
        if indexPath.row == 0{
            let vc = UIStoryboard.init(name: "PeoplesList", bundle: nil).instantiateViewController(withIdentifier: "ListOfEventViewController") as! ListOfEventViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
                
        if indexPath.row == 1{
            let vc = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if indexPath.row == 2{
            let vc = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3{

            let vc = UIStoryboard.init(name: "EventInvitation", bundle: nil).instantiateViewController(withIdentifier: "UserInvitationsViewController") as! UserInvitationsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if indexPath.row == 4{

            let vc = UIStoryboard.init(name: "PreOrder", bundle: nil).instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if indexPath.row == 5{
            let vc = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
