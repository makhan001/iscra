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
    @IBOutlet weak var lblNoFriendFound: UILabel!

    var arrGroupList = [GroupHabit]()
    var arrFriend = [Friend]()
    var isSearching:Bool = false

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
        self.txtSearch.delegate = self
        self.tableFriends.isHidden = true
        self.viewNoGroups.isHidden = false
        self.tableGroupHabit.isHidden = true
        self.lblNoFriendFound.isHidden = true
        self.fetchAllGroupHabit()
        self.tableGroupHabit.navigateToDetail = { [self]
            selected in
            if selected{
                self.showToast(message: "Under development", seconds: 0.5)
//                self.dismiss(animated: false, completion: nil)
//                self.router?.push(scene: .groupHabitFriends)
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
            groupHabitAction()
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
    
    private func groupHabitAction() {
        print("groupHabitAction")
        self.fetchAllGroupHabit()
    }
    
    private func friendsAction() {
        print("friendsAction")
        print("btnSegment.selectedSegmentIndex friendsAction is  \(btnSegment.selectedSegmentIndex)")
        self.viewModel.callApiFriendList()
    }
    
    private func fetchAllGroupHabit() {
        print("btnSegment.selectedSegmentIndex GroupHabitAction is  \(btnSegment.selectedSegmentIndex)")
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
       // self.viewModel.arrFriend.removeAll()
        if self.viewModel.arrGroupList.isEmpty != true {
            self.viewNoGroups.isHidden = true
            self.tableGroupHabit.isHidden = false
            self.viewGroupsHabit.isHidden = false
            self.tableFriends.isHidden = true
            self.lblNoFriendFound.isHidden = true
            self.tableGroupHabit.configure(arrGroupList: self.viewModel.arrGroupList)
        }else if self.viewModel.arrFriend.isEmpty != true {
            self.viewGroupsHabit.isHidden = true
            self.tableFriends.isHidden = false
            self.viewNoGroups.isHidden = true
            self.lblNoFriendFound.isHidden = true
            self.tableFriends.configure(arrFriend: self.viewModel.arrFriend)
        }else{
            if self.btnSegment.selectedSegmentIndex == 1 {
                self.tableGroupHabit.isHidden = true
                self.viewGroupsHabit.isHidden = true
                self.tableFriends.isHidden = true
                self.viewNoGroups.isHidden = true
                self.lblNoFriendFound.isHidden = false
            }else{
                self.tableGroupHabit.isHidden = true
                self.viewGroupsHabit.isHidden = false
                self.tableFriends.isHidden = true
                self.viewNoGroups.isHidden = false
                self.lblNoFriendFound.isHidden = true
            }
        }
    }
}

//MARK: - searching operation
extension CommunitySearchViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let text = textField.text! as NSString
        
        if (text.length == 1) && (string == "") {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.viewModel.strSearchText = ""
            if self.btnSegment.selectedSegmentIndex == 1 {
                self.viewModel.arrFriend.removeAll()
            }else{
                self.viewModel.arrGroupList.removeAll()
            }
            
            self.viewModel.isSearching = true
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
            
        }else{
            var substring: String = textField.text!
            substring = (substring as NSString).replacingCharacters(in: range, with: string)
            substring = substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.viewModel.isSearching = true
            searchAutocompleteEntries(withSubstring: substring)
        }
        return true
    }
    
    func searchAutocompleteEntries(withSubstring substring: String) {
        if substring != "" {
            self.viewModel.strSearchText = substring
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func reload() {
        print("api calling in searching")
        if self.btnSegment.selectedSegmentIndex == 1 {
            self.viewModel.arrFriend.removeAll()
            self.viewModel.callApiFriendList()
        }else{
            self.viewModel.arrGroupList.removeAll()
            self.viewModel.callApiAllGroupHabit()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}
