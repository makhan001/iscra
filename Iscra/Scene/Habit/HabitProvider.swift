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
       
        task.habitDetail(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .createHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .createHabit, with: resp, with: nil)
        }
    }
    
    func habitList(param: HabitParams.AllHabitList) {
        
        task.allHabitList(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .createHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .createHabit, with: resp, with: nil)
        }
    }
    
    func updateHabit(param: HabitParams.UpdateHabit) {
       
        task.updateHabit(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .createHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .createHabit, with: resp, with: nil)
        }
    }
}

