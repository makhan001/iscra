//
//  File.swift
//  Iscra
//
//  Created by Lokesh Patil on 09/11/21.
//

import Foundation

// MARK: - IconsHabitModel
struct IconsHabitModel: Codable {
    var iconCategory: [IconCategory]?

    enum CodingKeys: String, CodingKey {
        case iconCategory = "IconCategory"
    }
}

// MARK: - IconCategory
struct IconCategory: Codable {
    var habitName, habitID: String?
    var icons: [IconModel]?

    enum CodingKeys: String, CodingKey {
        case habitName, habitID
        case icons = "Icons"
    }
}

// MARK: - Icon
struct IconModel: Codable {
    var iconID, iconName: String?
    var value: Int?

    enum CodingKeys: String, CodingKey {
        case iconID = "IconId"
        case iconName = "IconName"
        case value
    }
}
