//
//  SetThemeCoordinator.swift
//  Iscra
//
//  Created by mac on 15/12/21.
//

import Foundation

final class SetThemeCoordinator: Coordinator<Scenes> {

    weak var delegate: CoordinatorDimisser?
    private var reminder: ReminderCoordinator!
    let controller: SetThemeViewController = SetThemeViewController.from(from: .habit, with: .setTheme)
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
    }

    private func startReminder() {
        reminder = ReminderCoordinator(router: Router())
        add(reminder)
        reminder.delegate = self
        reminder.start(selectedColorTheme: controller.selectedColorTheme)
        self.router.present(reminder, animated: true)
    }
}

extension SetThemeCoordinator: NextSceneDismisser {

    func push(scene: Scenes) {
        switch scene {
        case .reminder: startReminder()
        default: break
        }
    }

    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension SetThemeCoordinator: CoordinatorDimisser {

    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}
