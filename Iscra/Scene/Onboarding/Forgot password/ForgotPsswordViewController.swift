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

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUps()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// Initial Congfigrations
extension ForgotPasswordViewController {
    func SetUps() {
        viewModel.view = self
        viewNavigation.lblTitle.text = "Forgot Password"
        viewNavigation.delegateBarAction = self
        [btnSend].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}
// NAvigation Delegates
extension ForgotPasswordViewController : navigationBarAction {
    func ActionType() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- Button Action
extension ForgotPasswordViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnSend:
            self.sendAction()
        default:
            break
        }
    }
    
    private func sendAction() {
        print("sendAction")
        self.textEmail.resignFirstResponder()
        viewModel.onAction(action: .inputComplete(.forgotPassword), for: .forgotPassword)
    }
}

// MARK:- UITextFieldDelegate
extension ForgotPasswordViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textEmail.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textEmail.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                viewModel.email = updatedText
            }
        return true
    }
}

// MARK: API Callback
extension ForgotPasswordViewController: OnboardingViewRepresentable  {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case let .forgotPassword(msg):
          self.showToast(message: msg)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.dismiss(animated: true, completion: nil)
                        }
            break
        default:
            break
        }
    }
    
}
