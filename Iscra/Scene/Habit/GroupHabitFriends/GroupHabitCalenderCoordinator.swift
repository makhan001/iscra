//
//  GroupHabitCalenderCoordinator.swift
//  Iscra
//
//  Created by mac on 10/12/21.
//

import Foundation

final class GroupHabitCalenderCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: GroupHabitFriendsViewController = GroupHabitFriendsViewController.from(from: .landing, with: .groupHabitFriends)
    let shareHabit: ShareHabitViewController = ShareHabitViewController.from(from: .landing, with: .shareHabit)

    private var landing: LandingCoordinator!
    private var editHabit: EditHabitCoordinator!
    private var habitCalender: HabitCalenderCoordinator!

    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }

    func start(habitId: Int) {
        super.start()
        router.setRootModule(controller, hideBar: true)
        print("habitId is GroupHabitCalenderCoordinator  \(habitId)")
        controller.viewModel.habitId = habitId
        self.onStart()
    }

    private func onStart() {
        controller.router = self
        shareHabit.router = self
    }

    private func startGroupHabitCalender() {
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
    
    private func startHabitCalender() {
        habitCalender = HabitCalenderCoordinator(router: Router())
        add(habitCalender)
        habitCalender.delegate = self
        habitCalender.start(habitId: controller.viewModel.habitId, userId: controller.viewModel.userId)
        print("GroupHabitCalenderCoordinator controller.viewModel.habitId is \(controller.viewModel.habitId)")
        self.router.present(habitCalender, animated: true)
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
    
    private func startShareHabit() {
        shareHabit.viewModel.habitId = controller.viewModel.habitId
        shareHabit.viewModel.sourceScreen = .groupHabit
        router.present(shareHabit, animated: true)
    }
}

extension GroupHabitCalenderCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .editHabit: startEditHabit()
        case .shareHabit: startShareHabit()
        case .habitCalender: startHabitCalender()
        case .groupHabitFriends: startGroupHabitCalender()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension GroupHabitCalenderCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

