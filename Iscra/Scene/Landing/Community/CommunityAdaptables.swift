//
//  CommunityAdaptables.swift
//  Iscra
//
//  Created by mac on 17/12/21.
//

import Foundation

enum CommunityScreenType: String {
    case communityList
    case communityDetail
    case communitySearch
}

enum CommunityAction {
    case joinHabit
    case fetchCommunity
    case allGroupHabit
    case friends
    case requireFields(_ text:String)
    case inputComplete(_ screen: CommunityScreenType)
    case setTheme(_ screen: CommunityScreenType)
    case setDaySelection(_ screen: CommunityScreenType)
    case setGroupImage(_ screen: CommunityScreenType)
    case editingDidEnd(_ field:String, _ value:String)
    case editingDidChange(_ field:String, _ value:String)
    case errorMessage(_ text:String)
    case sucessMessage(_ text:String)
}

protocol CommunityViewRepresentable: AnyObject {
    func onAction(_ action:  CommunityAction)
}

//protocolCommunityInputViewDelegate:AnyObject {
//    func onAction(action: CommunityAction, for screen: CommunityScreenType)
//}

protocol CommunityServiceProvidable: AnyObject {
    var  delegate: CommunityServiceProvierDelegate? { get set }
    func joinHabit(param: CommunityParams.JoinHabit)
    func fetchCommunity(param: CommunityParams.FetchCommunity)
    func allGroupHabit(param: CommunityParams.AllGroupHabit)
    func friends(param: CommunityParams.Friends)
}

protocol CommunityServiceProvierDelegate: AnyObject {
    func completed<T>(for action: CommunityAction, with response: T?, with error: APIError?)
}
