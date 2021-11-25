//
//  RootCoordinator.swift
//  Iscra
//
//  Created by m@k on 16/11/21.
//

import UIKit
import Foundation

class RootCoordinator {
    private var window: UIWindow?
    private var landingCoordinator: LandingCoordinator
    private var onboardingCoordinator: OnboardingCoordinator
    
    init() {
        landingCoordinator = LandingCoordinator(router: Router())
        onboardingCoordinator = OnboardingCoordinator(router:Router())
    }
    
    func start(window:UIWindow) {
        self.window = window
       // UserDefaults.standard.removeObject(forKey: "token")// deepak
        if UserStore.token != nil {
            landingCoordinator.start()
            window.rootViewController = landingCoordinator.toPresentable()
        } else {
            onboardingCoordinator.start()
            window.rootViewController = onboardingCoordinator.toPresentable()
        }
        window.makeKeyAndVisible()
    }
}
