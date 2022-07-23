//
//  Config.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import CoreGraphics
import SwiftUI

struct Config {
    static let TaskViewWidth: CGFloat = 300
    static let Task = TaskSetting()
    static let Animation = AnimationSet()
}

struct TaskSetting {
    let Emergency = TaskSettingUnit(Title: "緊急", Color: .red)
    let Processing = TaskSettingUnit(Title: "進行中", Color: .accentColor)
    let Todo = TaskSettingUnit(Title: "待辦", Color: .gray)
}

struct TaskSettingUnit {
    let Title: String
    let Color: Color
}

struct AnimationSet {
    static private let duration: Double = 0.2
    let Default = Animation.easeInOut(duration: duration)
    let EaseIn = Animation.easeIn(duration: duration)
    let EaseOut = Animation.easeOut(duration: duration)
    
}

struct Previews_Config_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
