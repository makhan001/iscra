//
//  Scenes.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 05/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation

enum Scenes:String {
    case welcome
    case login
    case signup
    case forgot
    case walkthrough
    case verification
    case landing
    case home
    case notification
    case category
    case createCategory
    case findUsers
    case setPrivacy
    case changePassword
    case feedback
    case privacy
    case logout
    case myProfile
    case editProfile
    case editFullName
    case editEmail
    case editPhone
    case editAddress
    case editDOB
    case userProfile
    case user_email
    case user_dob
    case user_attachment
    case user_calender
    case user_name
    case user_phone
    case user_address
    case createCluster
    case clusterDetail
    case editCluster
    case clusterMember
    case common
    case timeline
    case task
    case myTask
    case attachment
    case calendar
    case inputAlert
    case datePicker
    case pickerView
    case assignedToUser
    case imageDetail
    case clusterInfo
    case aboutCluster
    case clusterRules
    case leaveCluster
    case audioRecord
    case selectPrivacy
    case taskPrivacy
    case activityPrivacy
    case eventPrivacy
    case searchLocation
    case locationSearch
    case browser
    case reminderList
    case createReminder
    case dashboard
    case activityMark
    
    case nearby
    case appointments
    case myprofile
    case landingTab
    case saloonDetail
    case bookingServices
    case bookingStaff
    case bookingDate
    case bookingReview
    case bookingConfirmed
    case myAppointment
    case myFavorite
    case settings
    case myReviews
    case terms
    case chat
    case newChat
    case conversations
    case aboutus
    case staticContent
    case filters
}


enum Storyboard:String {
    case onboarding = "Onboarding"
    case landing = "Landing"
    case home = "Home"
    case chat = "Chat"
    case profile = "Profile"
    case common = "Common"
}

enum StoryboardIdentifier:String {
    case welcome
    case login
    case signup
    case forgot
    case walkthrough
    case landing
    case home
    case notification
    case changePassword
    case feedback
    case privacy
    case logout
    case myProfile
    case editProfile
    case VerificationViewController
    case findUsers
    case setPrivacy
    
    case userProfile
    case createCluster
    case clusterDetail
    case editCluster
    case clusterMember
    case common
    case timeline
    case myTask
    case attachment
    case calendar
    case more
    case inputAlert
    case createTask
    case activity
    case activityDetail
    case activityEdit
    case activityUser
    case shopping
    case countdown
    case documents
    case valuabledocs
    case events
    case myEvents
    case createEvent
    case eventsDetail
    case eventEdit
    case eventCountdown
    case contacts
    case createContact
    case createPost
    case editPost
    case postDetail
    case comments
    case editComments
    case editContact
    case leaderboard
    case map
    case createActivity
    case createShopping
    case shoppingDetail
    case myShoppingList
    case valueReceipt
    case shoppingTitle
    case shoppingType
    case shoppingAssigned
    case shoppingItem
    case shoppingQuantity
    case shoppingPrice
    case shoppingComment
    case shoppingPhoto
    case shoppingAddItem
    case shoppingButton
    case addedItems
    case datePicker
    case pickerView
    case assignedToUser
    case imageDetail
    case audioRecord
    case selectPrivacy
    case searchLocation
    case locationSearch
    case browser
    case reminderList
    case createReminder
    case dashboard
    
    case nearby
    case appointments
    case myprofile
    case landingTab
    case saloonDetail
    case bookingServices
    case bookingStaff
    case bookingDate
    case bookingReview
    case bookingConfirmed
    case myAppointment
    case myFavorite
    case settings
    case myReviews
    case terms
    case chat
    case newChat
    case conversations
    case aboutus
    case staticContent
    case filters
}
