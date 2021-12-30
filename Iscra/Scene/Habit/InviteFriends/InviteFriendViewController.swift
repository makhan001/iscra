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

class InviteFriendViewController: UIViewController {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblMiddleText: UILabel!
    @IBOutlet weak var btnInviteFriends: UIButton!
    @IBOutlet weak var btnMaybeLetter: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    var habitId: Int = 0
    var habitType: HabitType = .good
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK:- Instance Methods
extension InviteFriendViewController {
    
    private func setup() {
        self.btnSkip.isHidden = true
        self.habitType = HabitUtils.shared.habitType
        setUpView(habitType:habitType)
        navigationController?.setNavigationBarHidden(true, animated: false)
        [btnInviteFriends, btnMaybeLetter, btnSkip].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }

    func setUpView(habitType: HabitType) {
        switch habitType {
        case .good:
            imgIcon.image = UIImage(named: "goodhabitfriends")
            lblHeaderTitle.text = AppConstant.inviteFriendsGoodTitle
            lblMiddleText.text = AppConstant.inviteFriendsGoodSubTitle
            btnMaybeLetter.setTitle("Maybe Latter", for: .normal)
        case .bad:
            imgIcon.image = UIImage(named: "badHabitfriends")
            lblHeaderTitle.text = AppConstant.inviteFriendsBadTitle
            lblMiddleText.text = AppConstant.inviteFriendsBadSubTitle
            btnMaybeLetter.setTitle("Maybe Latter", for: .normal)
        case .group:
            self.btnSkip.isHidden = false
            imgIcon.image = UIImage(named: "groupHabitFriends")
            btnMaybeLetter.setTitle("Share public", for: .normal)
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
            self.inviteFriendsAction()
        case btnMaybeLetter:
            self.maybeLetterAction()
        case btnSkip:
            self.skipAction()
        default:
            break
        }
    }
    
    private func inviteFriendsAction() {
        print("inviteFriendsAction")
        self.showActivityViewController(url: URL(string: "https://www.apple.com")!, text: "Iscra", image: UIImage(named: "ic-app-logo")!)
    }
    
    private func maybeLetterAction() {
        if self.btnMaybeLetter.currentTitle == "Share public" {
            print("Share public")
            self.router?.push(scene: .shareHabit)
        } else {
            print("MaybeLatterAction")
            self.router?.push(scene: .landing)
        }
    }
    
    private func skipAction() {
        self.router?.push(scene: .landing)
    }
    
    private func showActivityViewController(url:URL,  text: String,  image: UIImage) {
        let items = [url, text, image] as [Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}
