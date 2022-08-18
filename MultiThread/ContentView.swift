//
//  ContentView.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import SwiftUI
import UIComponent

struct ContentView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Focus()
            HStack {
                SettingButton
                Spacer()
                Text("MultiThread")
                    .font(.system(size: 14, weight: .light, design: .default))
                    .foregroundColor(.primary25)
                    .kerning(1)
                    .monospacedDigit()
                Spacer()
                ShotdownButton
            }
            .padding(5)
            
            Separator(direction: .horizontal, color: .primary25.opacity(0.3), size: 1)
            MainPage
            
            Spacer()
        }
        .frame(height: mainViewModel.Setting.WindowsHeight)
        .background(.background)
    }
}


// MARK: View
extension ContentView {
    
    var ShotdownButton: some View {
        ButtonCustom(width: 35, height: 20, color: .red.opacity(0.9), radius: 4, style: .blank) {
            NSApplication.shared.terminate(self)
        } content: {
            Image(systemName: "power")
                .font(.callout)
                .foregroundColor(.white)
        }

    }
    
    var SettingButton: some View {
        ButtonCustom(width: 23, height: 20, color: .clear, radius: 5, border: 0) {
            withAnimation(Config.Animation.Default) {
                mainViewModel.page = mainViewModel.page == -1 ? 0 : -1
                print("page: \(mainViewModel.page)")
            }
        } content: {
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundColor(mainViewModel.page == -1 ? .accentColor : .primary50)
        }

    }
    
    var TaskPage: some View {
        VStack(spacing: 0) {
            if !mainViewModel.Setting.HideEmergency {
                TaskView(taskList: $mainViewModel.Task.Emergency,
                         title: Config.Task.Emergency.Title,
                         mainColor: Config.Task.Emergency.Color,
                         type: .Emergency)
                
                Separator(direction: .horizontal, color: .primary25, size: 1)
                    .blur(radius: 0.2)
                    .padding(2)
            }
            
            if !mainViewModel.Setting.HideBlock {
                TaskView(taskList: $mainViewModel.Task.Blocked,
                         title: Config.Task.Block.Title,
                         mainColor: Config.Task.Block.Color,
                         type: .Blocked)
                
                Separator(direction: .horizontal, color: .primary25, size: 1)
                    .blur(radius: 0.2)
                    .padding(2)
            }
            
            TaskView(taskList: $mainViewModel.Task.Processing,
                     title: Config.Task.Processing.Title,
                     mainColor: Config.Task.Processing.Color,
                     type: .Processing)
            
            Separator(direction: .horizontal, color: .primary25, size: 1)
                .blur(radius: 0.2)
                .padding(2)
            
            TaskView(taskList: $mainViewModel.Task.Todo,
                     title: Config.Task.Todo.Title,
                     mainColor: Config.Task.Todo.Color,
                     type: .Todo)
        }
    }
    
    var MainPage: some View {
        ZStack {
            switch mainViewModel.page {
                case -1:
                    SettingView()
                        .background(.background)
                        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .topLeading)))
                default:
                    TaskPage
                        .transition(.opacity)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Mock.mainViewModel)
            .frame(width: 350, height: 500)
        
        
        ContentView()
            .environmentObject(Mock.mainViewModel)
            .frame(width: 350, height: 500)
            .preferredColorScheme(.dark)
}
}

