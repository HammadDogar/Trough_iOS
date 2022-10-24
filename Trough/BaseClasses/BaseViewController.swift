//
//  BaseViewController.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import UIKit
import MBProgressHUD
import SDWebImage


var eventList = [EventViewModel]()

extension UIViewController{
    var mainContainer : ContainerViewController {
        get {
            var foundController : ContainerViewController? = nil
            var currentController : UIViewController? = self
            if self.isKind(of: ContainerViewController.self){
                foundController = self as! ContainerViewController
            }
            else {
                while true {
                    if let parent = currentController?.parent {
                        if parent.isKind(of: ContainerViewController.self) {
                            foundController = parent as! ContainerViewController
                            break
                        }
                        else if parent.isKind(of: BaseNavigationViewController.self) {
                            let navController = parent as! BaseNavigationViewController
                            if let parentViewController = navController.view.superview?.parentViewController{
                                if parentViewController.isKind(of: ContainerViewController.self) {
                                    foundController = parentViewController as! ContainerViewController
                                    break
                                }
                            }
                        }
                    }
                    else {
                        break
                    }
                    currentController = currentController?.parent
                }
            }
            return foundController!
        }
    }

    func isValidEmail(_ testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidPassword(password: String) -> Bool {
        
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
//            let passwordRegex = "^(?=.*?[0-9]).{8,}$"
            return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func simpleAlert(title : String , msg : String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class BaseViewController: UIViewController {
    
    var isFromNotification = false
    
    var hud = MBProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func startActivityWithMessage (msg:String, detailMsg: String = "") {
        self.view.endEditing(true)
        self.hud = MBProgressHUD.showAdded(to: self.view, animated:true)
        self.hud.labelText = msg
        self.hud.detailsLabelText = detailMsg
    }
    
    func stopActivity (containerView: UIView? = nil) {
        if let v = containerView{
            MBProgressHUD.hide(for: v, animated: true)
        }else{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}


extension BaseViewController{
    // Get Food Categories Listing Api Request
    func fgetFoodCategoriesListing(){
        
        let params = [:] as [String : Any]
        let service = FoodCategoriesServices()
        GCD.async(.Main) {
//            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.getFoodCategoriesListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
//                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let foodList = serviceResponse.data as? [FoodCategoriesViewModel] {
                            Global.shared.foodCategoriesList = foodList
                        }
                        else {
                            print("No Category Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Category Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Category Found!")
                    }
                }
            }
        }
    }
}

//Handle Push Navigation

extension BaseViewController{
    
    
    func moveToHome(isFromNotification : Bool){
        
        if let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(identifier: "ContainerViewController") as? ContainerViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func resetNotificationFlag() {
        self.isFromNotification = true
    }
    
    func openNotification(){
//        if let notiVC = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController{
        if self.mainContainer.currenController != nil && Global.shared.currentUser.userId != nil {
                Global.shared.currentStoryBoard = "Home"
            Global.shared.currentController = "LoggedInNavigationViewController"
            
            let myEvent = eventList.first
            if let vc =  UIStoryboard.init(name: StoryBoard.Home.rawValue, bundle: nil) .instantiateViewController(withIdentifier: "NewEventDetialsViewController") as? NewEventDetialsViewController  {
                vc.event = myEvent
                self.mainContainer.currenController?.pushViewController(vc, animated: true)
//                if let vc =  UIStoryboard.init(name: StoryBoard.Home.rawValue, bundle: nil) .instantiateViewController(withIdentifier: "EventDetailsViewController") as? EventDetailsViewController  {
//                    vc.event = myEvent
//                    self.mainContainer.currenController?.pushViewController(vc, animated: true)
            }
            
            self.isFromNotification = true
            
            self.mainContainer.setSubView()
                //                self.mainContainer.currenController?.pushViewController(notiVC, animated: true)
//                self.navigationController?.pushViewController(notiVC, animated: true)
                
            }
        }
//    }
}
