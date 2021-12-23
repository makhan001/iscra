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
    
    var arrGroupList = [GroupHabit]()
    var arrFriend = [Friend]()

  //  weak var delegate1 : communityGroupHabitDetail?
    weak var delegate: SelectHabitPopUpDelegate?

    weak var router: NextSceneDismisser?
    private let viewModel: CommunitySearchViewModel = CommunitySearchViewModel(provider:  CommunityServiceProvider())
    override func viewDidLoad() {
        super.viewDidLoad()
        print("self.router is \(String(describing: self.router))")
        self.setup()
    }
}

// MARK: Instance Methods
extension CommunitySearchViewController {
    private func setup() {
        self.viewModel.view = self
        [btnBack, btnCreateGroupHabit ].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        [btnSegment ].forEach {
            $0?.addTarget(self, action: #selector(segmentPressed(_:)), for: .valueChanged)
        }
        //self.txtSearch.delegate = self
        self.tableFriends.isHidden = true
        self.viewNoGroups.isHidden = false
        self.tableGroupHabit.isHidden = true
        self.fetchAllGroupHabit()
        self.tableGroupHabit.navigateToDetail = { [self]
            selected in
           if selected{
            self.dismiss(animated: false, completion: nil)
         //   self.delegate1?.navigate()
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
        self.dismiss(animated: false, completion: nil)
    }
    
    private func createGroupHabitAction() {
        print("createGroupHabitAction")
        
        self.showToast(message: "Under development", seconds: 0.5)

        
//        self.dismiss(animated: false, completion: nil)
//        self.router?.push(scene: .addHabit)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) { [self] in
//            delegate?.addHabit(type: .group_habit)
//
//        }
        
       // self.router?.push(scene: .addHabit)
    }
    
    private func GroupHabitAction() {
        print("GroupHabitAction")
        self.fetchAllGroupHabit()
    }
    
    private func friendsAction() {
        print("friendsAction")
        self.viewModel.callApiFriendList()
    }
    
    private func fetchAllGroupHabit() {
        self.viewModel.callApiAllGroupHabit()
    }
}

// MARK: - Api call backs
extension CommunitySearchViewController: CommunityViewRepresentable {
    func onAction(_ action: CommunityAction) {
        switch action {
        case  let .errorMessage(msg):
            self.showToast(message: msg)
        case  .sucessMessage(_):
            self.fetchApiResponse()
        default:
            break
        }
    }
    
    private func fetchApiResponse() {
        WebService().StopIndicator()
        print("self.viewModel.arrGroupList is \(self.viewModel.arrGroupList.count)")
        print("self.viewModel.arrFriend is \(self.viewModel.arrFriend.count)")
             //  self.viewModel.arrGroupList.removeAll()
        if self.viewModel.arrGroupList.isEmpty != true {
                                self.viewNoGroups.isHidden = true
                                self.tableGroupHabit.isHidden = false
                                self.viewGroupsHabit.isHidden = false
            self.tableFriends.isHidden = true
                                self.tableGroupHabit.configure(arrGroupList: self.viewModel.arrGroupList)
        }else if self.viewModel.arrFriend.isEmpty != true {
                        self.viewGroupsHabit.isHidden = true
                        self.tableFriends.isHidden = false
            self.viewNoGroups.isHidden = true

                        self.tableFriends.configure(arrFriend: self.viewModel.arrFriend)
        }else{
            self.tableGroupHabit.isHidden = true
            self.viewGroupsHabit.isHidden = false
            self.tableFriends.isHidden = true
            self.viewNoGroups.isHidden = false
        }
    }
}


