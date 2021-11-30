//
//  MyAccountCoordinator.swift
//  Iscra
//
//  Created by mac on 29/11/21.
//

import Foundation

final class MyAccountCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: MyAccountViewController = MyAccountViewController.from(from: .landing, with: .myAccount)
    let changePassword: ChangePasswordViewController = ChangePasswordViewController.from(from: .onboarding, with: .changePassword)
    
    private var landing: LandingCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        changePassword.router = self
    }
    
//    private func startVerification() {
//        router.present(changePassword, animated: true)
//    }
    
    private func startChangePassword() {
        
    }
    
    private func startLanding() {
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        //landing.start(imageUrl: controller.viewModel.socialLoginImageURL)
        self.router.present(landing, animated: true)
    }
}

extension MyAccountCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .changePassword: startChangePassword()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        switch  controller {
        case .verification:
            router.dismissModule(animated: false) {
                self.startLanding()
            }
        default:
            delegate?.dismiss(coordinator: self)
        }
    }
}

extension MyAccountCoordinator: CoordinatorDimisser {
    
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

