//
//  CommunityViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//
import UIKit

class CommunityViewController: UIViewController {

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblNoGroupsFound: UILabel!
    @IBOutlet weak var btnInviteFriends: UIButton!
    @IBOutlet weak var lblNoInvitationFound: UILabel!
    @IBOutlet weak var collectionMyGroups: MyCommunityCollectionView!
    @IBOutlet weak var collectionNewGroupHabit: NewCommunityCollectionView!
    private let inviteFriendViewModel: InviteFriendViewModel = InviteFriendViewModel(provider: HabitServiceProvider())
    private let viewModel: CommunityViewModel = CommunityViewModel(provider:  CommunityServiceProvider())

    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchCommunityList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("self. router on CommunityViewController is \(String(describing: self.router))")
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)){
//            self.collectionMyGroups.reloadData()
//        }
    }
}

// MARK: Instance Methods
extension CommunityViewController {
    private func setup() {
        viewModel.view = self
        self.lblNoGroupsFound.isHidden = true
        self.lblNoInvitationFound.isHidden = true
        inviteFriendViewModel.view = self
   //    self.collectionNewGroupHabit.configure(obj: 15)
        self.collectionNewGroupHabit.delegate1 = self
        [btnSearch, btnInviteFriends].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
}

// MARK:- Button Action
extension CommunityViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnSearch:
            self.searcheAction()
        case btnInviteFriends:
            self.inviteFriendsAction()
        default:
            break
        }
    }
    
    private func searcheAction() {
        let communitySearch: CommunitySearchViewController = CommunitySearchViewController.from(from: .landing, with: .communitySearch)
        communitySearch.delegate1 = self
        self.navigationController?.present(communitySearch, animated: false, completion: nil)
       // self.router?.push(scene: .communitySearch) // deepak
    }
    
    private func inviteFriendsAction() {
        print("inviteFriendsAction")
      // self.inviteFriendViewModel.callApiGroupInvitation()
    }
}

// MARK: - Navigation
extension CommunityViewController: communityGroupHabitDetail{
    func navigate() {
//        let communityDetail: CommunityDetailViewController = CommunityDetailViewController.from(from: .landing, with: .communityDetail)
//        self.navigationController?.pushViewController(communityDetail, animated: true)
       self.router?.push(scene: .communityDetail) // deepu
    }
}

// MARK: - Api call backs
extension CommunityViewController: CommunityViewRepresentable, HabitViewRepresentable {
    func onAction(_ action: CommunityAction) {
        switch action {
        case  let .errorMessage(msg):
            self.showToast(message: msg)
        case  .sucessMessage(_):
            self.fetchCommunityData()
        default:
            break
        }
    }
    
    func onAction(_ action: HabitAction) {
       
    }
    
    private func fetchCommunityData() {
        print("self.viewModel.arrMyGroupList is \(self.viewModel.arrMyGroupList.count)")
        print("self.viewModel.arrInvitaions is \(self.viewModel.arrInvitaions.count)")
        if self.viewModel.arrMyGroupList.isEmpty == true {
            self.collectionMyGroups.isHidden = true
            self.lblNoGroupsFound.isHidden = false
        }else{
            self.collectionMyGroups.isHidden = false
            self.lblNoGroupsFound.isHidden = true
            self.collectionMyGroups.configure(myGroups: self.viewModel.arrMyGroupList)
            self.collectionMyGroups.reloadData()
        }
        
        if self.viewModel.arrInvitaions.isEmpty == true {
            self.collectionNewGroupHabit.isHidden = true
            self.lblNoInvitationFound.isHidden = false
        }else{
            self.collectionNewGroupHabit.isHidden = false
            self.lblNoInvitationFound.isHidden = true
            self.collectionNewGroupHabit.configure(myInvitaion: self.viewModel.arrInvitaions)
            self.collectionNewGroupHabit.reloadData()
        }
        
    }
}

