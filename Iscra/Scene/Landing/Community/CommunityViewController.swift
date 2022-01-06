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
    @IBOutlet weak var collectionMyGroups: MyCommunityCollectionView! // myGroupCollectionView
    @IBOutlet weak var collectionNewGroupHabit: NewCommunityCollectionView! // newGroupCollectionView
    
    
    var objInvitaion: Invitaion?
    weak var router: NextSceneDismisser?
    let viewModel: CommunityViewModel = CommunityViewModel(provider:  CommunityServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.viewModel.fetchCommunityList()
    }
}

// MARK: Instance Methods
extension CommunityViewController {
    private func setup() {
        self.viewModel.view = self
        self.lblNoGroupsFound.isHidden = true
        self.lblNoInvitationFound.isHidden = true
        self.setCollectionView()
        [btnSearch, btnInviteFriends].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: .JoinHabit, object: nil)
    }
    
    private func setCollectionView() {
        self.collectionMyGroups.configure(viewModel: viewModel)
        self.collectionMyGroups.showHabitDetail = didSelectCollectionAtIndex
        self.collectionNewGroupHabit.configure(viewModel: viewModel)
        self.collectionNewGroupHabit.communityDelegate = self
    }
    
    @objc func refrershUI() {
        print("refrershUI is called")
        self.viewModel.fetchCommunityList()
    }
    
    private func didSelectCollectionAtIndex(index: Int) {
        self.viewModel.habitId = self.viewModel.myGroups[index].id ?? 0
        self.router?.push(scene: .groupHabitFriends)
    }

    private func reload() {
        self.reloadMyGroups()
        self.reloadNewGroups()
    }
    
    private func reloadMyGroups() {
        if self.viewModel.myGroups.isEmpty != true {
            self.collectionMyGroups.isHidden = false
            self.lblNoGroupsFound.isHidden = true
            DispatchQueue.main.async {
                self.collectionMyGroups.reloadData()
            }
        } else {
            self.collectionMyGroups.isHidden = true
            self.lblNoGroupsFound.isHidden = false
        }
    }
    
    private func reloadNewGroups() {
        if self.viewModel.myInvitaions.isEmpty != true {
            self.collectionNewGroupHabit.isHidden = false
            self.lblNoInvitationFound.isHidden = true
            self.collectionNewGroupHabit.configure(viewModel: viewModel)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.collectionNewGroupHabit.reloadData()
            }
        } else {
            self.collectionNewGroupHabit.isHidden = true
            self.lblNoInvitationFound.isHidden = false
        }
    }
}

// MARK: Button Action
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
        self.showActivityViewController(url: URL(string: "https://www.apple.com")!, text: "Iscra", image: UIImage(named: "ic-app-logo")!)
    }
    
    private func showActivityViewController(url:URL,  text: String,  image: UIImage) {
        let items = [url, text, image] as [Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}

// MARK: - Navigation Bar Delegate
extension CommunityViewController: CommunityInvitationDetailDelegate {
    func navigate(obj: Invitaion) {
        self.objInvitaion = obj
        self.router?.push(scene: .communityDetail)
    }
}

// MARK: - API CallBack
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
}
