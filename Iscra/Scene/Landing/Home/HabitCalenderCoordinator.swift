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

    private var landing: LandingCoordinator!
    private var editHabit: EditHabitCoordinator!

    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    func start(habitId: Int , userId: String) {
        super.start()
        print("habitId is HabitCalenderCoordinator  \(habitId)")
        controller.viewModel.habitId = habitId
        controller.viewModel.userId = userId
      //  controller.habitId = habitId
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
    
    private func startEditHabit() {
        editHabit = EditHabitCoordinator(router: Router())
        add(editHabit)
        editHabit.delegate = self
        if let objHabitDetail = controller.viewModel.objHabitDetail {
            editHabit.start(objHabitDetail: objHabitDetail)
        }
        self.router.present(editHabit, animated: true)
    }
}

extension HabitCalenderCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .habitCalender: startHabitCalender()
        case .landing: startLanding()
        case .editHabit: startEditHabit()
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
