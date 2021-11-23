//
//  OnboardingCoordinator.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 05/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation

final class OnboardingCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: WelcomeViewController = WelcomeViewController.from(from: .onboarding, with: .welcome)
    let walktrough: WalkthroughViewController = WalkthroughViewController.from(from: .onboarding, with: .walkthrough)

    private var login: LoginCoordinator!
    private var landing: LandingCoordinator!
    private var onboarding: OnboardingCoordinator!
        
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        UserStore.save(token: nil)
    }

    
    private func startLogin() {
        let router = Router()
        login = LoginCoordinator(router: router)
        add(login)
        login.delegate = self
        login.start()
        self.router.present(login, animated: true)
    }
    
    private func startWalkthrough() {
        let router = Router()
        onboarding = OnboardingCoordinator(router: router)
        add(onboarding)
        onboarding.delegate = self
        onboarding.start()
        self.router.present(onboarding, animated: true)
    }
    
    private func startVerification() {
        let router = Router()
        onboarding = OnboardingCoordinator(router: router)
        add(onboarding)
        onboarding.delegate = self
        onboarding.start()
        self.router.present(onboarding, animated: true)
    }
    
    private func startLanding() {
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
}

extension OnboardingCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
        case .login: startLogin()
        case .landingTab: startLanding()
        case .walkthrough: startWalkthrough()
        case .verification: startVerification()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {}
}

extension OnboardingCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

