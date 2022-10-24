//
//  CartAnimationViewController.swift
//  Trough
//
//  Created by Imed on 22/09/2021.
//

import UIKit
import Lottie

class CartAnimationViewController: UIViewController {

    @IBOutlet  var animationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationItem.hidesBackButton = true
        // 1. Set animation content mode
         animationView.contentMode = .scaleAspectFit
         // 2. Set animation loop mode
         animationView.loopMode = .loop
         // 3. Adjust animation speed
         animationView.animationSpeed = 0.5
         // 4. Play animation
         animationView.play()
        // make sure the name of the animation matches the imported file
       
    }

    @IBAction func actionMoveToroot(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
