//
//  ForgotPasswordViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 20/10/21.
//

import UIKit


class ChangePasswordViewController: UIViewController {
    // MARK:-Outlets and variables
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    @IBOutlet weak var txtFieldCurrentPassword: UITextField!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var btnShowCurrentPassword: UIButton!
    @IBOutlet weak var btnShowConfirmPassword: UIButton!
    @IBOutlet weak var btnShowNewPassword: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet var changePasswordView: UIView!
    @IBOutlet weak var customView: UIView!
    private let viewModel: ChangePasswordViewModel = ChangePasswordViewModel(provider: OnboardingServiceProvider())
    @IBOutlet weak var viewNavigation:NavigationBarView!
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.title = AppConstant.nav_shangpassword
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // print("self.router is \(self.router)")
        self.viewNavigation.lblTitle.text =  "Change password"
        self.viewNavigation.delegateBarAction = self
    }
}

// MARK: Instance Methods
extension ChangePasswordViewController: navigationBarAction {
    private func setup() {
        viewModel.view = self
        [btnChangePassword,btnForgotPassword,btnShowCurrentPassword,btnShowNewPassword,btnShowConfirmPassword].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        
    }
    func ActionType()  {
        self.router?.dismiss(controller: .webViewController)
    }
    
}
// MARK:-TextField Delegate Methods
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldCurrentPassword{
            self.txtFieldNewPassword.becomeFirstResponder()
        }else if textField == self.txtFieldNewPassword{
            self.txtFieldConfirmPassword.becomeFirstResponder()
        }else{
            self.txtFieldConfirmPassword.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFieldCurrentPassword {
            if let text = txtFieldCurrentPassword.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                viewModel.password = updatedText
            }
        } else if textField == txtFieldNewPassword {
            if let text = txtFieldNewPassword.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                viewModel.newPassword = updatedText
            }
        } else if textField == txtFieldConfirmPassword {
            if let text = txtFieldConfirmPassword.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                viewModel.confirmPassword = updatedText
            }
        }
        return true
    }
}
// MARK:- Button Action
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
    @objc func alertControllerBackTapped()
    {
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

// MARK:- AlertView
extension UIAlertController {
    //Set title font and message color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let attributeString = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle])//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")
    }
    
    //Set message font and message color
    func setForgotMessage(font: UIFont?, color: UIColor?) {
        guard let title = self.message else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let attributedString = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle])
        if let titleFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font : titleFont], range: NSMakeRange(0, title.utf8.count))
        }
        if let titleColor = color {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor], range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributedString, forKey: "attributedMessage")
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
            self.showToast(message: msg)
            self.showToast(message: msg, seconds: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.router?.dismiss(controller: .changePassword)
            }
            break
        default:
            break
        }
    }
}
