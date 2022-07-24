//
//  MainViewModel.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import Foundation
import AppKit

class MainViewModel: ObservableObject {
    @Published var PopOver = NSPopover()
    @Published public var Task = UserTaskCollection()
    @Published public var Setting = UserSetting()
}

class UserTaskCollection: ObservableObject {
    @Published public var Emergency: [UserTask] = []
    @Published public var Processing: [UserTask] = []
    @Published public var Todo: [UserTask] = []
}

struct UserTaskHistory {
    public var History: [Date:UserTaskCollection] = [:]
}

struct UserSetting {
    
    static private let popoverWidthKey = "PopoverWidth"
    static private let popoverKeepKey = "PopoverKeep"
    private var popoverWidth: CGFloat = CGFloat(UserDefaults.standard.integer(forKey: popoverWidthKey))
    private var popoverKeep: Bool = UserDefaults.standard.bool(forKey: popoverKeepKey)
    
    var PopoverWidth: CGFloat {
        get {
            return popoverWidth == 0 ? 200 : popoverWidth
        }
        set {
            self.popoverWidth = newValue
            UserDefaults.standard.set(popoverWidth, forKey: UserSetting.popoverWidthKey)
        }
    }
    
    var PopoverKeep: Bool {
        get {
            return popoverKeep
        }
        set {
            self.popoverKeep = newValue
            UserDefaults.standard.set(popoverKeep, forKey: UserSetting.popoverKeepKey)
        }
    }
    
}

// MARK: Function
extension MainViewModel {
    
    func RemoveFromTask(id: UUID) -> UserTask? {
        if let index = Task.Emergency.firstIndex(where: { $0.id == id }) {
            return Task.Emergency.remove(at: index)
        }
        if let index = Task.Processing.firstIndex(where: { $0.id == id }) {
            return Task.Processing.remove(at: index)
        }
        if let index = Task.Todo.firstIndex(where: { $0.id == id }) {
            return Task.Todo.remove(at: index)
        }
        return nil
    }
    
}
