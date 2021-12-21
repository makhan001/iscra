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
    private let viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel(provider: OnboardingServiceProvider())
    weak var router: NextSceneDismisser?

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUps()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK:  Initial Congfigrations
extension ForgotPasswordViewController {
    func SetUps() {
        viewModel.view = self
        viewNavigation.lblTitle.text = "Forgot Password"
        viewNavigation.delegateBarAction = self
        [textEmail].forEach{
            $0?.delegate = self
        }
        [btnSend].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}

// MARK: NAvigation Delegates
extension ForgotPasswordViewController : navigationBarAction {
    func ActionType() {
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
        print("resendAction")
        self.textEmail.resignFirstResponder()
        viewModel.onAction(action: .inputComplete(.forgotPassword), for: .forgotPassword)
    }
}

// MARK:- UITextFieldDelegate
extension ForgotPasswordViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textEmail{
            self.textEmail.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textEmail {
            if let text = textEmail.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                viewModel.email = updatedText
            }
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

