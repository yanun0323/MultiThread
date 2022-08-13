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
    @Published public var page: Int = 0
}

enum TaskType {
    case Emergency, Processing, Todo, Blocked
}

class UserTaskCollection: ObservableObject {
    @Published public var Emergency: [UserTask] = []
    @Published public var Processing: [UserTask] = []
    @Published public var Todo: [UserTask] = []
    @Published public var Blocked: [UserTask] = []
}

struct UserTaskHistory {
    public var History: [Date:UserTaskCollection] = [:]
}

struct UserSetting {
    private var popoverWidth: Double = UserDefaults.standard.double(forKey: "PopoverWidth")
    var PopoverWidth: Double {
        get {
            return popoverWidth == 0 ? Config.Popover.MinWidth : popoverWidth
        }
        set {
            self.popoverWidth = newValue
            UserDefaults.standard.set(popoverWidth, forKey: "PopoverWidth")
        }
    }
    
    private var popoverClick: Bool = UserDefaults.standard.bool(forKey: "PopoverClick")
    var PopoverClick: Bool {
        get {
            return popoverClick
        }
        set {
            self.popoverClick = newValue
            UserDefaults.standard.set(popoverClick, forKey: "PopoverClick")
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
    
    private var windowsWidth: Double = UserDefaults.standard.double(forKey: "WindowsWidth")
    var WindowsWidth: Double {
        get {
            return windowsWidth == 0 ? Config.Windows.MinWidth : windowsWidth
        }
        set {
            self.windowsWidth = newValue
            UserDefaults.standard.set(windowsWidth, forKey: "WindowsWidth")
        }
    }
    
    private var windowsHeight: Double = UserDefaults.standard.double(forKey: "WindowsHeight")
    var WindowsHeight: Double {
        get {
            return windowsHeight == 0 ? Config.Windows.MinHeight : windowsHeight
        }
        set {
            self.windowsHeight = newValue
            UserDefaults.standard.set(windowsHeight, forKey: "WindowsHeight")
        }
    }
    
    private var hideBlock: Bool = UserDefaults.standard.bool(forKey: "HideBlock")
    var HideBlock: Bool {
        get {
            return hideBlock
        }
        set {
            self.hideBlock = newValue
            UserDefaults.standard.set(hideBlock, forKey: "HideBlock")
        }
    }
    
    private var hideEmergency: Bool = UserDefaults.standard.bool(forKey: "HideEmergency")
    var HideEmergency: Bool {
        get {
            return hideEmergency
        }
        set {
            self.hideEmergency = newValue
            UserDefaults.standard.set(hideEmergency, forKey: "HideEmergency")
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
