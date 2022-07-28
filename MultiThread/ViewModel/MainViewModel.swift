//
//  MainViewModel.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import Foundation
import AppKit
import CoreData

class MainViewModel: ObservableObject {
    @Published var PopOver = NSPopover()
    @Published public var Task = UserTaskCollection()
    @Published public var Setting = UserSetting()
}

enum TaskType {
    case Emergency, Processing, Todo
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
    private var popoverWidth: CGFloat = CGFloat(UserDefaults.standard.integer(forKey: "PopoverWidth"))
    var PopoverWidth: CGFloat {
        get {
            return popoverWidth == 0 ? 200 : popoverWidth
        }
        set {
            self.popoverWidth = newValue
            UserDefaults.standard.set(popoverWidth, forKey: "PopoverWidth")
        }
    }
    
    private var popoverKeep: Bool = UserDefaults.standard.bool(forKey: "PopoverKeep")
    var PopoverKeep: Bool {
        get {
            return popoverKeep
        }
        set {
            self.popoverKeep = newValue
            UserDefaults.standard.set(popoverKeep, forKey: "PopoverKeep")
        }
    }
    
    private var windowsWidth: Int = UserDefaults.standard.integer(forKey: "WindowsWidth")
    var WindowsWidth: Int {
        get {
            return windowsWidth == 0 ? 350 : windowsWidth
        }
        set {
            self.windowsWidth = newValue
            UserDefaults.standard.set(windowsWidth, forKey: "WindowsWidth")
        }
    }
    
    private var windowsHeight: Int = UserDefaults.standard.integer(forKey: "WindowsHeight")
    var WindowsHeight: Int {
        get {
            return windowsHeight == 0 ? 800 : windowsHeight
        }
        set {
            self.windowsHeight = newValue
            UserDefaults.standard.set(windowsHeight, forKey: "WindowsHeight")
        }
    }
    
    private var appearance: Int = UserDefaults.standard.integer(forKey: "Theme")
    
    /**
    User stored appearance
     
     0 : system
     
     1 : light
     
     2 : dark
     */
    var AppearanceInt: Int {
        get {
            appearance
        }
    }
    
    var Appearance: NSAppearance? {
        get {
            switch appearance {
            case 1:
                return NSAppearance(named: .aqua)
            case 2:
                return NSAppearance(named: .darkAqua)
            default:
                return nil
            }
        }
        set {
            switch newValue {
            case NSAppearance(named: .aqua):
                self.appearance = 1
                #if DEBUG
                print("Set Light Mode")
                #endif
            case NSAppearance(named: .darkAqua):
                self.appearance = 2
                #if DEBUG
                print("Set Light Mode")
                #endif
            default:
                self.appearance = 0
                #if DEBUG
                print("Set Light Mode")
                #endif
            }
            UserDefaults.standard.set(appearance, forKey: "Theme")
        }
    }
    
    
}

// MARK: Function
extension MainViewModel {
}

extension UserDefaults {
    static var Emergency: [UserTask] {
        get {
            #if DEBUG
            print("UserDefaults Get")
            #endif
            
            return []
        }
        set {
            #if DEBUG
            print("UserDefaults Set")
            #endif
        }
    }
}
