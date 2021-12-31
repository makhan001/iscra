//
//  ForgotPasswordViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 20/10/21.
//

import UIKit
import Alamofire


class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet var changePasswordView: UIView!
    
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnShowNewPassword: UIButton!
    @IBOutlet weak var btnShowCurrentPassword: UIButton!
    @IBOutlet weak var btnShowConfirmPassword: UIButton!
    
    @IBOutlet weak var txtFieldNewPassword: UITextField! // txtNewPassword // txtNew
    @IBOutlet weak var txtFieldCurrentPassword: UITextField! // txtCurrentPassword // txtCurrent
    @IBOutlet weak var txtFieldConfirmPassword: UITextField! // txtConfirmPassword // txtConfirm
    
    @IBOutlet weak var viewNavigation:NavigationBarView!
    
    weak var router: NextSceneDismisser?
    private let viewModel: ChangePasswordViewModel = ChangePasswordViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension ChangePasswordViewController {
    private func setup() {
        self.viewModel.view = self
        self.viewNavigation.delegateBarAction = self
        self.viewNavigation.lblTitle.text =  "Change password"
        [btnChangePassword, btnForgotPassword, btnShowCurrentPassword, btnShowNewPassword, btnShowConfirmPassword].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}

// MARK: NavigationBarView Delegate
extension ChangePasswordViewController: NavigationBarViewDelegate {
    func navigationBackAction()  {
        self.router?.dismiss(controller: .webViewController)
    }
}

// MARK:TextField Delegate Methods
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldCurrentPassword {
            self.txtFieldNewPassword.becomeFirstResponder()
        } else if textField == self.txtFieldNewPassword {
            self.txtFieldConfirmPassword.becomeFirstResponder()
        } else {
            self.txtFieldConfirmPassword.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: .whitespacesAndNewlines) != nil { return false }
        guard let text = textField.text, let textRange = Range(range, in: text) else { return false }
        switch textField {
        case txtFieldCurrentPassword:
            viewModel.password = text.replacingCharacters(in: textRange, with: string)
        case txtFieldNewPassword:
            viewModel.newPassword = text.replacingCharacters(in: textRange, with: string)
        case txtFieldConfirmPassword:
            viewModel.confirmPassword = text.replacingCharacters(in: textRange, with: string)
        default:
            break
        }
        return true
    }
}
// MARK: Button Action
extension ChangePasswordViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnChangePassword:
            self.changePasswordAction()
        case btnForgotPassword:
            self.forgotPasswordAction()
        case btnShowCurrentPassword:
            self.showCurrentPasswordAction()
        case btnShowNewPassword:
            self.showNewPasswordAction()
        case btnShowConfirmPassword:
            self.showConfirmPasswordAction()
        default:
            break
        }
    }
    
    @objc func alertControllerBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func changePasswordAction() {
        print("changePasswordAction")
        self.viewModel.password = self.txtFieldCurrentPassword.text ?? ""
        self.viewModel.newPassword = self.txtFieldNewPassword.text ?? ""
        self.viewModel.confirmPassword = self.txtFieldConfirmPassword.text ?? ""
        self.viewModel.onAction(action: .inputComplete(.changePassword), for: .changePassword)
    }
    
    private func forgotPasswordAction() {
        let alert = UIAlertController(title: "We send you a new \npassword in your email", message: "\nWe send your new password to \nyour email. If you cannot find it in \nyour inbox check your spam folder.", preferredStyle: .alert)
        alert.setTitlet(font: UIFont(name: "SourceSansPro-Bold", size: 20), color: UIColor.black)
        alert.setForgotMessage(font: UIFont(name: "SourceSansPro-Regular", size: 16), color: UIColor.black)
        alert.view.backgroundColor = UIColor.init(named: "WhitePrimaryAccent")
        alert.view.alpha = 0.7
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackTapped)))
        })
        print("forgotPasswordAction")
    }
    
    private func showCurrentPasswordAction() {
        if self.btnShowCurrentPassword.isSelected {
            self.btnShowCurrentPassword.isSelected = false
            self.txtFieldCurrentPassword.isSecureTextEntry = true
        } else {
            self.btnShowCurrentPassword.isSelected = true
            self.txtFieldCurrentPassword.isSecureTextEntry = false
        }
    }
    
    private func showNewPasswordAction() {
        if self.btnShowNewPassword.isSelected {
            self.btnShowNewPassword.isSelected = false
            self.txtFieldNewPassword.isSecureTextEntry = true
        } else {
            self.btnShowNewPassword.isSelected = true
            self.txtFieldNewPassword.isSecureTextEntry = false
        }
    }
    
    private func showConfirmPasswordAction() {
        if self.btnShowConfirmPassword.isSelected {
            self.btnShowConfirmPassword.isSelected = false
            self.txtFieldConfirmPassword.isSecureTextEntry = true
        } else {
            self.btnShowConfirmPassword.isSelected = true
            self.txtFieldConfirmPassword.isSecureTextEntry = false
        }
    }
}

// MARK: API Callback
extension ChangePasswordViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
            WebService().StopIndicator()
        case let .changePassword(msg):
            self.showToast(message: msg, seconds: 0.7)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.71) {
                self.router?.dismiss(controller: .changePassword)
            }
            break
        default:
            break
        }
    }
}
