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

struct UserTaskCollection {
    static private let emergencyKey = "EmergencyKey"
    private var emergency = UserDefaults.standard.array(forKey: emergencyKey)
    public var Emergency: [UserTask] {
        get {
            return (emergency as? [UserTask]? ?? []) ?? []
        }
        set {
            self.emergency = newValue
            UserDefaults.standard.set(emergency, forKey: UserTaskCollection.emergencyKey)
        }
    }
    
    static private let processingKey = "ProcessingKey"
    private var processing = UserDefaults.standard.array(forKey: processingKey)
    public var Processing: [UserTask] {
        get {
            return (processing as? [UserTask]? ?? []) ?? []
        }
        set {
            self.processing = newValue
            UserDefaults.standard.set(processing, forKey: UserTaskCollection.processingKey)
        }
    }
    
    static private let todoKey = "TodoKey"
    private var todo = UserDefaults.standard.array(forKey: todoKey)
    public var Todo: [UserTask] {
        get {
            return (todo as? [UserTask]? ?? []) ?? []
        }
        set {
            self.todo = newValue
            UserDefaults.standard.set(todo, forKey: UserTaskCollection.todoKey)
        }
    }
}

struct UserTaskHistory {
    public var History: [Date:UserTaskCollection] = [:]
}

struct UserSetting {
    
    static private let popoverWidthKey = "PopoverWidth"
    private var popoverWidth: CGFloat = CGFloat(UserDefaults.standard.integer(forKey: popoverWidthKey))
    var PopoverWidth: CGFloat {
        get {
            return popoverWidth == 0 ? 200 : popoverWidth
        }
        set {
            self.popoverWidth = newValue
            UserDefaults.standard.set(popoverWidth, forKey: UserSetting.popoverWidthKey)
        }
    }
    
    static private let popoverKeepKey = "PopoverKeep"
    private var popoverKeep: Bool = UserDefaults.standard.bool(forKey: popoverKeepKey)
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
    
    func RemoveFromTask(id: UUID) {
        Task.Emergency.removeAll(where: {$0.id == id})
        Task.Processing.removeAll(where: {$0.id == id})
        Task.Todo.removeAll(where: {$0.id == id})
    }
    
}
