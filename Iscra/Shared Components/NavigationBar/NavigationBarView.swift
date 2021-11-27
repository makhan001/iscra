//
//  NavigationBarView.swift
//  Iscra
//
//  Created by Lokesh Patil on 17/11/21.
//

import UIKit
@objc protocol navigationBarAction:class {
    func ActionType()
    @objc optional func RightButtonAction()
}
enum navRightViewType{
    case myProfie
    case editName
    case other
}
class NavigationBarView: UIView {
    let XIB_NAME = "NavigationBarView"
    @IBOutlet var viewContent: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnRightBar: UIButton!
    var delegateBarAction:navigationBarAction?
    var navType:navRightViewType = .other
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)
        viewContent.fixInView(self)
        [btnBack, btnRightBar].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        btnBack.showsTouchWhenHighlighted = false
        switch navType {
        case .myProfie:
            btnRightBar.setImage(#imageLiteral(resourceName: "ic-checkmark"), for: .normal)
            btnRightBar.isHidden = false
        case .editName:
            btnRightBar.isHidden = false
            btnRightBar.setImage(#imageLiteral(resourceName: "ic-bluetick"), for: .normal)
        case .other:
            btnRightBar.isHidden = true
        }
    }
    
}

extension NavigationBarView {
    @objc func buttonPressed(_ sender: UIButton) {
        switch  sender {
        case btnBack:
            self.backClick()
        case btnRightBar:
            self.rightButtonClick()
        default:
            break
        }
    }
    
    private func backClick() {
        delegateBarAction?.ActionType()
    }
    private func rightButtonClick() {
        delegateBarAction?.RightButtonAction?()
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

