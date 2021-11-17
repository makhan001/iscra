//
//  ForgotPsswordViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 17/11/21.
//

import UIKit

class ForgotPsswordViewController: UIViewController {
    @IBOutlet weak var btnSend:UIButton!
    @IBOutlet weak var textEmail:UITextField!
    @IBOutlet weak var viewNavigation: NavigationBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUps()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// Initial Congfigrations
extension ForgotPsswordViewController {
    func SetUps() {
        viewNavigation.lblTitle.text = "Forgot Password"
        viewNavigation.delegateBarAction = self
    }
}
// NAvigation Delegates
extension ForgotPsswordViewController : navigationBarAction {
    func ActionType() {
        navigationController?.popViewController(animated: true)
    }
}
