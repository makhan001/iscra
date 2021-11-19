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
//        forgot.router = self
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
}

extension LoginCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
//        case .forgot: router.present(forgot, animated: true)
        case .signup: startSignup()
        case .landingTab: startLanding()
        default: break
        }
        
    }
    
    func dismiss(controller: Scenes) {
        if controller == .forgot {
            router.dismissModule(animated: true, completion: nil)
        } else {
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

