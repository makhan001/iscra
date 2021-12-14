//
//  MyAccountViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import MessageUI


class MyAccountViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK:-Outlets and variables
    @IBOutlet weak var btnLogout: UIButton!
   // @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: IscraCustomLabel!
    @IBOutlet weak var btnGetSubscription: UIButton!
    @IBOutlet weak var tableView: MyAccountTableView!
    @IBOutlet weak var viewNavigation: NavigationBarView!

    weak var router: NextSceneDismisser?
    private var imagePicker = UIImagePickerController()
    private let viewModel: MyAccountViewModel = MyAccountViewModel(provider: OnboardingServiceProvider())
    var delegateBarAction:navigationBarAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblName.text = UserStore.userName?.capitalized
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: Instance Methods
extension MyAccountViewController {
    private func setup() {
        viewModel.view = self
        [btnGetSubscription,btnLogout].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        tableView.configure()
        tableView.delegateNavigate = self
        self.viewNavigation.navType = .myProfie
        self.viewNavigation.commonInit()
        self.viewNavigation.lblTitle.text =  "My profile"
        self.viewNavigation.delegateBarAction = self
        if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
      }
    
}

// MARK: Navigation Methods
extension MyAccountViewController: navigationBarAction {
    func ActionType() {}
    func RightButtonAction() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK:- Button Action
extension MyAccountViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnGetSubscription:
            self.GetSubscriptionAction()
        case btnLogout:
            self.LogoutAction()
        default:
            break
        }
    }
    private func GetSubscriptionAction() {
        let getSubcription: GetSubcriptionViewController = GetSubcriptionViewController.from(from: .onboarding, with: .getSubcription)
        self.navigationController?.pushViewController(getSubcription, animated: true)
    }
    private func LogoutAction() {
        logOutAction()
    }
    private func logOutAction()  {

        let alertController = UIAlertController(title: "Logout", message: "Are you sure? logout from Iscra.", preferredStyle: .alert)
        let Logoutaction = UIAlertAction(title: "Logout", style: .default) { (action:UIAlertAction!) in
            print("Delete button tapped");
            self.viewModel.logout()
        }
        
        Logoutaction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
        alertController.addAction(Logoutaction)
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
            self.AddMemojiAction()
        case .changePassword:
            self.ChangePasswordAction()
        case .shareWithFriends:
          self.showActivityViewController(url: URL(string: "https://www.apple.com")!, text: "Iscra", image: UIImage(named: "ic-app-logo")!)
        case .rateUs:
            self.rateUs()
        case .contactDeveloper:
             self.composerEmail()
        case .termsAndCondition:
             self.termsAndCondition()
        case .privacyPolicy:
             self.privacyPolicy()
        case .aboutUs:
             self.aboutUs()
        case .everyDay:
            print(performAction)
        case .reminder:
           print(performAction)
        case .changeColorTheme:
            print(performAction)
        }
    }
    private func AddMemojiAction() {
        let learnHowToAddMemoji: AddMemojiViewController = AddMemojiViewController.from(from: .onboarding, with: .learnHowToAddMemoji)
        self.navigationController?.pushViewController(learnHowToAddMemoji, animated: true)
    }
    private func ChangePasswordAction() {
       let changePassword: ChangePasswordViewController = ChangePasswordViewController.from(from: .onboarding, with: .changePassword)
       self.navigationController?.pushViewController(changePassword, animated: true)
       // self.router?.push(scene: .changePassword)
    }
    private func changeProfilePhoto(){
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyAccountPopupViewController") as! MyAccountPopupViewController
        vc.delegate = self
        self.navigationController?.present(vc, animated: false, completion: nil)

    }
    private func showActivityViewController(url:URL,  text: String,  image: UIImage) {
        let items = [url, text, image] as [Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
      }
    private func rateUs(){
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
    private func composerEmail(){
        let composeVC = MFMailComposeViewController()
           composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
           composeVC.setToRecipients(["Iscra.app@gmail.com"])
           composeVC.setSubject("Message Subject")
           composeVC.setMessageBody("Message content.", isHTML: false)
          navigationController?.pushViewController(composeVC, animated: true)
    }
    private func termsAndCondition(){
        print("termsAndCondition")
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.webPage = .termsAndConditions
       navigationController?.pushViewController(vc, animated: true)
    
    }
    private func privacyPolicy(){
        print("privacyPolicy")
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.webPage = .privacyPolicy
       navigationController?.pushViewController(vc, animated: true)
    }
    private func aboutUs(){
        print("aboutUs")
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.webPage = .aboutUs
       navigationController?.pushViewController(vc, animated: true)
    }
    
}
//Mark:- Mail Composer Delegate
extension MyAccountViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
       }
}

//Mark:- Image picker Delegate
extension MyAccountViewController: ImagePickerDelegate{
    func fetchedImage(img: UIImage) {
        imgProfile.image = img
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
        case .logout:
            self.router?.push(scene: .welcome)
        default:
            break
        }
    }
}

