//
//  PasswordChangeConfirmationViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 01/11/21.
//

import UIKit

class PasswordChangeConfirmationViewController: UIViewController {
    // MARK:-Outlets and variables
    @IBOutlet weak var transprentView: UIView!
     override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        transprentView.addGestureRecognizer(tap)
       }
}

// MARK: Instance Methods
extension PasswordChangeConfirmationViewController {
   @objc func handleTap() {
            print("tapped")
       self.dismiss(animated: true, completion: nil)
        }
}
