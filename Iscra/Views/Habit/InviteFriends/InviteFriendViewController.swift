//
//  InviteFriendViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit

class InviteFriendViewController: UIViewController {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblMiddleText: UILabel!
    @IBOutlet weak var btnInviteFriends: UIButton!
    @IBOutlet weak var btnMaybeLetter: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}
// MARK:- Instance Methods
extension InviteFriendViewController {
    
    private func setup() {
        imgIcon.image = UIImage(named: "goodhabitfriends")
        lblHeaderTitle.text = "Together is \nmore fun"
        lblMiddleText.text = "Do you know it’s much easier to build a new habits when your friend can support you. Invite your friends, build good habits together and have fun!"
        [btnInviteFriends, btnMaybeLetter].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}

// MARK:- Button Action
extension InviteFriendViewController  {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnInviteFriends:
            self.InviteFriendsAction()
        case btnMaybeLetter:
            self.MaybeLetterAction()
        default:
            break
        }
    }
    private func InviteFriendsAction() {
        print("InviteFriendsAction")
    }
    private func MaybeLetterAction() {
        print("MaybeLetterAction")
        guard let viewControllers = navigationController?.viewControllers else { return }
        for vc in viewControllers {
            if vc is LandingTabBarViewController {
                navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
    }
}
