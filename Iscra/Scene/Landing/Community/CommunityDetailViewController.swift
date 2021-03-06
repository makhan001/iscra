//
//  CommunityDetailViewController.swift
//  Iscra
//
//  Created by mac on 27/10/21.
//

import UIKit
import ParallaxHeader

class CommunityDetailViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnMates: UIButton!
    
    @IBOutlet weak var lblMates: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lbldiscription: UILabel!
    @IBOutlet weak var lblMembersCount: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: MatesCollectionView!
    
    var vibrantLabel = UILabel()
    var headerImageView: UIView?
    var objGroupHabitDetails: GroupHabitDetails?
    
    weak var router: NextSceneDismisser?
    let viewModel: CommunityDetailViewModel = CommunityDetailViewModel(provider: HabitServiceProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Instance Methods
extension CommunityDetailViewController {
    private func setup() {
        self.refrershUI(true)
        self.viewModel.view = self
        [btnBack,btnJoin,btnMates].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        self.viewModel.userId = UserStore.userID ?? ""
        self.viewModel.fetchHabitDetail()
    }
    
    private func refrershUI(_ isHidden: Bool) {
        self.btnJoin.isHidden = isHidden
        self.lblMates.isHidden = isHidden
    }
    
    private func addTitleLabel() {
        vibrantLabel.frame = CGRect(x: 0, y: 82, width: view.bounds.width, height: 125)
        vibrantLabel.text = "Group Habit"
        vibrantLabel.backgroundColor = UIColor.white
        vibrantLabel.font = UIFont.systemFont(ofSize:  CGFloat(32), weight: .bold)
        vibrantLabel.textColor = UIColor.init(named: "DarkYellowAccent")
        vibrantLabel.contentMode = .scaleAspectFill
        vibrantLabel.textAlignment = .center
      //  vibrantLabel.tag = 111
        headerImageView?.addSubview(vibrantLabel)
        self.vibrantLabel.isHidden = true
    }
    
    private func setupParallaxHeader(groupImage: String) {
        let imageView = UIImageView()
        
        let profilePic = groupImage
        if profilePic != "" && profilePic != "<null>" {
            let url = URL(string: profilePic)
            imageView.sd_setImage(with: url, placeholderImage: AppConstant.HabitPlaceHolderImage)
        } else {
            imageView.image = AppConstant.HabitPlaceHolderImage
        }
        
        if imageView.image == AppConstant.HabitPlaceHolderImage {
            imageView.contentMode = .center
        } else{
            imageView.contentMode = .scaleAspectFill
        }
        headerImageView = imageView
        tableView.parallaxHeader.view = imageView
        tableView.parallaxHeader.height = 242
        tableView.parallaxHeader.minimumHeight = 90
        tableView.parallaxHeader.mode = .centerFill
        tableView.parallaxHeader.parallaxHeaderDidScrollHandler = { [self] parallaxHeader in
            print("progress is ---> \(parallaxHeader.progress)")
            if parallaxHeader.progress <= 0.3 {
                self.vibrantLabel.isHidden = false
            } else {
                self.vibrantLabel.isHidden = true
            }
        }
    }
}

// MARK: Button Action
extension CommunityDetailViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnBack:
            self.backAction()
        case btnJoin:
            self.joinAction()
        case btnMates:
            self.matesAction()
        default:
            break
        }
    }
    
    private func joinAction() {
        self.viewModel.joinHabit()
    }
    
    private func backAction() {
        self.router?.dismiss(controller: .communityDetail)
    }
    private func matesAction() {
        self.router?.push(scene: .groupMembers)
    }
}

extension CommunityDetailViewController: HabitViewRepresentable{
    func onAction(_ action: HabitAction) {
        switch action {
        case  let .errorMessage(msg):
            self.showToast(message: msg)
        case .sucessMessage(_):
            self.objGroupHabitDetails = self.viewModel.objGroupHabitDetails
            self.reloadUI()
        case let .joinHabitMessage(msg):
            self.showToast(message: msg, seconds: 0.5)
            self.router?.dismiss(controller: .community)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: .JoinHabit, object: nil)
                self.router?.push(scene: .landing)
            }
            break
        default:
            break
        }
    }
    
    func reloadUI() {
        self.refrershUI(false)
        self.objGroupHabitDetails = self.viewModel.objGroupHabitDetails
        self.lblGroupName.text = self.objGroupHabitDetails?.name?.capitalized
        self.lbldiscription.text = self.objGroupHabitDetails?.groupHabitDetailsDescription
        self.lblMembersCount.text = "(" + String(self.objGroupHabitDetails?.memberCount ?? 0) + ")"
        self.setupParallaxHeader(groupImage: self.objGroupHabitDetails?.image ?? "ic-habit-placeholder")
        self.addTitleLabel()
        self.collectionView.configure(arrMember: self.objGroupHabitDetails?.usersProfileImageURL)
    }
}
