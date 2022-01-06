//
//  ChatPrivateTitleView.swift
//  sample-chat-swift
//
//  Created by Injoit on 11/25/19.
//  Copyright © 2019 Quickblox. All rights reserved.
//

import UIKit
import Quickblox


class ChatPrivateTitleView: UIStackView {

//    lazy var avatarLabel: UILabel = {
//        let avatarLabel = UILabel()
//        avatarLabel.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
//        avatarLabel.textColor = .white
//        avatarLabel.font = .systemFont(ofSize: 17.0, weight: .semibold)
//        avatarLabel.textAlignment = .center
//        avatarLabel.setRoundedLabel(cornerRadius: 13.0)
//        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
//        avatarLabel.widthAnchor.constraint(equalToConstant: 26.0).isActive = true
//        avatarLabel.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
//        return avatarLabel
//    }()

    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.setRoundedView(cornerRadius: 13.0)
        avatarImageView.contentMode = .scaleAspectFill
//        avatarLabel.addSubview(avatarImageView)
//        avatarImageView.center = avatarLabel.center
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalToConstant: 26.0).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        avatarImageView.contentMode = .scaleAspectFill
        return avatarImageView
    }()
//MARK: Chat Screen Title Label Color,Size------
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = #colorLiteral(red: 0.6156862745, green: 0.5843137255, blue: 0.4862745098, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 24.0, weight: .bold)
        addSubview(titleLabel)
        return titleLabel
    }()
    
    func setupPrivateChatTitleView(_ opponentUser:QBUUser) {
        let userName = opponentUser.fullName?.capitalized
//        avatarLabel.text = String(userName?.capitalized.first ?? Character("Q"))
//        avatarLabel.backgroundColor = opponentUser.id.generateColor()
        let userImage = opponentUser.customData
        avatarImageView.sd_setImage(with: URL(string: userImage ?? ""), placeholderImage: UIImage(named: "group") )
        
        titleLabel.text = userName?.capitalized
        //addArrangedSubview(avatarLabel)
        addArrangedSubview(avatarImageView)
        addArrangedSubview(titleLabel)
        
        spacing = 5.0
        alignment = .center
    }
}
