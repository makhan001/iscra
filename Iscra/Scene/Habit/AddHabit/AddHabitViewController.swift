//
//  AddHabitViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 27/10/21.
//

import UIKit

class AddHabitViewController: UIViewController {
    
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var viewDescription:UIView!
    @IBOutlet weak var txtFieldTitle:UITextField!
    @IBOutlet weak var txtViewDescription:UITextView!

    var habitType : habitType = .good
    private let viewModel = AddHabitViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

extension AddHabitViewController {
    func setup() {
        viewModel.view = self
        self.lblUserName.text = "Alright \(UserStore.userName!), let’s \ndefine your habit"
        navigationController?.setNavigationBarHidden(false, animated: false)
        [btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        if habitType == .group{
            self.viewDescription.isHidden = false
            self.txtFieldTitle.returnKeyType = .next
        }else{
            self.viewDescription.isHidden = true
            self.txtFieldTitle.returnKeyType = .done
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
        
        viewModel.habitType = self.habitType
        HabitUtils.shared.habitType = self.habitType
        viewModel.onAction(action: .inputComplete(.createHabit), for: .createHabit)
        viewModel.didNavigateToSetTheme = {
            isNavigate in
            if isNavigate{
                let setTheme: SetThemeViewController = SetThemeViewController.from(from: .habit, with: .setTheme)
                setTheme.habitType = self.habitType
                       self.navigationController?.pushViewController(setTheme, animated: true)
            }
        }
    }
}

// MARK:- Textfiled Delegate
extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if habitType == .group{
            if textField == self.txtFieldTitle {
                self.txtViewDescription.becomeFirstResponder()
            } else {
                self.txtViewDescription.resignFirstResponder()
            }
        }else{
            if textField == self.txtFieldTitle {
                self.txtFieldTitle.resignFirstResponder()
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFieldTitle {
            if let text = txtFieldTitle.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                viewModel.habitName = updatedText
            }
        }
        return true
    }
}

// MARK:- UITextViewDelegate
extension AddHabitViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == txtViewDescription {
            let text = self.txtViewDescription.text! as NSString
            var substring: String = txtViewDescription.text!
            substring = (substring as NSString).replacingCharacters(in: range, with: text as String)
            substring = substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.searchAutocompleteEntries(withSubstring: substring)
        } else if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func searchAutocompleteEntries(withSubstring substring: String) {
        if substring != "" {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func reload() {
        viewModel.description = self.txtViewDescription.text
    }
}

// MARK: API Callback
extension AddHabitViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
//        case let .login(msg, isVerified):
//            self.showToast(message: msg, seconds: 0.5)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.naviateUserAfterLogin(isVerified)
//            }
        default:
            break
        }
    }
    
}

