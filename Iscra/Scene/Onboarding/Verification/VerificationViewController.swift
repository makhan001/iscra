//
//  VerificationViewController.swift
//  Iscra
//
//  Created by Dr.Mac on 01/11/21.
//

import UIKit

class VerificationViewController: UIViewController {
    
    @IBOutlet weak var verificationTransparentView: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblMiddleTittle: UILabel!
    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var otpTextFieldFirst: UITextField!
    @IBOutlet weak var otpTextFieldSecond: UITextField!
    @IBOutlet weak var otpTextFieldThird: UITextField!
    @IBOutlet weak var otpTextFieldFourth: UITextField!
    
    var verificationCode = ""
    weak var router: NextSceneDismisser?
    weak var delegate: VerificationViewControllerDelegate?
    private let viewModel: VerificationViewModel = VerificationViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        customTextFieldFont()
        addBottomLayerTo(textField: otpTextFieldFirst)
        addBottomLayerTo(textField: otpTextFieldSecond)
        addBottomLayerTo(textField: otpTextFieldThird)
        addBottomLayerTo(textField: otpTextFieldFourth)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        verificationTransparentView.addGestureRecognizer(tap)
        
    }
    func addBottomLayerTo(textField: UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: 5, y: textField.frame.height + 5, width: textField.frame.width , height: 2)
        textField.layer.addSublayer(layer)
    }
}
// MARK:- Instance Methods
extension VerificationViewController {
    private func setup() {
        viewModel.view = self
        lblHeaderTitle.text = AppConstant.otpHeaderTitle
        lblMiddleTittle.text = AppConstant.otpMiddleTittle
        otpTextFieldFirst.delegate = self
        otpTextFieldSecond.delegate = self
        otpTextFieldThird.delegate = self
        otpTextFieldFourth.delegate = self
        [btnResendCode, btnSubmit].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func customTextFieldFont(){
        otpTextFieldFirst.becomeFirstResponder()
        
    }
    @objc func handleTap() {
        print("tapped")
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK:- Button Action
extension VerificationViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnResendCode:
            self.resendCodeAction()
        case btnSubmit:
            self.btnSubmitAction()
        default:
            break
        }
    }
    
    private func resendCodeAction() {
        viewModel.onAction(action: .resendVerification, for: .verification)
    }
    
    private func btnSubmitAction() {
        //  delegate?.verified()
        // self.dismiss(animated: true, completion: nil)
        self.viewModel.strText1 = self.otpTextFieldFirst.text ?? ""
        self.viewModel.strText2 = self.otpTextFieldSecond.text ?? ""
        self.viewModel.strText3 = self.otpTextFieldThird.text ?? ""
        self.viewModel.strText4 = self.otpTextFieldFourth.text ?? ""
        viewModel.onAction(action: .inputComplete(.verification), for: .verification)
    }
}
// MARK:- TextField Delegate
extension VerificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count)! < 1) && (string.count > 0) {
            if textField == otpTextFieldFirst {
                otpTextFieldSecond.becomeFirstResponder()
            }
            if textField == otpTextFieldSecond {
                otpTextFieldThird.becomeFirstResponder()
            }
            if textField == otpTextFieldThird {
                otpTextFieldFourth.becomeFirstResponder()
            }
            if textField == otpTextFieldFourth {
                otpTextFieldFourth.resignFirstResponder()
            }
            textField.text = string
            return false
        }else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == otpTextFieldSecond{
                otpTextFieldFirst.becomeFirstResponder()
            }
            if textField == otpTextFieldThird{
                otpTextFieldSecond.becomeFirstResponder()
            }
            if textField == otpTextFieldFourth{
                otpTextFieldThird.becomeFirstResponder()
            }
            if textField == otpTextFieldFirst{
                otpTextFieldFirst.resignFirstResponder()
            }
            textField.text = ""
            
            return false
        }
        else if (textField.text?.count)! >= 1 {
            textField.text = string
            DispatchQueue.main.async {
                self.dismissKeyboard()
            }
            return false
        }
        return true
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        print("Api calling")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: API Callback
extension VerificationViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case let .verification(msg):
            self.showToast(message: msg, seconds: 0.5)
            self.router?.dismiss(controller: .verification)
        default:
            break
        }
    }
}
