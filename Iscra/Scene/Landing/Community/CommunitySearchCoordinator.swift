//
//  CommunitySearchCoordinator.swift
//  Iscra
//
//  Created by mac on 15/12/21.
//

import Foundation
import CoreImage

final class CommunitySearchCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    let controller: CommunitySearchViewController = CommunitySearchViewController.from(from: .landing, with: .communitySearch)
    
    private var landing: LandingCoordinator!
    private var habitName: HabitNameCoordinator!
    private var communityDetail: CommunityDetailCoordinator!
    private var groupHabitCalender: GroupHabitCalenderCoordinator!

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
    
    private func startGroupHabitCalender() {
        groupHabitCalender = GroupHabitCalenderCoordinator(router: Router())
        add(groupHabitCalender)
        groupHabitCalender.delegate = self
        groupHabitCalender.start(habitId: controller.viewModel.habitId)
        self.router.present(groupHabitCalender, animated: true)
    }
    
    private func startCommunityDetail() {
        communityDetail = CommunityDetailCoordinator(router: Router())
        add(communityDetail)
        communityDetail.delegate = self
        print("controller.viewModel.habitId is \(controller.viewModel.habitId)")
        communityDetail.start(habitId: controller.viewModel.habitId)
        self.router.present(communityDetail, animated: true)
    }
}

extension CommunitySearchCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .landing: startLanding()
        case .habitName: startHabitName()
        case .habitCalender: startHabitCalender()
        case .communityDetail: startCommunityDetail()
        case .groupHabitFriends: startGroupHabitCalender()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: false, completion: nil)
    }
}

extension CommunitySearchCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

