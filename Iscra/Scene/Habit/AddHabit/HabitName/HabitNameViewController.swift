//
//  HabitNameViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 27/10/21.
//



import UIKit

class HabitNameViewController: UIViewController {
    
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var viewDescription:UIView!
    @IBOutlet weak var imageEmoji:UIImageView!
    @IBOutlet weak var txtFieldTitle:UITextField!
    @IBOutlet weak var txtViewDescription:UITextView!
    @IBOutlet weak var viewNavigation:NavigationBarView!

    weak var router: NextSceneDismisser?
    let viewModel = AddHabitViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension HabitNameViewController {
    private func setup() {
        self.viewModel.view = self
        self.viewAccordingToHabitType()
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text = ""
        self.viewNavigation.navType = .addHabit
        self.viewNavigation.delegateBarAction = self
        self.lblUserName.text = "Alright \(UserStore.userName!), let’s \ndefine your habit"
        viewModel.didNavigateToSetTheme = self.didNavigateToSetTheme
        [btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func viewAccordingToHabitType() {
        if viewModel.habitType == .group {
            self.viewDescription.isHidden = false
            self.txtFieldTitle.returnKeyType = .next
            self.lblUserName.text = AppConstant.groupHabitTitle
            self.imageEmoji.image = #imageLiteral(resourceName: "group")
        } else {
            if viewModel.habitType == .good {
                self.lblUserName.text = "Alright \(UserStore.userName!)" + AppConstant.goodHabitTitle
                self.imageEmoji.image = #imageLiteral(resourceName: "good")
            } else {
                self.lblUserName.text = "Hi \(UserStore.userName!)" + AppConstant.badHabitTitle
                self.imageEmoji.image = #imageLiteral(resourceName: "bad")
            }
            self.viewDescription.isHidden = true
            self.txtFieldTitle.returnKeyType = .done
        }
    }
}

// MARK:- Button Action
extension HabitNameViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnNext:
            self.nextClick()
        default:
            break
        }
    }
    
    private func nextClick() {
        HabitUtils.shared.habitType = self.viewModel.habitType
        viewModel.onAction(action: .inputComplete(.createHabit), for: .createHabit)
    }
    
    private func didNavigateToSetTheme(isNavigate: Bool) {
        if isNavigate{
           self.router?.push(scene: .setTheme)
        }
    }
}

// MARK:- UITextField Delegate
extension HabitNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.viewModel.habitType == .group {
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
       let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        if newLength <= 30 {
            if textField == txtFieldTitle {
                if let text = txtFieldTitle.text, let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    viewModel.habitName = updatedText
                }
                let allowedCharacter = CharacterSet.letters
                let allowedCharacter1 = CharacterSet.whitespaces
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacter.isSuperset(of: characterSet) || allowedCharacter1.isSuperset(of: characterSet)
            }
            return true
        } else {
            return false
        }
    }
}

// MARK:- UITextViewDelegate
extension HabitNameViewController: UITextViewDelegate {

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
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.2)
        }
    }
    
    @objc func reload() {
        viewModel.description = self.txtViewDescription.text
    }
}

// MARK: API Callback
extension HabitNameViewController: HabitViewRepresentable {
    func onAction(_ action: HabitAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        default:
            break
        }
    }
}

// MARK: NavigationBarView Gelegate
extension HabitNameViewController  : NavigationBarViewDelegate {
    func navigationBackAction() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchAllGroup"), object: nil)
        HabitUtils.shared.removeAllHabitData()
        router?.dismiss(controller: .addHabit)
    }
    
    func navigationRightButtonAction() {
        HabitUtils.shared.removeAllHabitData()
        router?.dismiss(controller: .addHabit)
    }
}
