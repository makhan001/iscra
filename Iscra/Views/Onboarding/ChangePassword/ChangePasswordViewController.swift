//
//  ForgotPasswordViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 20/10/21.
//

import UIKit


class ChangePasswordViewController: UIViewController {
    // MARK:-Outlets and variables
    @IBOutlet weak var txtFieldCurrentPassword: UITextField!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var btnShowCurrentPassword: UIButton!
    @IBOutlet weak var btnShowNewPassword: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet var changePasswordView: UIView!
    @IBOutlet weak var customView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = AppConstant.nav_shangpassword
        setup()
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: Instance Methods
extension ChangePasswordViewController {
    private func setup() {
        btnChangePassword.titleLabel?.font =  UIFont(name: "SF-Pro-Display-Black", size: 50)
        [btnChangePassword,btnForgotPassword,btnShowCurrentPassword,btnShowNewPassword].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }

}
// MARK:-TextField Delegate Methods
extension ChangePasswordViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldCurrentPassword{
            self.txtFieldNewPassword.becomeFirstResponder()
        }else{
            self.txtFieldNewPassword.resignFirstResponder()
        }
        return false
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
       default:
            break
        
        }
    }
    @objc func alertControllerBackTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func changePasswordAction() {
    let VC = storyboard?.instantiateViewController(withIdentifier: "PasswordChangeConfirmationViewController") as! PasswordChangeConfirmationViewController
        navigationController?.present(VC, animated: true, completion: {
            VC.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
        print("changePasswordAction")
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
        print("showCurrentPasswordAction is \(txtFieldCurrentPassword.isSecureTextEntry)")
        if  txtFieldCurrentPassword.isSecureTextEntry == true {
            self.btnShowCurrentPassword.setImage(UIImage(named: "eyeHidden"), for: .normal)
            txtFieldCurrentPassword.isSecureTextEntry = false
        }else{
            self.btnShowCurrentPassword.setImage(UIImage(named: "eyeVisible"), for: .normal)
            txtFieldCurrentPassword.isSecureTextEntry = true
        }
    }
    
    private func showNewPasswordAction() {
        print("ShowNewPasswordAction is \(txtFieldNewPassword.isSecureTextEntry)")
        if  txtFieldNewPassword.isSecureTextEntry == true {
            self.btnShowNewPassword.setImage(UIImage(named: "eyeHidden"), for: .normal)
            txtFieldNewPassword.isSecureTextEntry = false
        }else{
            self.btnShowNewPassword.setImage(UIImage(named: "eyeVisible"), for: .normal)
            txtFieldNewPassword.isSecureTextEntry = true
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
