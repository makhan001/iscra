//
//  MyAccountViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import MessageUI
import Quickblox
import SVProgressHUD


class MyAccountViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnGetSubscription: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: IscraCustomLabel!
    @IBOutlet weak var tableView: MyAccountTableView!
    @IBOutlet weak var viewNavigation: NavigationBarView!
    
    weak var router: NextSceneDismisser?
    var delegateBarAction:NavigationBarViewDelegate?
    private var imagePicker = UIImagePickerController()
    let viewModel: MyAccountViewModel = MyAccountViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.retriveUserDetails()
    }
}

// MARK: Instance Methods
extension MyAccountViewController {
    private func setup() {
        imgProfile.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imgProfile.addGestureRecognizer(tapRecognizer)
        self.viewModel.view = self
        [btnGetSubscription,btnLogout].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        tableView.configure()
        tableView.delegateNavigate = self
        self.viewNavigation.navType = .myProfie
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text =  "My profile"
        self.viewNavigation.delegateBarAction = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserImage(_:)), name: .UpdateUserImage, object: nil)
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
    }
    
    @objc func updateUserImage(_ notification: Notification) {
        self.imgProfile.setImageFromURL(UserStore.userImage ?? "", with: AppConstant.UserPlaceHolderImage)
    }
    
    @objc func imageTapped(sender: UIImageView) {
        print("image tapped")
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ZoomImageViewController") as! ZoomImageViewController
        vc.strUrl = UserStore.userImage ?? ""
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    private func retriveUserDetails() {
        self.lblName.text = UserStore.userName?.capitalized
        self.imgProfile.setImageFromURL(UserStore.userImage ?? "", with: AppConstant.UserPlaceHolderImage)
    }
    
    func didUpdateName() {
        self.lblName.text = UserStore.userName?.capitalized
    }
   
}

// MARK: Navigation Delegates
extension MyAccountViewController: NavigationBarViewDelegate {
    func navigationBackAction() {}
    
    func navigationRightButtonAction() {
        self.router?.push(scene: .updateProfile)
    }
}

// MARK: Button Action
extension MyAccountViewController {
   
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        
        case btnGetSubscription:
            self.getSubscriptionAction()
        case btnLogout:
            self.logoutAction()
        default:
            break
        }
    }
   
    private func getSubscriptionAction() {
        let days = 21 - UserStore.userCreateDate.daysDifference
        if days <= 21 {
            self.alertForSubscription(days)
        } else {
            self.router?.push(scene: .subscription)
        }
    }
    
    private func logoutAction() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure? logout from Iscra.", preferredStyle: .alert)
        let logoutaction = UIAlertAction(title: "Logout", style: .default) { (action:UIAlertAction!) in
            print("Delete button tapped");
            self.viewModel.logout()
        }
        logoutaction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
        alertController.addAction(logoutaction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func alertForSubscription(_ remainingDays: Int) {
        let alertController = UIAlertController(title: "Your " + String(remainingDays) + " free trial days are remaining. Do you want to go with subscription to become a prime member?", message: "", preferredStyle: .alert)
        let SubscriptionAction = UIAlertAction(title: "Proceed", style: .default) { (action:UIAlertAction!) in
            self.router?.push(scene: .subscription)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        SubscriptionAction.setValue(UIColor.gray, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        alertController.addAction(SubscriptionAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
}

extension MyAccountViewController: clickManagerDelegate{
    func tableViewCellNavigation(performAction: clickManager) {
        switch performAction {
        case .changeProfilePhoto:
            self.changeProfilePhoto()
        case .addYourOwnMemoji:
            self.addMemojiAction()
        case .changePassword:
            self.changePasswordAction()
        case .shareWithFriends:
            self.showActivityViewController(url: URL(string: AppConstant.IscraAppLink)!, text: AppConstant.shareAppMessage, image: UIImage(named: "ic-app-logo")!)
        case .rateUs:
            self.rateUs()
        case .contactDeveloper:
            self.composerEmail()
        case .termsAndCondition:
            self.navigaetToWebView(.termsAndConditions)
        case .privacyPolicy:
            self.navigaetToWebView(.privacyPolicy)
        case .aboutUs:
            self.navigaetToWebView(.aboutUs)
        case .everyDay:
            print(performAction)
        case .reminder:
            print(performAction)
        case .changeColorTheme:
            print(performAction)
        }
    }
    
    private func addMemojiAction() {
        self.router?.push(scene: .learnHowToAddMemoji)
    }
    
    private func changePasswordAction() {
        self.router?.push(scene: .changePassword)
    }
    
    private func changeProfilePhoto() {
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "myAccountPopup") as! MyAccountPopupViewController
        vc.delegate = self
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    private func showActivityViewController(url:URL,  text: String,  image: UIImage) {
        let items = [url, text, image] as [Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    private func rateUs() {
        if let url = URL(string: "https://itunes.apple.com/in/app/facebook/id284882215?mt=8"),
           //if let url = URL(string: "https://www.google.co.in/"),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("App Store Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
    
    private func composerEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["Iscra.app@gmail.com"])
        composeVC.setSubject("Message Subject")
        composeVC.setMessageBody("Message content.", isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    private func navigaetToWebView(_ viewType: WebPage) {
        self.viewModel.webPage = viewType
        self.router?.push(scene: .webViewController)
    }
}

//MARK: Mail Composer Delegate
extension MyAccountViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: Image Picker Delegate
extension MyAccountViewController: ImagePickerDelegate{
    func fetchedImage(img: UIImage) {
        imgProfile.image = img
        viewModel.selectedImage = img
        print("fetchImage===>\(img)")
        viewModel.onAction(action: .inputComplete(.updateProfile), for: .updateProfile)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: API Callback
extension MyAccountViewController: OnboardingViewRepresentable {
    func onAction(_ action: OnboardingAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case .updateProfile:
            self.imgProfile.setImageFromURL(UserStore.userImage ?? "", with: AppConstant.UserPlaceHolderImage)
        case .logout:
            self.router?.push(scene: .welcome)
        default:
            break
        }
    }
}

