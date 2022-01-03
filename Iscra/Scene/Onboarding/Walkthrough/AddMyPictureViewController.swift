//
//  AddMyPictureViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 20/10/21.
//

import UIKit

class AddMyPictureViewController: UIViewController {
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnAddPhoto: UIButton!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewNavigation:NavigationBarView!
    
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension AddMyPictureViewController {
    private func setup() {
        self.setNavigatonBar()
        self.manageButtonTitle()
        [btnAddPhoto, btnNext].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func setNavigatonBar() {
        self.viewNavigation.lblTitle.text =  "Add Profile Picture"
        self.viewNavigation.delegateBarAction = self
    }
}

// MARK: Button Action
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
        self.openCameraPhoto()
    }
    
    private func nextButtonAction() {
        self.router?.push(scene: .signup)
    }
    
    private func manageButtonTitle() {
        if (OnboadingUtils.shared.userImage == nil){
            self.btnNext.setTitle("Skip", for: .normal)
        } else {
            self.btnNext.setTitle("Next", for: .normal)
        }
    }
    
    private  func openCameraPhoto() {
        CameraHandler.shared.showActionSheetPrivate(vc: self, isEditable: true, isAlreadyExist: false)
        CameraHandler.shared.camera(allowsEditing: true)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.imgUser.image = image
            OnboadingUtils.shared.userImage = image
            self.manageButtonTitle()
        }
    }
}

// MARK: NavigationBarView Delegate
extension AddMyPictureViewController: NavigationBarViewDelegate {
    func navigationBackAction()  {
        router?.dismiss(controller: .addMyPicture)
    }
}
