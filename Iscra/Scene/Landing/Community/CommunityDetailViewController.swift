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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionMates: MatesCollectionView!

    var vibrantLabel = UILabel()
    var headerImageView: UIView?
    var objInvitaion: Invitaion?


    weak var router: NextSceneDismisser?
    let viewModel: CommunityDetailViewModel = CommunityDetailViewModel(provider: HabitServiceProvider())

    override func viewDidLoad() {
        super.viewDidLoad()
        print("self.router is \(String(describing: self.router))")

        self.setup()
    }
}

// MARK: Instance Methods
extension CommunityDetailViewController {
    private func setup() {
        self.viewModel.view = self
        self.setupParallaxHeader()
        self.addTitleLabel()
        self.collectionMates.configure(obj: 3)
        [btnBack,btnJoin].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        self.viewModel.habitId = self.objInvitaion?.id ?? 0
        self.viewModel.userId = UserStore.userID ?? ""
        self.viewModel.fetchHabitDetail()
    }
    
    private func addTitleLabel() {
        vibrantLabel.frame = CGRect(x: 0, y: 82, width: view.bounds.width, height: 125)
        vibrantLabel.text = "Group Habit"
        vibrantLabel.backgroundColor = UIColor.white
        
        vibrantLabel.font = UIFont.systemFont(ofSize:  CGFloat(32), weight: .bold)
        vibrantLabel.textColor = UIColor.init(named: "DarkYellowAccent")
        
        vibrantLabel.contentMode = .scaleAspectFill
        vibrantLabel.textAlignment = .center
        vibrantLabel.tag = 111
        
        headerImageView?.addSubview(vibrantLabel)
        self.vibrantLabel.isHidden = true
       
    }
        
    private func setupParallaxHeader() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic-Rectangle")
        imageView.contentMode = .scaleAspectFill
        
        //setup blur vibrant view
//        imageView.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 1).enable()
//        imageView.blurView.alpha = 0
        headerImageView = imageView
        tableView.parallaxHeader.view = imageView
        tableView.parallaxHeader.view.backgroundColor = UIColor.red
        tableView.parallaxHeader.height = 242
        tableView.parallaxHeader.minimumHeight = 90
        tableView.parallaxHeader.mode = .centerFill
        tableView.parallaxHeader.parallaxHeaderDidScrollHandler = { [self] parallaxHeader in
           // parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
            print("progress is ---> \(parallaxHeader.progress)")
            
            if parallaxHeader.progress <= 0.3 {
                self.vibrantLabel.isHidden = false
            } else {
                self.vibrantLabel.isHidden = true
            }
            
        }
        
    }
}

// MARK:- Button Action
extension CommunityDetailViewController {
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnBack:
            self.backAction()
        case btnJoin:
            self.joinAction()
        default:
            break
        }
    }
    
    private func joinAction() {
        print("self.viewModel.habitId. \(self.viewModel.habitId)")
        print("self.viewModel.userId. \(self.viewModel.userId)")
    }
    
    private func backAction() {
       // self.navigationController?.popViewController(animated: true)
        self.router?.dismiss(controller: .communityDetail)  // deepu
    }
    
}

extension CommunityDetailViewController: HabitViewRepresentable{
    func onAction(_ action: HabitAction) {
        switch action {
        case  let .errorMessage(msg):
            self.showToast(message: msg)
        case .sucessMessage(_):
            print("load data")
            break
        default:
            break
        }
    }
}
