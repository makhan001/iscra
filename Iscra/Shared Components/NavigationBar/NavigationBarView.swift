//
//  NavigationBarView.swift
//  Iscra
//
//  Created by Lokesh Patil on 17/11/21.
//
import UIKit
@objc protocol NavigationBarViewDelegate: AnyObject {
    func navigationBackAction()
    @objc optional func navigationRightButtonAction()
}
enum navRightViewType{
    case myProfie
    case editName
    case other
    case editHabit
    case habitCalender
    case addHabit
}

class NavigationBarView: UIView {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnRightBar: UIButton!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewContent: UIView!
    
    let XIB_NAME = "NavigationBarView"
    var navType:navRightViewType = .other
    var delegateBarAction:NavigationBarViewDelegate?
    
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
        [btnSave, btnBack, btnRightBar].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        btnBack.showsTouchWhenHighlighted = false
        switch navType {
        case .myProfie:
            btnRightBar.setImage(#imageLiteral(resourceName: "ic-edit-image"), for: .normal)
            btnRightBar.isHidden = false
            btnBack.isHidden = true
        case .editName:
            btnRightBar.isHidden = false
            btnRightBar.setImage(#imageLiteral(resourceName: "ic-checkmark"), for: .normal)
        case .editHabit:
            btnSave.isHidden = false
            // btnRightBar.tintColor = .black
            //btnRightBar.setImage(#imageLiteral(resourceName: "ic-checkmark"), for: .normal)
            //   btnRightBar.titleLabel?.text = "Save"
        case .habitCalender:
            btnRightBar.isHidden = false
            btnRightBar.setImage(#imageLiteral(resourceName: "ic-dots"), for: .normal)
        case .addHabit:
            btnRightBar.isHidden = false
            btnRightBar.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        case .other:
            btnRightBar.isHidden = true
        }
    }
}
extension NavigationBarView {
    @objc func buttonPressed(_ sender: UIButton) {
        switch sender {
        case btnBack:
            self.backClick()
        case btnRightBar:
            self.rightButtonClick()
        case btnSave:
            self.rightButtonClick()
        default:
            break
        }
    }
    private func backClick() {
        delegateBarAction?.navigationBackAction()
    }
    private func rightButtonClick() {
        delegateBarAction?.navigationRightButtonAction?()
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






