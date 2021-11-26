//
//  AddHabitViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 27/10/21.
//

import UIKit

class AddHabitViewController: UIViewController {
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var viewDescription:UIView!
    @IBOutlet weak var txtFieldTitle:UITextField!
    @IBOutlet weak var txtViewDescription:UITextView!
   
    var habitType : habitType = .good
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}
extension AddHabitViewController {
    func setup() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        [btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        if habitType == .group{
            viewDescription.isHidden = false
        }
        else
        {
            viewDescription.isHidden = true
        }
    }
}
// MARK:- Button Action
extension AddHabitViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnNext:
            self.NextClick()
        default:
            break
        }
    }
    
    private func NextClick() {
        
//        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SetThemeViewController") as! SetThemeViewController
//        vc.habitType = habitType
//        navigationController?.pushViewController(vc, animated: true)
        
        let setTheme: SetThemeViewController = SetThemeViewController.from(from: .habit, with: .setTheme)
        setTheme.habitType = habitType
        self.navigationController?.pushViewController(setTheme, animated: true)
    }
}
