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
    
    weak var router: NextSceneDismisser?
    
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
        lblHeaderTitle.text = AppConstant.welComeDiscription
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
//        router?.(scene: .walkthrough)
        let walkthrough: WalkthroughViewController = WalkthroughViewController.from(from: .onboarding, with: .walkthrough)
        walkthrough.router = router
        self.navigationController?.pushViewController(walkthrough, animated: true)
    }
    
    private func loginAction() {
        router?.push(scene: .login)
    }
}


