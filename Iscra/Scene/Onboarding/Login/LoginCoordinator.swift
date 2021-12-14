//
//  LoginCoordinator.swift
//  Iscra
//
//  Created by m@k on 16/11/21.
//

import Foundation

final class LoginCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    var landing: LandingCoordinator!
    let controller: LoginViewController = LoginViewController.from(from: .onboarding, with: .login)
    let forgot: ForgotPasswordViewController = ForgotPasswordViewController.from(from: .onboarding, with: .forgot)
    let verification: VerificationViewController = VerificationViewController.from(from: .onboarding, with: .verification)

    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    func start(email: String, password:String) {
        super.start()
//        controller.viewModel.email = email
//        controller.viewModel.password = password
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        verification.router = self
        forgot.router = self
    }
    
    
    private func startLanding() {
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
    
    private func startVerification() {
        verification.delegate = controller
        router.present(verification, animated: true)
    }
    
    private func startForgotPassword() {
        self.router.present(forgot, animated: true)
    }
}

extension LoginCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .verification: startVerification()
        case .forgot: startForgotPassword()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        switch  controller {
        case .forgot:
            router.dismissModule(animated: true, completion: nil)
        case .verification:
            router.dismissModule(animated: true) {
                self.startLanding()
            }
        default:
            delegate?.dismiss(coordinator: self)
        }
    }
}

extension LoginCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

