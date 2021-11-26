//
//  MyAccountViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit

class MyAccountViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // MARK:-Outlets and variables
    @IBOutlet weak var tableView: MyAccountTableView!
    @IBOutlet weak var btnGetSubscription: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    
    weak var router: NextSceneDismisser?
    private var imagePicker = UIImagePickerController()
    private let viewModel: MyAccountViewModel = MyAccountViewModel(provider: OnboardingServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("UserStore.userDetail?.email is \(UserStore.userName)")
        
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
//        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "GetSubcriptionViewController") as! GetSubcriptionViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let getSubcription: GetSubcriptionViewController = GetSubcriptionViewController.from(from: .onboarding, with: .getSubcription)
        self.navigationController?.pushViewController(getSubcription, animated: true)
    }
    
    private func LogoutAction() {
        logOutAction()
    }
    
    // MARK:- AlertView
    func alertView(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        alert.view.layer.cornerRadius = 15
        
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = .white
        
        let image = UIImage(named: "ic-popupClosebutton-image")
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame =  CGRect(x: 150, y: 18, width: 60, height: 30)
        alert.view.addSubview(imageView)
        
        let imageFirst = UIImage(named: "ic-changeProfilePhoto-image")
        let imageViewFirst = UIImageView()
        imageViewFirst.image = imageFirst
        alert.view.addSubview(imageViewFirst)
        imageViewFirst.frame = CGRect(x: 25, y: 75, width: 24, height: 24)
        
        let imageSecond = UIImage(named: "ic-gallery-image")
        let imageViewSecond = UIImageView()
        imageViewSecond.image = imageSecond
        imageViewSecond.frame =  CGRect(x: 25, y: 125, width: 24, height: 24)
        alert.view.addSubview(imageViewSecond)
        let back = UIAlertAction(title: "", style: .default)   {
            action in
            
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) {
            action in
            self.openGallary()
        }
        let camera = UIAlertAction(title: "Camera", style: .default)   {
            action in
            self.openCamera()
        }
        alert.addAction(back)
        alert.addAction(camera)
        alert.addAction(gallery)
        DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
    }
    //MARK: - ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imgProfile.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func logOutAction()  {
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
            self.alertView()
            print("changePhoto")
        case .addYourOwnMemoji:
            self.AddMemojiAction()
        case .changePassword:
            self.ChangePasswordAction()
        case .shareWithFriends:
            print(performAction)
        case .rateUs:
            print(performAction)
        case .contactDeveloper:
            print(performAction)
        case .everyDay:
            print(performAction)
        case .reminder:
            print(performAction)
        case .changeColorTheme:
            print(performAction)
        }
    }
    private func AddMemojiAction() {
//        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "LearnHowToAddMemojiViewController") as! LearnHowToAddMemojiViewController
//        navigationController?.pushViewController(vc, animated: true)
        
        let learnHowToAddMemoji: LearnHowToAddMemojiViewController = LearnHowToAddMemojiViewController.from(from: .onboarding, with: .learnHowToAddMemoji)
        self.navigationController?.pushViewController(learnHowToAddMemoji, animated: true)

    }
    
    private func ChangePasswordAction() {
//        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
//        navigationController?.pushViewController(vc, animated: true)
        
        let changePassword: ChangePasswordViewController = ChangePasswordViewController.from(from: .onboarding, with: .changePassword)
        self.navigationController?.pushViewController(changePassword, animated: true)
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

