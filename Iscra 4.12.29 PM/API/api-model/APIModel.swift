//
//  APIModel.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 20/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation

struct AssignedToUserCreatable:Codable {
    let group_id: Int?
    var pageno: Int?
}

//struct UserProfile:Codable {
//    let id: Int
//}
//
//struct ProfileUpdatable:Codable {
//    let name:String?
//    let phone:String?
//    let address:String?
//    let dob:Double?
//    let delete_attachment:String?
//    let isd_code:String?
//}
//
//struct ClusterCreatable:Codable {
//    let category:Int
//    let name:String
//    let description:String?
//    let rules:String?
//    let group_slogan:String
//    let owner:String
//    let image:Data?
//}
//
//struct ClusterUpdatable:Codable {
//    let id:Int?
//    let name:String
//    let description:String?
//    let rules:String?
//    let group_slogan:String
//}
//
//
//struct CategoryCreatable:Codable {
//    let name:String
//    let type:String?
//}
//
//struct ShoppingCreatable:Codable {
//    let action: String?
//    let user_id: Int?
//    let group_id: Int?
//    var pageno: Int?
//}
//
//struct ShoppingAllListCreatable: Codable {
//    let group_id: Int?
//    let action: String?
//    var pageno: Int?
//}
//
//struct ShoppingMyListCreatable: Codable {
//    let action: String?
//    let user_id: Int?
//    let group_id: Int?
//    var pageno: Int?
//}
//
//struct ShoppingCompletedListCreatable: Codable {
//    let action: String?
//    let group_id: Int?
//    var pageno: Int?
//}
//
//struct ActivityCreatable:Codable {
//    let title:String?
//    let type: Int?
//    let group_id:Int?
//    let description:String?
//    let date_time:Double?
//    let reminder:String?
//    let latitude:Double?
//    let longitude:Double?
//    let visibility:Int?
//    let category_title:String?
//    let is_recurring:Int?
//    let recurring_type:Int?
//    let recurring_days:Double?
//    let anonymous: Int?
//    let privacy_type: ClusterPrivacy?
//}
//
//enum ActivityStatus: Int, Codable {
//    case event = 1
//    case activity = 2
//}
//
//struct ActivityUpdatable:Codable {
//    let id:Int?
//    let title:String?
//    let type: Int?
//    let group_id:Int?
//    let description:String?
//    let date_time:Double?
//    let reminder:String?
//    let latitude:Double?
//    let longitude:Double?
//    let visibility:Int?
//    let delete_attachment:String?
//    let category_title:String?
//    let is_recurring:Int?
//    let recurring_type:Int?
//    let recurring_days:Double?
//    let anonymous:Int?
//    let status:ActivityStatus?
//    let address:String?
//    let privacy_type: ClusterPrivacy?
//}
//
//struct ShoppingListDetailsCreatable: Codable {
//    let action: String?
//    let list_id: Int?
//    var pageno: Int?
//}
//
//struct TaskCreatable:Codable {
//    let title:String?
//    let type:Int?
//    let group_id:Int?
//    let description:String?
//    let reward_points:String?
//    let deadline:Double?
//    let assign_to:String?
//    let image:Data?
//    let priority:String?
//    let countdown:Int?
//    let is_recurring:Int?
//    let recurring_type:Int?
//    let recurring_days:Double?
//    let privacy_type: ClusterPrivacy?
//}
//
//struct TaskUpdatables:Codable {
//    let id:Int?
//    let group_id:Int?
//    let title:String?
//    let description:String?
//    let priority:String?
//    let deadline:Double?
//    let assign_to:String?
//    let reward_points:String?
//    let countdown:Int?
//    let comment:String?
//    let status:Int?
//    let delete_shopping:String?
//    let delete_attachment:String?
//    let shopping_id:String?
//    let type:Int?
//    let category_title:String?
//    let is_recurring:Int?
//    let recurring_type:Int?
//    let recurring_days:Double?
////    let privacy_type: ClusterPrivacy?
//}
//
//
//
//struct EventCreatable:Codable {
//    let title:String?
//    let group_id:Int?
//    let description:String?
//    let date_time:Double?
//    let latitude:Double?
//    let longitude:Double?
//    let duration:Double?
//    let task_id:String?
//    let shopping_id:String?
//    let member_designation:String?
//    let event_program:String?
//    let budget:String?
//    var objective:String?
//    let is_recurring:Int?
//    let recurring_type:Int?
//    let recurring_days:Double?
//    let info:String?
//    let address:String?
//    let privacy_type: ClusterPrivacy?
//}
//
//struct EventUpdatable:Codable {
//    let id:Int?
//    let title:String?
//    let group_id:Int?
//    let description:String?
//    let date_time:Double?
//    let latitude:Double?
//    let longitude:Double?
//    let duration:Double?
//    let task_id:String?
//    let shopping_id:String?
//    let member_designation:String?
//    let event_program:String?
//    let budget:String?
//    var objective:String?
//    let is_recurring:Int?
//    let recurring_type:Int?
//    let recurring_days:Double?
//    let info:String?
//    let address:String?
//    let delete_attachment:String?
//    let privacy_type: ClusterPrivacy?
//}
//
//
