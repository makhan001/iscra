//
//  PasswordChangeConfirmationViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 01/11/21.
//

import UIKit

class PasswordChangeConfirmationViewController: UIViewController {
    
    @IBOutlet weak var transprentView: UIView!
    
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension PasswordChangeConfirmationViewController {
    
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.transprentView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        self.router?.dismiss(controller: .changePassword)
    }
}
