//
//  SetThemeViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 21/10/21.
//


import UIKit
enum HabitType: String {
    case good, bad, group_habit
}

protocol SelectHabitPopUpDelegate: AnyObject {
    func addHabit(type: HabitType)
}

class SelectHabitPopUpViewController: UIViewController {
    
    @IBOutlet weak var btnBadHabit:UIButton!
    @IBOutlet weak var backGroundView:UIView!
    @IBOutlet weak var btnGoodHabit:UIButton!
    @IBOutlet weak var btnGroupHabit:UIButton!
    
    var habitType: HabitType = .good
    weak var router: NextSceneDismisser?
    weak var delegate: SelectHabitPopUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("self. router on SelectHabitPopUpViewController is \(String(describing: self.router))")
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
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- Button Action
extension SelectHabitPopUpViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnGoodHabit:
            self.addGoodHabit()
        case btnBadHabit:
            self.addBadHabit()
        case btnGroupHabit:
            self.addGroupHabit()
        default:
            break
        }
    }
    
    private func addGoodHabit() {
        self.dismiss(animated: true, completion: nil)
        delegate?.addHabit(type: .good)
    }
    private func addBadHabit() {
        self.dismiss(animated: true, completion: nil)
        delegate?.addHabit(type: .bad)
    }
    private func addGroupHabit() {
        self.dismiss(animated: true, completion: nil)
        delegate?.addHabit(type: .group_habit)
    }
}
