//
//  SetThemeViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 21/10/21.
//


import UIKit
enum habitType {
    case good
    case bad
    case group
}

protocol selectHabitToAddProtocol: class {
    func addHabit(habitType:habitType)
}
class SelectHabitPopUpViewController: UIViewController {
    
    @IBOutlet weak var btnBadHabit:UIButton!
    @IBOutlet weak var backGroundView:UIView!
    @IBOutlet weak var btnGoodHabit:UIButton!
    @IBOutlet weak var btnGroupHabit:UIButton!
    
    weak var delegate : selectHabitToAddProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        delegate?.addHabit(habitType: .good)
    }
    private func addBadHabit() {
        self.dismiss(animated: true, completion: nil)
        delegate?.addHabit(habitType: .bad)
    }
    private func addGroupHabit() {
        self.dismiss(animated: true, completion: nil)
        delegate?.addHabit(habitType: .group)
    }
}
