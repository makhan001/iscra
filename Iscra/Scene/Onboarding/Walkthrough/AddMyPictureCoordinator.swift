//
//  AddMyPictureCoordinator.swift
//  Iscra
//
//  Created by mac on 14/12/21.
//

import Foundation

final class AddMyPictureCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    private var signup: SignupCoordinator!
    let controller: AddMyPictureViewController = AddMyPictureViewController.from(from: .onboarding, with: .addMyPicture)

    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
        
    private func onStart() {
        controller.router = self
    }

    private func startSignup() {
        signup = SignupCoordinator(router: Router())
        add(signup)
        signup.delegate = self
        signup.start()
        self.router.present(signup, animated: true)
    }
}

extension AddMyPictureCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .signup: startSignup()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        delegate?.dismiss(coordinator: self)
    }
}

extension AddMyPictureCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}


