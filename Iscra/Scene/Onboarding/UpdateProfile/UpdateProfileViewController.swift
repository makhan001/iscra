//
//  EditNameViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 20/10/21.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    // MARK:Outlets and variables
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewNavigation: NavigationBarView!
    
    var didUpdateName:(() -> Void)?
    weak var router: NextSceneDismisser?
    var delegateBarAction:NavigationBarViewDelegate?
    private let viewModel: UpdateProfileViewModel = UpdateProfileViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
}

// MARK: Instance Methods
extension UpdateProfileViewController {
    private func setup() {
        self.viewModel.view = self
        self.txtName.text = UserStore.userName?.capitalized
        self.viewModel.username = UserStore.userName  ?? ""
        self.viewNavigation.navType = .editName
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text =  "Edit name"
        self.viewNavigation.delegateBarAction = self
        self.txtName.delegate = self
    }
    
    private func setNameTextField(string:String, range: NSRange)  {
        guard let text = txtName.text, let textRange = Range(range, in: text) else { return }
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        self.viewModel.username = updatedText
    }
    
}

// MARK: Navigation Bar Delegate
extension UpdateProfileViewController: NavigationBarViewDelegate{
    func navigationBackAction() {
        self.router?.dismiss(controller: .updateProfile)
    }
    
    func navigationRightButtonAction() {
        self.viewModel.onAction(action: .inputComplete(.updateProfile), for: .updateProfile)
    }
}

// MARK: Textfiled Delegate
extension UpdateProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtName.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if string.rangeOfCharacter(from: .decimalDigits) != nil
//            || string.rangeOfCharacter(from: .whitespacesAndNewlines) != nil {
//            return false
//        }
        if string.rangeOfCharacter(from: .whitespacesAndNewlines) != nil || string.containsEmoji {
            return false
        }
        let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        if newLength <= 30 {
            
            let characterSet = NSCharacterSet(charactersIn: AppConstant.USERNAME_ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: characterSet).joined(separator: "")
           // self.setNameTextField(string: string, range: range)
            self.setNameTextField(string: filtered, range:range)
            return (string == filtered)
        } else {
            return true
        }
    }
}

// MARK: API Callback
extension UpdateProfileViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case .updateProfile:
            self.didUpdateName?()
            self.router?.dismiss(controller: .updateProfile)
        default:
            break
        }
    }
}
