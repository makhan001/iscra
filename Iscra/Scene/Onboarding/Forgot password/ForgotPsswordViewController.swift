//
//  ForgotPsswordViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 17/11/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var btnSend:UIButton!
    @IBOutlet weak var textEmail:UITextField!
    @IBOutlet weak var viewNavigation: NavigationBarView!
    
    weak var router: NextSceneDismisser?
    private let viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK:  Instance Methods
extension ForgotPasswordViewController {
    private func setup() {
        self.viewModel.view = self
        self.viewNavigation.lblTitle.text = "Forgot Password"
        self.viewNavigation.delegateBarAction = self
        self.textEmail.delegate = self
        [self.btnSend].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}

// MARK: NAvigation Bar View Delegates
extension ForgotPasswordViewController : NavigationBarViewDelegate {
    func navigationBackAction() {
        self.router?.dismiss(controller: .forgot)
    }
}

// MARK:- Button Action
extension ForgotPasswordViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnSend:
            self.resendAction()
        default:
            break
        }
    }
    private func resendAction() {
        self.dismissKeyboard()
        self.viewModel.onAction(action: .inputComplete(.forgotPassword), for: .forgotPassword)
    }
}

// MARK:- UITextFieldDelegate
extension ForgotPasswordViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textEmail {
            self.textEmail.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            viewModel.email = text.replacingCharacters(in: textRange, with: string)
        }
        return true
    }
}

// MARK: API Callback
extension ForgotPasswordViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case let .forgotPassword(msg):
            self.showToast(message: msg, seconds: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.router?.dismiss(controller: .forgot)
            }
        default:
            break
        }
    }
}

