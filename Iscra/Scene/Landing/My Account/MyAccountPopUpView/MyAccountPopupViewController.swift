//
//  MyAccountPopupViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 29/11/21.
//

import UIKit

class MyAccountPopupViewController: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Setup()
    }
}

extension MyAccountPopupViewController {
    private func Setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTaps(_:)))
        viewBackground.addGestureRecognizer(tap)
//        self.tableView.configure()
//        tableView.delegateNavigate = self
    }
    
    
    @objc func handleTaps(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}
