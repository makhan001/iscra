//
//  EditNameViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 20/10/21.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    // MARK:-Outlets and variables
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewNavigation: NavigationBarView!
    
    weak var router: NextSceneDismisser?
    var delegateBarAction:navigationBarAction?
    private let viewModel: UpdateProfileViewModel = UpdateProfileViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
// MARK: Instance Methods
extension UpdateProfileViewController:  navigationBarAction{
    private func setUp() {
        viewModel.view = self
        self.txtName.text = UserStore.userName?.capitalized
        viewModel.username = UserStore.userName  ?? ""
        self.viewNavigation.navType = .editName
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text =  "Edit name"
        self.viewNavigation.delegateBarAction = self
        [txtName].forEach {
            $0?.delegate = self
        }
    }
    func ActionType() {
      self.navigationController?.popViewController(animated: true)
}
    func RightButtonAction() {
        viewModel.onAction(action: .inputComplete(.updateProfile), for: .updateProfile)
    }
}

// MARK:- Textfiled Delegate
extension UpdateProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtName.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        if newLength <= 30 {
            if textField == txtName {
                if let text = txtName.text, let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    viewModel.username = updatedText
                }
            }
            return true
        } else {
            return false
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
            navigationController?.popViewController(animated: true)
       default:
            break
        }
    }
}
