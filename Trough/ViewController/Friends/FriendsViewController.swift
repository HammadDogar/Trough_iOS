//
//  FriendsViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 29/08/2022.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var contianerView: UIView!
    
    private var viewController: UIViewController!
    
    private func addViewControllerInContainer() {
        addChild(viewController)
        contianerView.addSubview(viewController.view)
        viewController.view.frame = contianerView.frame
        viewController.view.frame.origin = CGPoint(x: 0, y: 0)
        viewController.didMove(toParent: self)
    }
    
    private func removeViewControllerFromContainer() {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        segmentControl.backgroundColor = .clear
        viewController = self.storyboard?.instantiateViewController(withIdentifier: "FriendListViewController") as! FriendListViewController
        self.addViewControllerInContainer()
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
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionSegmentControl(_ sender: Any) {
        
        if viewController != nil {
            self.removeViewControllerFromContainer()
        }
        
        switch segmentControl.selectedSegmentIndex {
                case 0:
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "FriendListViewController") as! FriendListViewController
            self.addViewControllerInContainer()
                case 1 :
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "FriendRequestViewController") as! FriendRequestViewController
            self.addViewControllerInContainer()
                default:
                    break
                }
    }
    
}
