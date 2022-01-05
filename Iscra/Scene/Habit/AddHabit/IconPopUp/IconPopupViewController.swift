//
//  iconPopupViewController.swift
//  Iscra
//
//  Created by Lokesh Patil on 26/10/21.
//

import UIKit

class IconPopupViewController: UIViewController {
    
    @IBOutlet weak var backGroundView:UIView!
    @IBOutlet weak var iconCollectionView:IconCollectionView! // iconCollectionView
    @IBOutlet weak var iocnHeaderCollectionView:IconHeaderCollectionView!
    
    let viewModel:IconsViewModel = IconsViewModel.init()
    var selectedIconName:((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// Mark: Instance Methods
extension IconPopupViewController {
    private func setup() {
        self.iconCollectionView.configure(viewModel: viewModel)
        self.iconCollectionView.didSelectIconAtIndex = didSelectIconAtIndex
        
        self.iocnHeaderCollectionView.configure(viewModel: viewModel)
        self.iocnHeaderCollectionView.didSelectCategoryAtIndex = didSelectCategoryAtIndex
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.backGroundView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Closure Callback
extension IconPopupViewController {
    func didSelectIconAtIndex(_ index: Int) {
        for i in 0..<self.viewModel.icons.count {
            self.viewModel.icons[i].isSelected = false
        }
        self.viewModel.iconIndex = index
        self.viewModel.icons[index].isSelected = true
        self.selectedIconName?(viewModel.icons[index].iconName)
        self.iconCollectionView.reloadData()
        
    }
    
    private func didSelectCategoryAtIndex(_ index: Int) {
        for i in 0..<viewModel.iconCategory.count {
            viewModel.iconCategory[i].isSelected = false
        }
        self.viewModel.categoryIndex = index
        self.viewModel.iconCategory[index].isSelected = true
        self.viewModel.icons = self.viewModel.iconCategory[index].icons
        self.iconCollectionView.reloadData()
        self.iocnHeaderCollectionView.reloadData()
    }
}
