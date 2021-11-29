//
//  HabitCalenderCoordinator.swift
//  Iscra
//
//  Created by mac on 27/11/21.
//

import Foundation

final class HabitCalenderCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: HabitCalenderViewController = HabitCalenderViewController.from(from: .landing, with: .habitCalender)
    let habitCalender: HomeViewController = HomeViewController.from(from: .landing, with: .home)

  //  private var landing: LandingCoordinator!

    override func start() {
        super.start()
        router.setRootModule(habitCalender, hideBar: true)
        self.onStart()
    }

    private func onStart() {
        controller.router = self
    }

    private func startHabitCalender() {
        router.present(habitCalender, animated: true)
    }

//    private func startLanding() {
//        landing = LandingCoordinator(router: Router())
//        add(landing)
//        landing.delegate = self
//        landing.start()
//        self.router.present(landing, animated: true)
//    }

}

extension HabitCalenderCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
       // case .landing: startLanding()
        case .habitCalender: startHabitCalender()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension HabitCalenderCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

