//
//  AddFriendViewController.swift
//  Trough
//
//  Created by Macbook on 08/04/2021.
//

import UIKit

protocol AddOrRemoveFriendDelgeate {
    func AddRemoveFriend()
}

class AddFriendViewController: BaseViewController {
    
    var list:EventViewModel?
    var isFriend: Bool = false
    
    var delegate:AddOrRemoveFriendDelgeate?
    
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var addRemoveFriendBtn: UIButton!
    @IBOutlet weak var friendImage: UIImageView!
    
    @IBOutlet weak var friendName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loadData()
        print(isFriend)
        
    }
    func loadData(){
        self.friendName.text = list?.fullName!
        
//                if list!.profileUrl != "" && list!.profileUrl != nil{
//                    let url = URL(string: BASE_URL+list!.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//                    print(url)
//                    self.friendImage.setImage(url: url)
//                }else{
//                    self.friendImage.image = UIImage(named: "PlaceHolder2")
//                }
        
        
        if list!.profileUrl != "" && list!.profileUrl != nil{
            if let url = URL(string: list!.profileUrl ?? "") {
                DispatchQueue.main.async {
                    self.friendImage.setImage(url: url)
                }
            }
        }else{
            self.friendImage.image = UIImage(named: "personFilled")
        }
        
        if isFriend{
            self.addRemoveFriendBtn.setTitle("Remove Friend", for: .normal)
        }
        else{
            self.addRemoveFriendBtn.setTitle("Add Friend", for: .normal)
        }
    }
    
    
    
    @IBAction func actionAddRemoveFriend(_ sender: UIButton) {
        
        if isFriend{
            self.removeFriend()
        }
        else{
            self.addFriend()
        }


    }
    

    @IBAction func actionCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func addFriend(){
        let params:[String:Any] = [
            "friendId": list!.createdById!
        
                            ]
        
        print(params)
        
        let service = UserServices()
        GCD.async(.Default) {
            service.addFriendRequest(params: params,FriendId: self.list!.createdById!) { (serviceResponse) in
                GCD.async(.Main) {
                  
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        print("Success")
                        self.delegate?.AddRemoveFriend()
                        self.dismiss(animated: true, completion: nil)
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
    
    func removeFriend(){
        let params:[String:Any] = [
            "friendId": list!.createdById!
        
                            ]
        
        print(params)
        
        let service = UserServices()
        GCD.async(.Default) {
            service.removeFriendRequest(params: params, FriendId: self.list!.createdById!) { (serviceResponse) in
                GCD.async(.Main) {
                  
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        print("Success")
                        self.delegate?.AddRemoveFriend()
                        self.dismiss(animated: true, completion: nil)
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
}
