//
//  HabitNameCoordinator.swift
//  Iscra
//
//  Created by m@k on 19/11/21.
//


import Foundation

final class HabitNameCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: HabitNameViewController = HabitNameViewController.from(from: .habit, with: .habitName)
    let selectHabitPopUp: SelectHabitPopUpViewController = SelectHabitPopUpViewController.from(from: .landing, with: .selectHabitPopUp)

    private var setTheme: SetThemeCoordinator!
    private var landing: LandingCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    func start(type: HabitType) {
        super.start()
        router.setRootModule(controller, hideBar: true)
        controller.viewModel.habitType = type
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        selectHabitPopUp.router = self
    }
        
    private func startSetTheme() {
        setTheme = SetThemeCoordinator(router: Router())
        add(setTheme)
        setTheme.delegate = self
        setTheme.start()
        self.router.present(setTheme, animated: true)
    }
    
    private func startLanding() {
        landing = LandingCoordinator(router: Router())
        add(landing)
        landing.delegate = self
        landing.start()
        self.router.present(landing, animated: true)
    }
}

extension HabitNameCoordinator: NextSceneDismisser {
    func push(scene: Scenes) {
        switch scene {
        case .setTheme: startSetTheme()
        case .landing: startLanding()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        delegate?.dismiss(coordinator: self)
    }
}

extension HabitNameCoordinator: CoordinatorDimisser {
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

