//
//  CommunityViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//
import UIKit

class CommunityViewController: UIViewController {

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnInviteFriends: UIButton!
    
    @IBOutlet weak var collectionMyGroups: MyCommunityCollectionView!
    @IBOutlet weak var collectionNewGroupHabit: NewCommunityCollectionView!
    
    weak var router: NextSceneDismisser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3))
        {
            self.collectionMyGroups.reloadData()
        }
    }
}

// MARK: Instance Methods
extension CommunityViewController {
    private func setup() {
       
       self.collectionMyGroups.configure(obj: 5)
       self.collectionNewGroupHabit.configure(obj: 15)
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
//        let vc = storyboard?.instantiateViewController(withIdentifier: "CommunitySearchViewController") as! CommunitySearchViewController
//        vc.delegate1 = self
//        self.navigationController?.present(vc, animated: true, completion: nil)
        
        let communitySearch: CommunitySearchViewController = CommunitySearchViewController.from(from: .landing, with: .communitySearch)
        communitySearch.delegate1 = self
        self.navigationController?.present(communitySearch, animated: true, completion: nil)
        
    }
    
    private func inviteFriendsAction() {
        print("inviteFriendsAction")
    }
}

// MARK: - Navigation
extension CommunityViewController: communityGroupHabitDetail{
    func navigate() {
       
//        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CommunityDetailViewController") as! CommunityDetailViewController
//        navigationController?.pushViewController(vc, animated: true)
        
        let communityDetail: CommunityDetailViewController = CommunityDetailViewController.from(from: .landing, with: .communityDetail)
        self.navigationController?.pushViewController(communityDetail, animated: true)
    }
}
