//
//  SetThemeViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 21/10/21.
//


import UIKit
enum HabitType: String {
    case good, bad, group
}

protocol SelectHabitPopUpDelegate: AnyObject {
    func addHabit(type: HabitType)
}

class SelectHabitPopUpViewController: UIViewController { // HabitTypeViewController
    
    @IBOutlet weak var btnBadHabit:UIButton!
    @IBOutlet weak var backGroundView:UIView!
    @IBOutlet weak var btnGoodHabit:UIButton!
    @IBOutlet weak var btnGroupHabit:UIButton!
    
    var habitType: HabitType = .good
    weak var router: NextSceneDismisser?
    weak var delegate: SelectHabitPopUpDelegate?
    var habitPopupSelected:((Bool) ->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension SelectHabitPopUpViewController {
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backGroundView.addGestureRecognizer(tap)
        [btnBadHabit, btnGoodHabit,btnGroupHabit].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let imageDataDict:[String: String] = ["name": "tab3"]
        NotificationCenter.default.post(name: .RotateTab, object: nil, userInfo: imageDataDict)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Button Action
extension SelectHabitPopUpViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnGoodHabit:
            self.habitTypeAction(type: .good)
        case btnBadHabit:
            self.habitTypeAction(type: .bad)
        case btnGroupHabit:
            self.habitTypeAction(type: .group)
        default:
            break
        }
    }
    
    private func habitTypeAction(type: HabitType) {
        self.dismiss(animated: true, completion: nil)
        delegate?.addHabit(type: type)
    }
}
