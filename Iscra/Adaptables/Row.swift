//
//  Row.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 06/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation

struct Row {
    let name: String
    let type: ViewType
    let scence: Scenes
}

struct RowType: RowSectionDisplayable {
    var title: String
    var content: [Row]
}

struct RowJournal {
    let date: Date
    let isCount: Bool
    let text: String
}

struct RowJournalType: RowJournalSectionDisplayable {
    var title: Date
    var content: [RowJournal]
}

struct RowSectionDisplayableFunction {
    static func makeRowSectionDisplayable(resource: String) -> [RowSectionDisplayable] {
        let path = Bundle.main.path(forResource: resource, ofType: "plist")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
        
        var returnRowSectionDisplayable: [RowSectionDisplayable] = []
        guard let parent = plist as? Array<AnyObject> else { return [] }
        for i in parent {
            var rowArray: [Row] = []
            var title: String?
            
            guard let child = i as? Array<AnyObject> else { return [] }
            for j in child {
                var name: String?
                var type: String?
                var scene: String?
                
                if let titleChild = j as? String {
                    title = titleChild
                } else if let rowChild = j as? [String:String] {
                    name = rowChild["name"]!
                    type = rowChild["type"]!
                    scene = rowChild["scene"]!
                    
                    let row = Row(name: name!, type: ViewType(rawValue: type!)!, scence: Scenes(rawValue: scene!)!)
                    rowArray.append(row)
                }
            }
            
            let rowType = RowType(title: title ?? "", content: rowArray)
            returnRowSectionDisplayable.append(rowType)
        }
        
        return returnRowSectionDisplayable
    }
}

enum ViewType: String {
    case popup
    case xib
    case alert
    case controller
    case action
    case externalLink
    case hyperLinkController
}
