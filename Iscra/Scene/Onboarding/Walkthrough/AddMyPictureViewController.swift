//
//  AddMyPictureViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 20/10/21.
//

import UIKit

class AddMyPictureViewController: UIViewController {
  // MARK:-Outlets and variables
  @IBOutlet weak var btnAddPhoto: UIButton!
  @IBOutlet weak var btnNext: UIButton!
  @IBOutlet weak var imgUser: UIImageView!
  @IBOutlet weak var viewNavigation:NavigationBarView!
  weak var router: NextSceneDismisser?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
  }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        self.viewNavigation.lblTitle.text =  "Add Profile Picture"
        self.viewNavigation.delegateBarAction = self
    }
}

// MARK: Instance Methods
extension AddMyPictureViewController: navigationBarAction {
    
    
  private func setup() {
  //  self.navigationItem.title = AppConstant.nav_addProfilePicture//"Add Profile Picture"
    [btnAddPhoto, btnNext].forEach {
      $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    self.manageButtonTitle()
  }
    func ActionType()  {
      //  router?.dismiss(controller: .addMyPicture)
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK:- Button Action
extension AddMyPictureViewController {
  @objc func buttonPressed(_ sender: UIButton) {
    switch sender {
    case btnAddPhoto:
      self.addPhotoButtonAction()
    case btnNext:
      self.nextButtonAction()
    default:
      break
    }
  }
  private func addPhotoButtonAction() {
    print("addPhotoButtonAction")
    openCameraPhoto()
  }
  private func nextButtonAction() {
   // navigationController?.popViewController(animated: true)
    let signUp: SignupViewController = SignupViewController.from(from: .onboarding, with: .signup)
    self.navigationController?.pushViewController(signUp, animated: true)
  }
    func manageButtonTitle(){
       if (OnboadingUtils.shared.userImage == nil){
           btnNext.setTitle("Skip", for: .normal)
        }
       else {
            btnNext.setTitle("Next", for: .normal)
        }
    }
    func openCameraPhoto() {
            CameraHandler.shared.showActionSheetPrivate(vc: self, isEditable: false, isAlreadyExist: false)
            CameraHandler.shared.camera(allowsEditing: true)
            CameraHandler.shared.imagePickedBlock = { (image) in
            /* get your image here */
                self.imgUser.image = image
                OnboadingUtils.shared.userImage = image
                self.manageButtonTitle()
            }
        }
}
