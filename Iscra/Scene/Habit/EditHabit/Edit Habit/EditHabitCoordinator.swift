//
//  EditHabitCoordinator.swift
//  Iscra
//
//  Created by mac on 13/12/21.
//

import Foundation

final class EditHabitCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: EditHabitViewController = EditHabitViewController.from(from: .habit, with: .editHabit)

    private var landing: LandingCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    func start(objHabitDetail: HabitDetails) {
        super.start()
        router.setRootModule(controller, hideBar: true)
        controller.objHabitDetail = objHabitDetail
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
    
}

extension EditHabitCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .habitCalender: startHabitCalender()
        case .landing: startLanding()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension EditHabitCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
