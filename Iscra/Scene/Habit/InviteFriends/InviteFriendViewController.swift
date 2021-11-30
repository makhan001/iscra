//
//  InviteFriendViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit
enum inviteType {
    case inviteFriend
    case mayBeLatter
}
protocol InviteNavigation: AnyObject {
    func navigate(inviteType:inviteType)
}

class InviteFriendViewController: UIViewController {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblMiddleText: UILabel!
    @IBOutlet weak var btnInviteFriends: UIButton!
    @IBOutlet weak var btnMaybeLetter: UIButton!
    
    var habitType: HabitType = .good
    weak var delegateInvite : InviteNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}
// MARK:- Instance Methods
extension InviteFriendViewController {
    
    private func setup() {
        setUpView(habitType:habitType)
        if habitType == .group{
            btnMaybeLetter.setTitle("Share public", for: .normal)
        }
        [btnInviteFriends, btnMaybeLetter].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    func setUpView(habitType: HabitType) {
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
        delegateInvite?.navigate(inviteType: .inviteFriend)
        self.dismiss(animated: true, completion: nil)
    }
    private func MaybeLetterAction() {
        delegateInvite?.navigate(inviteType: .mayBeLatter)
        self.dismiss(animated: true, completion: nil)
    }
}


