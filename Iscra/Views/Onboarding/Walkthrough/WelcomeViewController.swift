//
//  WelcomeViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 15/10/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnStart:UIButton!
    @IBOutlet weak var lblHeaderTitle:UILabel!
    
    let WELCOME_HEADER_TEXT: String = "We help people to become the best \nversion of themself and connect with \nothers people"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
}

// MARK:- Instance Methods
extension WelcomeViewController {
    
    private func setup() {
        lblHeaderTitle.text = WELCOME_HEADER_TEXT
        [btnLogin, btnStart].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}

// MARK:- Button Action
extension WelcomeViewController {
        
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnStart:
            self.startAction()
        case btnLogin:
            self.loginAction()
        default:
            break
        }
    }
    
    private func startAction() {
        // navigate to walkthrough
      /*  let storyboard = UIStoryboard(name: "Habit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SetThemeViewController") as! SetThemeViewController
        navigationController?.pushViewController(vc, animated: true)*/
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandingTabBarViewController") as! LandingTabBarViewController
        navigationController?.pushViewController(vc, animated: true)
         /* let VC = storyboard?.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
          navigationController?.pushViewController(VC, animated: true)*/
        }

    private func loginAction() {
        // navigate to login
        let VC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(VC, animated: true)
    }
}


