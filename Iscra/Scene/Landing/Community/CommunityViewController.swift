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
    private let viewModel: CommunityViewModel = CommunityViewModel(provider:  CommunityServiceProvider())
    
    weak var router: NextSceneDismisser?
    var objInvitaion: Invitaion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchCommunityList()
    }
}

// MARK: Instance Methods
extension CommunityViewController {
    private func setup() {
        self.viewModel.view = self
        self.lblNoGroupsFound.isHidden = true
        self.lblNoInvitationFound.isHidden = true
        self.collectionNewGroupHabit.communityDelegate = self
        [btnSearch, btnInviteFriends].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: .JoinHabit, object: nil)
    }
    
    @objc func refrershUI() {
        print("refrershUI is called")
    }
}

// MARK:- Button Action
extension CommunityViewController {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnSearch:
            self.searchAction()
        case btnInviteFriends:
            self.inviteFriendsAction()
        default:
            break
        }
    }
    
    private func searchAction() {
        self.router?.push(scene: .communitySearch)
    }
    
    private func inviteFriendsAction() {
        print("inviteFriendsAction")
        self.showToast(message: "Under development", seconds: 0.5)
    }
}

//MARK: - Navigation
extension CommunityViewController: CommunityInvitationDetailDelegate{
    func navigate(obj: Invitaion) {
        self.objInvitaion = obj
        self.router?.push(scene: .communityDetail)
    }
}

// MARK: - Api call backs
extension CommunityViewController: CommunityViewRepresentable {
    func onAction(_ action: CommunityAction) {
        switch action {
        case  let .errorMessage(msg):
            self.showToast(message: msg)
        case  .sucessMessage(_):
            self.reload()
        default:
            break
        }
    }
    
    private func reload() {
        print("self.viewModel.arrMyGroupList is \(self.viewModel.arrMyGroupList.count)")
        print("self.viewModel.arrInvitaions is \(self.viewModel.arrInvitaions.count)")
        //  self.viewModel.arrMyGroupList.removeAll()
        if self.viewModel.arrMyGroupList.isEmpty != true {
            self.collectionMyGroups.isHidden = false
            self.lblNoGroupsFound.isHidden = true
            self.collectionMyGroups.configure(myGroups: self.viewModel.arrMyGroupList)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.collectionMyGroups.reloadData()
            }
        } else {
            self.collectionMyGroups.isHidden = true
            self.lblNoGroupsFound.isHidden = false
        }
        
        if self.viewModel.arrInvitaions.isEmpty != true {
            self.collectionNewGroupHabit.isHidden = false
            self.lblNoInvitationFound.isHidden = true
            self.collectionNewGroupHabit.configure(myInvitaion: self.viewModel.arrInvitaions)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.collectionNewGroupHabit.reloadData()
            }
        } else {
            self.collectionNewGroupHabit.isHidden = true
            self.lblNoInvitationFound.isHidden = false
        }
    }
}
