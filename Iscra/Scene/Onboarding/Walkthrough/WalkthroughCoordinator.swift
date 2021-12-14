//
//  WalkthroughCoordinator.swift
//  Iscra
//
//  Created by mac on 14/12/21.
//

import Foundation
final class WalkthroughCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    private var signup: SignupCoordinator!
    private var addMemoji: AddMemojiCoordinator!
    private var addMyPicture: AddMyPictureCoordinator!
    let controller: WalkthroughViewController = WalkthroughViewController.from(from: .onboarding, with: .walkthrough)

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
    
    private func startAddMyPicture() {
        addMyPicture = AddMyPictureCoordinator(router: Router())
        add(addMyPicture)
        addMyPicture.delegate = self
        addMyPicture.start()
        self.router.present(addMyPicture, animated: true)
    }
 
    private func startAddMemoji() {
        addMemoji = AddMemojiCoordinator(router: Router())
        add(addMemoji)
        addMemoji.delegate = self
        addMemoji.start()
        self.router.present(addMemoji, animated: true)
    }
}

extension WalkthroughCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .signup: startSignup()
        case .addMyPicture: startAddMyPicture()
        case.learnHowToAddMemoji: startAddMemoji()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        delegate?.dismiss(coordinator: self)
    }
}

extension WalkthroughCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

