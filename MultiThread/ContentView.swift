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
    @State private var page: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Focus()
            HStack {
                SettingButton
                Spacer()
                ButtonCustom(width: 40, height: 30) {
                    for task in mainViewModel.Task.Emergency {
                        print("-------Emergency----------")
                        print(task.title)
                        print(task.note)
                        print(task.other)
                    }
                
                    for task in mainViewModel.Task.Processing {
                        print("-------Processing----------")
                        print(task.title)
                        print(task.note)
                        print(task.other)
                    }
                    
                    for task in mainViewModel.Task.Todo {
                        print("-------Todo----------")
                        print(task.title)
                        print(task.note)
                        print(task.other)
                    }
                } content: {
                    Text("Debug")
                }

                ShotdownButton
            }
            .padding(5)
            
            switch page {
            case -1:
                SettingPage
                    .transition(.opacity.combined(with: .scale(scale: 0.1, anchor: .topLeading)))
            case 0:
                TaskPage
                    .transition(.opacity)
            default:
                TaskPage
                    .transition(.opacity)
            }
            
            Spacer()
            Text("Receiver")
                .foregroundColor(.background)
//                .onReceive(mainViewModel.Task.$Emergency) { ouput in
//                    mainViewModel.Task.Emergency = ouput
//                }
//                .onReceive(mainViewModel.Task.$Processing) { ouput in
//                    mainViewModel.Task.Processing = ouput
//                }
//                .onReceive(mainViewModel.Task.$Todo) { ouput in
//                    mainViewModel.Task.Todo = ouput
//                }
        }
        .background(.background)
    }
}


// MARK: View
extension ContentView {
    
    var ShotdownButton: some View {
        ButtonCustom(width: 35, height: 20, color: .red.opacity(0.9), radius: 5, style: .blank) {
            NSApplication.shared.terminate(self)
        } content: {
            Image(systemName: "power")
                .font(.callout)
                .foregroundColor(.white)
        }

    }
    
    var SettingButton: some View {
        ButtonCustom(width: 35, height: 20, color: .clear, radius: 5, border: 0) {
            withAnimation(Config.Animation.Default) {
                page = page == -1 ? 0 : -1
            }
        } content: {
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundColor(page == -1 ? .accentColor : .primary50)
        }

    }
    
    var TaskPage: some View {
        VStack(spacing: 0) {
            Separator(direction: .horizontal, color: .primary25, size: 1)
                .blur(radius: 0.2)
                .padding(2)
            
            TaskView(taskList: $mainViewModel.Task.Emergency,
                     title: Config.Task.Emergency.Title,
                     mainColor: Config.Task.Emergency.Color)
            
            Separator(direction: .horizontal, color: .primary25, size: 1)
                .blur(radius: 0.2)
                .padding(2)
            
            TaskView(taskList: $mainViewModel.Task.Processing,
                     title: Config.Task.Processing.Title,
                     mainColor: Config.Task.Processing.Color)
            
            Separator(direction: .horizontal, color: .primary25, size: 1)
                .blur(radius: 0.2)
                .padding(2)
            
            TaskView(taskList: $mainViewModel.Task.Todo,
                     title: Config.Task.Todo.Title,
                     mainColor: Config.Task.Todo.Color)
        }
    }
    
    var SettingPage: some View {
        SettingView()
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

