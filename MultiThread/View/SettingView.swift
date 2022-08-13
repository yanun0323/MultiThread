//
//  Setting.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/23.
//

import SwiftUI
import UIComponent

let VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

struct SettingView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @Environment(\.openURL) private var openURL
    @State private var appearance: Int = 0
    @State private var hideBlock: Bool = false
    @State private var hideEmergency: Bool = false
    @State private var windowWidth: CGFloat = Config.Windows.MinWidth

    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                
                ThemeBlock
                    .padding(.vertical)
                    .background(Color.primary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(spacing: 0) {
                    WindowWidthBlock
                    WindowHeightBlock
                }

                PopoverWidthBlock

                HStack {
                    VStack(spacing: 10) {
                        HideBlockedBlock
                        HideEmergencyBlock
                    }
                    VStack(spacing: 10) {
                        PopoverClickBlock
                        PopoverKeepBlock
                            .foregroundColor(mainViewModel.Setting.PopoverClick ? .primary25 : .primary)
                            .disabled(mainViewModel.Setting.PopoverClick)
                    }
                }
                Spacer()
                VersionBlock
            }
            .frame(height: mainViewModel.Setting.WindowsHeight - 40)
            .padding(.horizontal)
            .onAppear {
                appearance = mainViewModel.Setting.AppearanceInt
                hideBlock = mainViewModel.Setting.HideBlock
                hideEmergency = mainViewModel.Setting.HideEmergency
                windowWidth = mainViewModel.Setting.WindowsWidth
            }
        }
        .frame(height: mainViewModel.Setting.WindowsHeight - 40)
        
    }
}

// MARK: View Block
extension SettingView {
    
    var ThemeBlock: some View {
        HStack(spacing: 20) {
            
            Spacer()
            
            Text("外觀")
            
            Block(width: 10, height: 10)
            
            VStack {
                ButtonCustom(width: 40, height: 40, radius: 5, border: 0) {
                    withAnimation(Config.Animation.Default) {
                        NSApp.appearance = nil
                        mainViewModel.Setting.Appearance = nil
                        appearance = 0
                    }
                } content: {
                    Image(systemName: "macwindow.on.rectangle")
                        .font(.title)
                        .padding(5)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 1.5))
                        .opacity(appearance == 0 ? 1 : 0)
                )
                Text("系統")
            }
            
            VStack {
                ButtonCustom(width: 40, height: 40, radius: 5, border: 0) {
                    withAnimation(Config.Animation.Default) {
                        NSApp.appearance = NSAppearance(named: .aqua)
                        mainViewModel.Setting.Appearance = NSAppearance(named: .aqua)
                        appearance = 1
                    }
                } content: {
                    Image(systemName: "sun.max")
                        .font(.title)
                        .padding(5)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 1.5))
                        .opacity(appearance == 1 ? 1 : 0)
            )
                Text("淺色")
            }
            
            VStack {
                ButtonCustom(width: 40, height: 40, radius: 5, border: 0) {
                    withAnimation(Config.Animation.Default) {
                        NSApp.appearance = NSAppearance(named: .darkAqua)
                        mainViewModel.Setting.Appearance = NSAppearance(named: .darkAqua)
                        appearance = 2
                    }
                } content: {
                    Image(systemName: "moon")
                        .font(.title)
                        .padding(5)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 1.5))
                        .opacity(appearance == 2 ? 1 : 0)
                )
                Text("深色")
            }
            Spacer()

        }
    }
    
    var PopoverWidthBlock: some View {
        HStack(spacing: 10) {
            Text("備註寬度")
            Text("\(Int(mainViewModel.Setting.PopoverWidth))")
                .monospacedDigit()
            Slider(
                value: $mainViewModel.Setting.PopoverWidth,
                in: Config.Popover.MinWidth...Config.Popover.MaxWidth,
                step: 50
            )
            .frame(width: mainViewModel.Setting.WindowsWidth*0.5)
            .foregroundColor(.accentColor)
            .padding(.horizontal)
        }
    }
    
    var PopoverClickBlock: some View {
        HStack(spacing: 10) {
            Spacer()
            Toggle("", isOn: $mainViewModel.Setting.PopoverClick)
            Text("以點擊展開備註")
            Spacer()
        }
    }
    
    var PopoverKeepBlock: some View {
        HStack(spacing: 10) {
            Spacer()
            Toggle("", isOn: $mainViewModel.Setting.PopoverKeep)
            Text("不自動收合備註")
            Spacer()
        }
    }
    
    var HideBlockedBlock: some View {
        HStack(spacing: 10) {
            Spacer()
            Toggle("", isOn: $mainViewModel.Setting.HideBlock)
            Text("隱藏'\(Config.Task.Block.Title)'欄位")
            Spacer()
        }
    }
    
    var HideEmergencyBlock: some View {
        HStack(spacing: 10) {
            Spacer()
            Toggle("", isOn: $mainViewModel.Setting.HideEmergency)
            Text("隱藏'\(Config.Task.Emergency.Title)'欄位")
            Spacer()
        }
    }
    
    var WindowWidthBlock: some View {
        HStack(spacing: 10) {
            Text("視窗寬度")
            Text("\(Int(windowWidth))")
                .monospacedDigit()
            Slider(
                value: $windowWidth,
                in: Config.Windows.MinWidth...Config.Windows.MaxWidth,
                step: 50
            ) { isEditing in
                if !isEditing {
                    mainViewModel.Setting.WindowsWidth = windowWidth
                    mainViewModel.PopOver.contentSize = CGSize(
                        width: mainViewModel.Setting.WindowsWidth,
                        height: mainViewModel.Setting.WindowsHeight
                    )
                }
            }
            .frame(width: mainViewModel.Setting.WindowsWidth*0.5)
            .foregroundColor(.accentColor)
            .padding(.horizontal)
        }
    }
    
    var WindowHeightBlock: some View {
        HStack(spacing: 10) {
            Text("視窗高度")
            Text("\(Int(mainViewModel.Setting.WindowsHeight))")
                .monospacedDigit()
            Slider(
                value: $mainViewModel.Setting.WindowsHeight,
                in: Config.Windows.MinHeight...Config.Windows.MaxHeight,
                step: 100
            ) { isEditing in
                if !isEditing {
                    mainViewModel.PopOver.contentSize = CGSize(
                        width: mainViewModel.Setting.WindowsWidth,
                        height: mainViewModel.Setting.WindowsHeight
                    )
                }
            }
            .frame(width: mainViewModel.Setting.WindowsWidth*0.5)
            .foregroundColor(.accentColor)
            .padding(.horizontal)
        }
    }
    
    var VersionBlock: some View {
        HStack {
            Spacer()
            Image("App")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                ButtonCustom(
                    width: 70, height: 15, style: .linked
                ) {
                    let link = "https://www.yanunyang.com/multithread"
                    guard let component = URLComponents(string: link) else { return }
                    if let url = component.url {
                        openURL(url)
                    }
                } content: {
                    Text("MultiTread")
                        .underline()
                        .foregroundColor(.blue)
                        .font(.system(size: 14, weight: .light, design: .default))
                }
                Text("Develop by Yanun Yang")
                    .font(.system(size: 10, weight: .light, design: .default))
                Spacer()
                Text("Version \(VERSION)")
                    .font(.system(size: 10, weight: .light, design: .default))
            }
            .frame(height: 60)
            .foregroundColor(.primary25)
            .monospacedDigit()
            Spacer()
        }
    }
    
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .frame(
                width: CGFloat(MainViewModel().Setting.WindowsWidth),
                height: CGFloat(MainViewModel().Setting.WindowsHeight)
            )
            .environmentObject(Mock.mainViewModel)
            .preferredColorScheme(.light)
        
        
        SettingView()
            .frame(
                width: CGFloat(MainViewModel().Setting.WindowsWidth),
                height: CGFloat(MainViewModel().Setting.WindowsHeight)
            )
            .environmentObject(Mock.mainViewModel)
            .preferredColorScheme(.dark)
    }
}
