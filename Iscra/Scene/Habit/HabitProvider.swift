//
//  HabitProvider.swift
//  Iscra
//
//  Created by mac on 26/11/21.
//

import Foundation

final class HabitServiceProvider: HabitServiceProvidable {
   
    var delegate: HabitServiceProvierDelegate?
    private let task = UserTask()

    func createHabit(param: HabitParams.CreateHabit) {
        WebService().StartIndicator()
        task.createHabit(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .createHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .createHabit, with: resp, with: nil)
        }
    }
    
    func deleteHabit(param: HabitParams.DeleteHabit) {
        task.deleteHabit(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .createHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .createHabit, with: resp, with: nil)
        }
    }
    
    func habitDetail(param: HabitParams.HabitDetail) {
        WebService().StartIndicator()
        task.habitDetail(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .createHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .createHabit, with: resp, with: nil)
        }
    }
    
    func habitList(param: HabitParams.AllHabitList) {
        WebService().StartIndicator()
        task.allHabitList(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .habitList, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .habitList, with: resp, with: nil)
        }
    }
    
    func updateHabit(param: HabitParams.UpdateHabit) {
        WebService().StartIndicator()
        task.updateHabit(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .createHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .createHabit, with: resp, with: nil)
        }
    }
    
    
    func markAsComplete(param: HabitParams.MarkAsComplete) {
       // WebService().StartIndicator()
        task.markAsComplete(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .createHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .createHabit, with: resp, with: nil)
        }
    }
    
    func shareHabit(param: HabitParams.ShareHabit) {
        WebService().StartIndicator()
        task.shareHabit(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .shareHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .shareHabit, with: resp, with: nil)
        }
    }
    
    func joinHabit(param: HabitParams.JoinHabit) {
        task.joinHabit(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .joinHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .joinHabit, with: resp, with: nil)
        }
    }
    
    func habitCalender(param: HabitParams.HabitCalender) {
        task.habitCalender(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .habitCalender, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .habitCalender, with: resp, with: nil)
        }
    }
        
    func groupHabitMembers(param: HabitParams.GroupHabitMembers) {
        task.groupHabitMembers(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .groupHabitMembers, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .groupHabitMembers, with: resp, with: nil)
        }
    }
    
    func groupHabitDetails(param: HabitParams.GroupHabitDetails) {
        task.groupHabitDetails(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .groupHabitDetails, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .groupHabitDetails, with: resp, with: nil)
        }
    }
}

