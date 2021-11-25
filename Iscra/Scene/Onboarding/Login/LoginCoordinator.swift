//
//  LoginCoordinator.swift
//  Iscra
//
//  Created by m@k on 16/11/21.
//

import Foundation


final class LoginCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: LoginViewController = LoginViewController.from(from: .onboarding, with: .login)
    let verification: VerificationViewController = VerificationViewController.from(from: .onboarding, with: .verification)
    
    var welcome: Bool!
//    var signup: SignupCoordinator!
    var landing: LandingCoordinator!

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
    }
    
    private func startSignup() {
//        let router = Router()
//        signup = SignupCoordinator(router: router)
//        add(signup)
//        signup.delegate = self
//        signup.start()
//        self.router.present(signup, animated: true)
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
}

extension LoginCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
        case .signup: startSignup()
        case .landing: startLanding()
        case .verification: startVerification()
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
