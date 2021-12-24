//
//  CommunitySearchCoordinator.swift
//  Iscra
//
//  Created by mac on 15/12/21.
//

import Foundation

final class CommunitySearchCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: CommunitySearchViewController = CommunitySearchViewController.from(from: .landing, with: .communitySearch)
    
    private var landing: LandingCoordinator!
    private var habitName: HabitNameCoordinator!

    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
    }

    private func startHabitCalender() {
        router.present(controller, animated: true)
    }
       
    private func startLanding() {
        router.dismissModule(animated: false, completion: nil)
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
    
    private func startHabitName() {
        habitName = HabitNameCoordinator(router: Router())
        add(habitName)
        habitName.delegate = self
        habitName.start(type: .group)
        self.router.present(habitName, animated: true)
    }
}

extension CommunitySearchCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .habitCalender: startHabitCalender()
        case .habitName: startHabitName()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension CommunitySearchCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

