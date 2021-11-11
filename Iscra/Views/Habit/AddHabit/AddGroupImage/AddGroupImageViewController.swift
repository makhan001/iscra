//
//  AddGroupImageViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 11/11/21.
//

import UIKit

class AddGroupImageViewController: UIViewController {
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgGroup: UIImageView!
    var habitType : habitType = .good
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUp()
    }
}

extension AddGroupImageViewController {
    func SetUp() {
        [btnSkip, btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imgGroup.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print("Open Image picker")
    }
}

// MARK:- Button Action
extension AddGroupImageViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnSkip:
            self.skipClick()
        case btnNext:
            self.nextClick()
        default:
            break
        }
    }
    
    private func nextClick() {
        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.habitType = habitType
        vc.delegateInvite = self
        self.present(vc, animated: true, completion: nil)
    }
    private func skipClick() {
        
    }
}

extension AddGroupImageViewController : InviteNavigation {
    func navigate(inviteType: inviteType) {
        if inviteType == .mayBeLatter{
            guard let viewControllers = navigationController?.viewControllers else { return }
            for vc in viewControllers {
                if vc is LandingTabBarViewController {
                    navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
        else{
            
        }
    }
}
