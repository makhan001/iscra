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
        self.viewModel.view = self
        self.lblNoGroupsFound.isHidden = true
        self.lblNoInvitationFound.isHidden = true
        self.collectionNewGroupHabit.delegate1 = self
        [btnSearch, btnInviteFriends].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "joinHabit"), object: nil)
    }
    
    @objc func refrershUI(){
        print("refrershUI is called")
        self.viewModel.arrInvitaions.removeAll()
        self.viewModel.arrMyGroupList.removeAll()
        self.viewModel.fetchCommunityList()
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
        let communitySearch: CommunitySearchViewController = CommunitySearchViewController.from(from: .landing, with: .communitySearch)
     //   communitySearch.delegate1 = self
        communitySearch.router = self.router 
        self.navigationController?.present(communitySearch, animated: false, completion: nil)
    }
    
    private func inviteFriendsAction() {
        print("inviteFriendsAction")
        self.showToast(message: "Under development", seconds: 0.5)
     //  self.viewModel.callApiGroupInvitation()
    }
}

 //MARK: - Navigation
extension CommunityViewController: communityInvitationDetail{
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
            self.fetchCommunityResponse()
        default:
            break
        }
    }
    
    private func fetchCommunityResponse() {
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
