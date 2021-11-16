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
    private var loginCoordinator: LoginCoordinator
    private var onboardingCoordinator: OnboardingCoordinator
    
    init() {
        loginCoordinator = LoginCoordinator(router: Router())
        onboardingCoordinator = OnboardingCoordinator(router:Router())
    }
    
    func start(window:UIWindow) {
        self.window = window
        if UserStore.token != nil {
            loginCoordinator.start()
            window.rootViewController = loginCoordinator.toPresentable()
        } else {
            onboardingCoordinator.start()
            window.rootViewController = onboardingCoordinator.toPresentable()
        }
        window.makeKeyAndVisible()
    }
}
