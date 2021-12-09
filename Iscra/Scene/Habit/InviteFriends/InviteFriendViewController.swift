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
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK:- Instance Methods
extension InviteFriendViewController {
    
    private func setup() {
        self.habitType = HabitUtils.shared.habitType
        
        setUpView(habitType:habitType)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
            lblHeaderTitle.text = AppConstant.inviteFriendsGoodTitle
            lblMiddleText.text = AppConstant.inviteFriendsGoodSubTitle
        case .bad:
            imgIcon.image = UIImage(named: "badHabitfriends")
            lblHeaderTitle.text = AppConstant.inviteFriendsBadTitle
            lblMiddleText.text = AppConstant.inviteFriendsBadSubTitle
        case .group:
            imgIcon.image = UIImage(named: "groupHabitFriends")
            lblHeaderTitle.text = AppConstant.inviteFriendsGroupTitle
            lblMiddleText.text = AppConstant.inviteFriendsGroupSubTitle
        }
        HabitUtils.shared.removeAllHabitData()
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
        self.showToast(message: "Under development", seconds: 0.5)

        // delegateInvite?.navigate(inviteType: .inviteFriend)
        //self.router?.dismiss(controller: .addHabit)
    }
    
    private func MaybeLetterAction() {
        //        delegateInvite?.navigate(inviteType: .mayBeLatter)
        if self.btnMaybeLetter.currentTitle == "Share public" {
            print("Share public")
        }else{
            print("MaybeLetterAction")
        }
      ///  self.router?.dismiss(controller: .addHabit)
        self.router?.push(scene: .landing)
    }
}
