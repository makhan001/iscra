//
//  SignupCoordinator.swift
//  Iscra
//
//  Created by mac on 25/11/21.
//

import Foundation

final class SignupCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: SignupViewController = SignupViewController.from(from: .onboarding, with: .signup)
    let verification: VerificationViewController = VerificationViewController.from(from: .onboarding, with: .verification)
    
    private var landing: LandingCoordinator!
    private var welcome: OnboardingCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        verification.router = self
        verification.delegate = controller
    }
    
    private func startVerification() {
        router.present(verification, animated: true)
    }
    
    private func startLanding() {
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
    
    private func startWelcome() {
        let router = Router()
        welcome = OnboardingCoordinator(router: router)
        add(welcome)
        welcome.delegate = self
        welcome.start()
        self.router.present(welcome, animated: true)
    }
}

extension SignupCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .welcome: startWelcome()
        case .verification: startVerification()
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

extension SignupCoordinator: CoordinatorDimisser {
    
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

