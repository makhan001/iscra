//
//  WalkthroughViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 15/10/21.
//

import UIKit

class WalkthroughViewController: UIViewController {
    // MARK:-Outlets and variables
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var lblHeaderTitle:UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnAddMyPicture: UIButton!
    @IBOutlet weak var btnHowToAddMemoji: UIButton!
    @IBOutlet weak var textNameView: IscraCustomView!
    var currentIndex: Int = 1
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
}

// MARK:- Instance Methods
extension WalkthroughViewController {
    private func setup() {
        lblHeaderTitle.text = AppConstant.onbordingName //"How do your \nfriends call you?"
        self.scrollView.delegate = self
        self.setButtonStatus()
        [btnBack, btnNext, btnAddMyPicture, btnHowToAddMemoji].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        txtName.delegate = self
    }
    //Mark:- Set Scrollview
    private func setScrollView() {
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
}

// MARK:- Button Action
extension WalkthroughViewController  {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnBack:
            self.backButtonAction()
        case btnNext:
            self.nextButtonAction()
        case btnAddMyPicture:
            self.addMyPictureAction()
        case btnHowToAddMemoji:
            self.howToAddMemojiAction()
        default:
            break
        }
    }
    private func backButtonAction() {
        print("currentIndex. \(currentIndex)")
        if self.currentIndex >= 1 {
            if self.currentIndex == 1 {
                // navigationController?.popViewController(animated: true)
                self.router?.dismiss(controller: .walkthrough)
            }else{
                self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) - 1
                scrollView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width  , y: 0), animated: true)
            }
        }
        else{
            navigationController?.popViewController(animated: true)
        }
        
    }
    private func nextButtonAction() {
        if self.currentIndex <= 2 {
            if currentIndex == 2 {
                if OnboadingUtils.shared.username == "" {
                    showToast(message: AppConstant.alert_emptynameMsg)
                    
                } else {
                    self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) + 1
                    scrollView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width, y: 0), animated: true)
                }
            } else {
                self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) + 1
                scrollView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width, y: 0), animated: true)
            }
        }
        
        if self.currentIndex == 3 {
            self.router?.push(scene: .signup)
        }
    }
    
    private func addMyPictureAction() {
        self.router?.push(scene: .addMyPicture)
    }
    
    private func howToAddMemojiAction() {
        self.router?.push(scene: .learnHowToAddMemoji)
    }
    
    func setButtonStatus(){
        if self.currentIndex == 3 {
            btnNext.setTitle("Skip", for: .normal)
        }
        else if
            self.currentIndex == 2 {
            btnNext.setTitle("Next", for: .normal)
        }
        else if self.currentIndex == 1 {
            btnNext.setTitle("Next", for: .normal)
        }
    }
}

// MARK:- ScrollView Delegate
extension WalkthroughViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 2 {
            if txtName.text == "" {
                showToast(message: AppConstant.alert_emptynameMsg)
            }
            else{
                self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) + 1
                self.setButtonStatus()
            }
        }
        else{
            self.currentIndex = Int(scrollView.contentOffset.x/self.view.frame.size.width) + 1
            self.setButtonStatus()
        }
    }
}

// MARK:- UITextFieldDelegate
extension WalkthroughViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        if newLength <= 30 {
        if textField == txtName {
        if (string == " ") {
            return false
            }
          if txtName.text!.count > 0  {
            textNameView.layer.borderColor = UIColor(red: 0.758, green: 0.639, blue: 0.158, alpha: 1).cgColor
            textNameView.layer.borderWidth = 1
           }
           if newLength == 0{
              textNameView.layer.borderColor = UIColor.clear.cgColor
              textNameView.layer.borderWidth = 1
            }
            if let text = txtName.text, let textRange = Range(range, in: text) {
               let updatedText = text.replacingCharacters(in: textRange, with: string)
               OnboadingUtils.shared.username = updatedText
            }
            let allowedCharacter = CharacterSet.letters
            let allowedCharacter1 = CharacterSet.whitespaces
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacter.isSuperset(of: characterSet) || allowedCharacter1.isSuperset(of: characterSet)
            }
           return true
        }
        else {
             return false
        }
    }
}
