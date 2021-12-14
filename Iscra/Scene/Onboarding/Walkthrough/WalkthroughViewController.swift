//
//  WalkthroughViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 15/10/21.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblHeaderTitle:UILabel!
    @IBOutlet weak var btnAddMyPicture: UIButton!
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var btnHowToAddMemoji: UIButton!
    @IBOutlet weak var scrollview_Walkthrough: UIScrollView!
    weak var router: NextSceneDismisser?
    var currentIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        scrollview_Walkthrough.isPagingEnabled = true
        scrollview_Walkthrough.showsHorizontalScrollIndicator = false
        [txtName].forEach {
            $0?.delegate = self
        }
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
        self.scrollview_Walkthrough.delegate = self
        self.setButtonStatus()
        [btnBack, btnNext, btnAddMyPicture, btnHowToAddMemoji].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        txtName.delegate = self
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
                self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) - 1
                scrollview_Walkthrough.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width  , y: 0), animated: true)
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
                    self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) + 1
                    scrollview_Walkthrough.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width, y: 0), animated: true)
                }
            } else {
                self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) + 1
                scrollview_Walkthrough.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.size.width, y: 0), animated: true)
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

// MARK:- UIScrollViewDelegate
extension WalkthroughViewController : UIScrollViewDelegate {
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 2 {
            if txtName.text == "" {
                showToast(message: AppConstant.alert_emptynameMsg)
            }
            else{
                self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) + 1
                self.setButtonStatus()
            }
        }
        else{
            self.currentIndex = Int(scrollview_Walkthrough.contentOffset.x/self.view.frame.size.width) + 1
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
                if let text = txtName.text, let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    OnboadingUtils.shared.username = updatedText
                }
            }
            return true
        } else {
            return false
        }
    }
    
}
