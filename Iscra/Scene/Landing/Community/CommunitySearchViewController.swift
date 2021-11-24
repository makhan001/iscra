//
//  CommunitySearchViewController.swift
//  Iscra
//
//  Created by mac on 26/10/21.
//

import UIKit

class CommunitySearchViewController: UIViewController {
    
    // MARK:-Outlets and variables
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewNoGroups: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewGroupsHabit: UIView!
    @IBOutlet weak var btnCreateGroupHabit: UIButton!
    @IBOutlet weak var btnSegment: UISegmentedControl!
    @IBOutlet weak var tableGroupHabit: GroupHabitTableView!
    @IBOutlet weak var tableFriends: CommunityFriendTableView!

    weak var delegate1 : communityGroupHabitDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension CommunitySearchViewController {
    private func setup() {
        [btnBack, btnCreateGroupHabit ].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        [btnSegment ].forEach {
            $0?.addTarget(self, action: #selector(segmentPressed(_:)), for: .valueChanged)
        }
        
        self.tableGroupHabit.configure(obj: 10)
        self.tableFriends.configure(obj: 10)
      //  self.tableGroupHabit.delegate1 = self
        
//        self.viewNoGroups.isHidden = false
//        self.tableGroupHabit.isHidden = true
//        self.tableFriends.isHidden = true
//        self.viewNoGroups.isHidden = false
                
        self.viewGroupsHabit.isHidden = false
        self.viewNoGroups.isHidden = true
        self.tableGroupHabit.isHidden = false
        self.tableFriends.isHidden = true
        
        self.tableGroupHabit.navigateToDetail = { [self]
           seleted in
           if seleted{
            self.dismiss(animated: false, completion: nil)
            self.delegate1?.navigate()
           }
       }
        
    }
}
// MARK:- Button Action
extension CommunitySearchViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnBack:
            self.backAction()
        case btnCreateGroupHabit:
            self.createGroupHabitAction()
        default:
            break
        }
    }
    
    @objc func segmentPressed(_ sender: UISegmentedControl) {
        switch btnSegment.selectedSegmentIndex {
        case 0:
            GroupHabitAction()
        case 1:
            friendsAction()
        default:
            break
        }
    }
    
    private func backAction() {
        print("backAction")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func createGroupHabitAction() {
        print("createGroupHabitAction")
    }
    
    private func GroupHabitAction() {
        print("GroupHabitAction")
        self.viewGroupsHabit.isHidden = false
        self.viewNoGroups.isHidden = true
        self.tableGroupHabit.isHidden = false
        self.tableFriends.isHidden = true
    }
    
    private func friendsAction() {
        print("friendsAction")
        self.viewGroupsHabit.isHidden = true
        self.tableFriends.isHidden = false
    }

}