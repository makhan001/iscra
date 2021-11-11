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
    var habitType:habitType = .good
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}
// MARK:- Instance Methods
extension InviteFriendViewController {
    
    private func setup() {
        setUpView(habitType:habitType)
        [btnInviteFriends, btnMaybeLetter].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    func setUpView(habitType:habitType) {
        switch habitType {
        case .good:
            imgIcon.image = UIImage(named: "goodhabitfriends")
            lblHeaderTitle.text = "Together is \nmore fun"
            lblMiddleText.text = "Do you know it’s much easier to build a new habits when your friend can support you. Invite your friends, build good habits together and have fun!"
            
        case .bad:
            imgIcon.image = UIImage(named: "badHabitfriends")
            lblHeaderTitle.text = "Together we \nare stronger"
            lblMiddleText.text = "It’s much easier to get rid of bad habits together! Support each other to become better people."
            
        case .group:
            imgIcon.image = UIImage(named: "groupHabitFriends")
            lblHeaderTitle.text = "Let’s invite \nyour friends"
            lblMiddleText.text = "Invite your friends, build good habits together and have fun (if your friends are already with Iscra, they can find your habit in search and join you). You can make your group public and find new friends!"
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


import UIKit

class CustomDashedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0

    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
