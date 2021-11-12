//
//  LoginViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit


class LoginViewController: UIViewController {
    
    // MARK:-Outlets and variables
    
    @IBOutlet weak var lblHeaderTitle:UILabel!

    @IBOutlet weak var txtFieldEmailId:UITextField!
    @IBOutlet weak var txtFieldPassword:UITextField!
    
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnShowPassword:UIButton!
    @IBOutlet weak var btnForgotPassword:UIButton!
    @IBOutlet weak var btnLoginWithApple:UIButton!
    @IBOutlet weak var btnLoginWithGoogle:UIButton!

    private var viewModel : LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
}

// MARK: Instance Methods
extension LoginViewController {
    private func setup() {
        self.navigationController?.view.backgroundColor = UIColor.white
        lblHeaderTitle.text = AppConstant.loginHeaderTitle
        btnLogin.titleLabel?.font =  UIFont(name: "SF-Pro-Display-Black", size: 50)
        [btnLogin, btnLoginWithGoogle,btnLoginWithApple,btnShowPassword,btnForgotPassword].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
}

// MARK:- UITextFieldDelegate
extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldEmailId{
            self.txtFieldPassword.becomeFirstResponder()
        }else{
            self.txtFieldPassword.resignFirstResponder()
        }
        return false
    }
    
}

// MARK:- Button Action
extension LoginViewController {
        
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnLogin:
            self.loginAction()
        case btnLoginWithGoogle:
            self.loginGoogleAction()
        case btnLoginWithApple:
            self.loginAppleAction()
        case btnShowPassword:
            self.showPasswordAction()
        case btnForgotPassword:
            self.forgotPasswordAction()
        default:
            break
        }
    }
    
    private func loginAction() {
        print("loginAction")
        if viewModel.ValidateUserInputs(emailId: txtFieldEmailId.text ?? "", password: txtFieldPassword.text ?? "")
        {
            viewModel.Login(emailId: txtFieldEmailId.text ?? "", password: txtFieldPassword.text ?? "")
            {
                self.showToast(message:self.viewModel.LoginData.message , seconds: 3.0)
            }
        }
        else {
            print(viewModel.errorMsg)
            self.showToast(message:viewModel.errorMsg , seconds: 1.0)
        }
    }
    
    private func loginGoogleAction() {
        print("loginGoogleAction")
    }
    
    private func loginAppleAction() {
        print("loginAppleAction")
    }
    
    private func showPasswordAction() {
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
        let VC = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        navigationController?.pushViewController(VC, animated: true)
    }
    
}


