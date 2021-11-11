//
//  SignupViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift

class SignupViewController: UIViewController {
    
    // MARK:-Outlets and variables
    
    @IBOutlet weak var lblHeaderTitle:UILabel!
    @IBOutlet weak var txtFieldEmailId:UITextField!
    @IBOutlet weak var txtFieldPassword:UITextField!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var btnRegisterWithGoogle:UIButton!
    @IBOutlet weak var btnRegisterWithApple:UIButton!
    @IBOutlet weak var btnShowPassword:UIButton!
    
    private var viewModel : SignUpViewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: Instance Methods
extension SignupViewController {
    private func setup() {
        IQKeyboardManager.shared.enable = true
        lblHeaderTitle.text = "Let’s create your \naccount"
        [btnRegister, btnRegisterWithGoogle,btnRegisterWithApple,btnShowPassword].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnRegister:
            self.registerAction()
        case btnRegisterWithGoogle:
            self.registerGoogleAction()
        case btnRegisterWithApple:
            self.registerAppleAction()
        case btnShowPassword:
            self.showPasswordAction()
        default:
            break
        }
    }
    
    private func registerAction() {
        if viewModel.ValidateUserInputs(emailId: txtFieldEmailId.text ?? "", password: txtFieldPassword.text ?? "")
        {
            viewModel.signUp(emailId: txtFieldEmailId.text ?? "", password: txtFieldPassword.text ?? "")
            {
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                VC.delegateOTP = self
                self.navigationController?.present(VC, animated: true, completion: {
                    VC.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
                })
            }
        }
        else {
            print(viewModel.errorMsg)
            self.showToast(message:viewModel.errorMsg , seconds: 1.0)
        }
    }
    
    private func registerGoogleAction() {
        print("googleLogin")
    }
    
    private func registerAppleAction() {
       print("Applelogin")
    }
    
    private func showPasswordAction() {
        print("showPasswordAction is \(txtFieldPassword.isSecureTextEntry)")
        if  txtFieldPassword.isSecureTextEntry == true {
            self.btnShowPassword.setImage(UIImage(named: "eyeHidden"), for: .normal)
            txtFieldPassword.isSecureTextEntry = false
        }else{
            self.btnShowPassword.setImage(UIImage(named: "eyeVisible"), for: .normal)
            txtFieldPassword.isSecureTextEntry = true
        }
    }
    
    private func forgotPasswordAction() {
        print("forgotPasswordAction")
    }
}

extension SignupViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldEmailId{
            self.txtFieldPassword.becomeFirstResponder()
        }else{
            self.txtFieldPassword.resignFirstResponder()
        }
        return false
    }
}

extension SignupViewController : verificationDelegate {
    func verified() {
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandingTabBarViewController") as! LandingTabBarViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



