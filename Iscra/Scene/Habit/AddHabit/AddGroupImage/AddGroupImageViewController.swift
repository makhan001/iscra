//
//  AddGroupImageViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 11/11/21.
//

import UIKit

class AddGroupImageViewController: UIViewController {
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgGroup: UIImageView!
    @IBOutlet weak var btnImagePicker: UIButton!
    var habitType : HabitType = .good
    private let viewModel = HabitNameViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUp()
    }
}

extension AddGroupImageViewController {
    func SetUp() {
        viewModel.view = self
        [btnSkip, btnNext, btnImagePicker].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }}

// MARK:- Button Action
extension AddGroupImageViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnSkip:
            self.skipClick()
        case btnNext:
            self.nextClick()
        case btnImagePicker:
            self.imageClick()
        default:
            break
        }
    }
    
    private func nextClick() {
//        let storyboard = UIStoryboard(name: "Habit", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
//        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        vc.habitType = habitType
//        vc.delegateInvite = self
//        self.present(vc, animated: true, completion: nil)
        
//        let inviteFriend: InviteFriendViewController = InviteFriendViewController.from(from: .habit, with: .inviteFriend)
//        inviteFriend.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        inviteFriend.habitType = habitType
//        inviteFriend.delegateInvite = self
//        self.present(inviteFriend, animated: true, completion: nil)
        self.viewModel.onAction(action: .setGroupImage(.setGroupImage), for: .setGroupImage)
    }
    
    private func skipClick() {
        let inviteFriend: InviteFriendViewController = InviteFriendViewController.from(from: .habit, with: .inviteFriend)
        inviteFriend.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        inviteFriend.habitType = habitType
        inviteFriend.delegateInvite = self
        self.present(inviteFriend, animated: true, completion: nil)
    }
    
    private func imageClick() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension AddGroupImageViewController : InviteNavigation {
    func navigate(inviteType: inviteType) {
        if inviteType == .mayBeLatter{
            guard let viewControllers = navigationController?.viewControllers else { return }
            for vc in viewControllers {
                if vc is LandingTabBarController {
                    navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }else{
            
        }
    }
}

extension AddGroupImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgGroup.image  = tempImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Callbacks
extension AddGroupImageViewController: HabitViewRepresentable {
   
    func onAction(_ action: HabitAction) {
        switch action {
        case let .requireFields(msg), let .errorMessage(msg):
            self.showToast(message: msg)
        case .callApi(true):
            self.viewModel.apiForCreateHabit()
            break
        default:
            break
        }
    }
    
}
