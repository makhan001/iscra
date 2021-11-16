//
//  AppAdaptables.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 06/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable {
    static var reuseIndentifier: String { get }
    static var nib: UINib? { get }
    func configure<T>(with content: T)
}

protocol ReusableReminder {
    static var reuseIndentifier: String { get }
    static var nib: UINib? { get }
    func configure<T>(with content: T, index: Int)
}

extension Reusable {
    static var reuseIndentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil }
}

extension ReusableReminder {
    static var reuseIndentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil }
}

protocol ControllerDismisser: AnyObject {
    func dismiss(controller:Scenes)
}

protocol PushNextController:AnyObject {
    func push(scene:Scenes)
}

@objc protocol PopPreviousController: AnyObject {
    @objc optional func popController()
}

protocol CoordinatorDimisser:class {
    func dismiss(coordinator:Coordinator<Scenes>)
}

protocol ScenePresenter {
    func present(scene:Scenes)
}

protocol RowSectionDisplayable {
    var title: String { get }
    var content: [Row] { get }
}

protocol RowJournalSectionDisplayable {
    var title: Date { get }
    var content: [RowJournal] { get }
}

typealias Dismisser = ControllerDismisser & CoordinatorDimisser
typealias NextSceneDismisser = PushNextController & ControllerDismisser & PopPreviousController
typealias NextSceneDismisserPresenter = NextSceneDismisser & Dismisser
