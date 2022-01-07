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
    private var subscriptionCoordinator: SubscriptionCoordinator
    
    init() {
        landingCoordinator = LandingCoordinator(router: Router())
        onboardingCoordinator = OnboardingCoordinator(router:Router())
        subscriptionCoordinator =  SubscriptionCoordinator(router:Router())
    }
    
    func start(window:UIWindow) {
        self.window = window
        if UserStore.token != nil && UserStore.isVerify  == true {
            if UserStore.userCreateDate != 0, UserStore.userCreateDate.daysDifference > 21 {
                subscriptionCoordinator.start(sourceScreen: .login)
                window.rootViewController = subscriptionCoordinator.toPresentable()
            } else {
                landingCoordinator.start()
                window.rootViewController = landingCoordinator.toPresentable()
            }
        } else {
            onboardingCoordinator.start()
            window.rootViewController = onboardingCoordinator.toPresentable()
        }
        window.makeKeyAndVisible()
    }
}

