//
//  AttendingPeopleListViewController.swift
//  Trough
//
//  Created by Mateen Nawaz on 02/09/2022.
//

import UIKit

class AttendingPeopleListViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var contianerView: UIView!
    
    private var viewController: UIViewController!
    
    var event :EventViewModel?
    var iD = 0

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
        segmentControl.backgroundColor = .clear
        viewController = self.storyboard?.instantiateViewController(withIdentifier: "PeopleComingViewController") as! PeopleComingViewController
        self.addViewControllerInContainer()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSegment(_ sender: Any) {
        
        if viewController != nil {
            self.removeViewControllerFromContainer()
        }
        
        switch segmentControl.selectedSegmentIndex {
                case 0:
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "PeopleComingViewController") as! PeopleComingViewController
            
            self.addViewControllerInContainer()
                case 1 :
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "PeopleTruckViewController") as! PeopleTruckViewController
            
            self.addViewControllerInContainer()
                default:
                    break
                }
    }
    

}
