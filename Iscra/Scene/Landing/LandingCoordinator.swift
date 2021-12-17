//
//  LandingCoordinator.swift
//  Iscra
//
//  Created by m@k on 19/11/21.
//


import Foundation

final class LandingCoordinator: Coordinator<Scenes> {
    
    weak var delegate: CoordinatorDimisser?
    let controller: LandingTabBarController = LandingTabBarController.from(from: .landing, with: .landing)
    let selectHabitPopUp: SelectHabitPopUpViewController = SelectHabitPopUpViewController.from(from: .landing, with: .selectHabitPopUp)
    let communityDetail: CommunityDetailViewController = CommunityDetailViewController.from(from: .landing, with: .communityDetail)

    private var login: LoginCoordinator!
    private var welcome: OnboardingCoordinator!
    private var habitName: HabitNameCoordinator!
    private var communitySearch: CommunitySearchCoordinator!
    private var habitCalender: HabitCalenderCoordinator!
    private var myAccount: MyAccountCoordinator!
    private var groupHabitCalender: GroupHabitCalenderCoordinator!
    
    override func start() {
        super.start()
        router.setRootModule(controller, hideBar: true)
        self.onStart()
    }
    
    private func onStart() {
        controller.router = self
        selectHabitPopUp.router = self
        selectHabitPopUp.delegate = self
        communityDetail.router = self
    }
    
    private func startLogin() {
        let router = Router()
        login = LoginCoordinator(router: router)
        add(login)
        login.delegate = self
        login.start()
        self.router.present(login, animated: true)
    }
    
    private func startWalkthrough() {
        //        let router = Router()
        //        walkthrough = WalkthroughCoordinator(router: router)
        //        add(walkthrough)
        //        walkthrough.delegate = self
        //        walkthrough.start()
        //        self.router.present(walkthrough, animated: true)
    }
    
    private func startWelcome() {
        let router = Router()
        welcome = OnboardingCoordinator(router: router)
        add(welcome)
        welcome.delegate = self
        welcome.start()
        self.router.present(welcome, animated: true)
    }
    
    private func startMyAccount() {
        myAccount = MyAccountCoordinator(router: Router())
        add(myAccount)
        myAccount.delegate = self
        myAccount.start()
        self.router.present(myAccount, animated: true)
    }
    
    private func startCommunitySearch() {
        communitySearch = CommunitySearchCoordinator(router: Router())
        add(communitySearch)
        communitySearch.delegate = self
        communitySearch.start()
        self.router.present(communitySearch, animated: true)
    }
    
    private func startLanding() {
        //        landing = LandingCoordinator(router: Router())
        //        add(landing)
        //        landing.delegate = self
        //        landing.start(imageUrl: controller.viewModel.socialLoginImageURL)
        //        self.router.present(landing, animated: true)
    }
    
    private func startHome() {
        //        home = HomeCoordinator(router: Router())
        //        add(home)
        //        home.delegate = self
        //        home.start()
        //        self.router.present(home, animated: true)
    }
    
    private func startHabitCalender() {
        habitCalender = HabitCalenderCoordinator(router: Router())
        add(habitCalender)
        habitCalender.delegate = self
        habitCalender.start(habitId: controller.home.viewModel.habitId)
        self.router.present(habitCalender, animated: true)
    }
    
    private func startGroupHabitCalender() {
        groupHabitCalender = GroupHabitCalenderCoordinator(router: Router())
        add(groupHabitCalender)
        groupHabitCalender.delegate = self
        groupHabitCalender.start(habitId: controller.home.viewModel.habitId)
        self.router.present(groupHabitCalender, animated: true)
    }
    
    private func startHabitTypeView() {
        self.router.present(selectHabitPopUp, animated: true)
    }
    
    private func startHabitName(type: HabitType) {
        habitName = HabitNameCoordinator(router: Router())
        add(habitName)
        habitName.delegate = self
        habitName.start(type: type)
        self.router.present(habitName, animated: true)
    }
    
    private func startCommunityDetail() {
        router.present(communityDetail, animated: true)
    }
}

extension LandingCoordinator: NextSceneDismisser {
    
    func push(scene: Scenes) {
        switch scene {
       // case .home: startHome()
        case .login: startLogin()
        case .welcome: startWelcome()
       // case .landing: startLanding()
      //  case .communitySearch: startCommunitySearch()
        case .communityDetail: startCommunityDetail()
        case .myAccount: startMyAccount()
        case .walkthrough: startWalkthrough()
        case .habitCalender: startHabitCalender()
        case .selectHabitPopUp: startHabitTypeView()
        case .groupHabitFriends: startGroupHabitCalender()
        default: break
        }
    }
    
    func dismiss(controller: Scenes) {
        router.dismissModule(animated: true, completion: nil)
    }
}

extension LandingCoordinator: CoordinatorDimisser {
    
    func dismiss(coordinator: Coordinator<Scenes>) {
        remove(child: coordinator)
        router.dismissModule(animated: true, completion: nil)
    }
}

extension LandingCoordinator: SelectHabitPopUpDelegate {
    func addHabit(type: HabitType) {
        self.startHabitName(type: type)
    }
}
