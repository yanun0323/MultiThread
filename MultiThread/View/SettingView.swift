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
    private let _SliderScale: CGFloat = 1
    private let _TextWidth: CGFloat = 120
    
    @State private var blockTitle = Config.Task.Block.Title
    @State private var emergencyTitle = Config.Task.Emergency.Title

    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                
                ThemeBlock
                    .padding(.top, 10)
                
                VStack(spacing: 0) {
                    WindowWidthBlock
                    WindowHeightBlock
                }

                PopoverWidthBlock

                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            HideBlockedBlock
                            HideEmergencyBlock
                        }
                        .frame(width: 130, alignment: .leading)
                        Spacer()
                        VStack(spacing: 10) {
                            PopoverClickBlock
                            PopoverKeepBlock
                                .foregroundColor(mainViewModel.Setting.PopoverClick ? .primary25 : .primary)
                                .disabled(mainViewModel.Setting.PopoverClick)
                        }
                        .frame(width: 155, alignment: .leading)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        SwapEmergencyBlockedBlock
                            .frame(width: 285, alignment: .leading)
                        Spacer()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        AutoArchiveBlock
                            .frame(width: 285, alignment: .leading)
                        Spacer()
                        Spacer()
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
        VStack(spacing: 5) {
            HStack {
                Text("Appreance")
                    .foregroundColor(.primary50)
                    .font(.caption)
                Spacer()
            }.padding(.horizontal)
            HStack(spacing: 20) {
                Spacer()
                VStack(spacing: 10) {
                    ButtonCustom(width: 60, height: 40, radius: 5) {
                        withAnimation(Config.Animation.Default) {
                            NSApp.appearance = nil
                            mainViewModel.Setting.Appearance = nil
                            appearance = 0
                        }
                    } content: {
                        ZStack {
                            LightImage
                                .mask {
                                    HStack(spacing: 0) {
                                        Rectangle()
                                            .frame(width: 29.5)
                                        Spacer()
                                    }
                                }
                            DarkImage
                                .offset(x: 30, y: 0)
                                .mask {
                                    HStack(spacing: 0) {
                                        Spacer()
                                        Rectangle()
                                            .frame(width: 29.5)
                                    }
                                }
                        }
                        .cornerRadius(5)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 3))
                            .opacity(appearance == 0 ? 1 : 0)
                    )
                    Text("System")
                }
                VStack(spacing: 10)  {
                    ButtonCustom(width: 60, height: 40, radius: 5) {
                        withAnimation(Config.Animation.Default) {
                            NSApp.appearance = NSAppearance(named: .aqua)
                            mainViewModel.Setting.Appearance = NSAppearance(named: .aqua)
                            appearance = 1
                        }
                    } content: {
                        LightImage
                            .cornerRadius(5)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 3))
                            .opacity(appearance == 1 ? 1 : 0)
                )
                    Text("Light")
                }
                VStack(spacing: 10)  {
                    ButtonCustom(width: 60, height: 40, radius: 5) {
                        withAnimation(Config.Animation.Default) {
                            NSApp.appearance = NSAppearance(named: .darkAqua)
                            mainViewModel.Setting.Appearance = NSAppearance(named: .darkAqua)
                            appearance = 2
                        }
                    } content: {
                        DarkImage
                            .cornerRadius(5)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2.5))
                            .opacity(appearance == 2 ? 1 : 0)
                    )
                    Text("Dark")
                }
                Spacer()

            }
            .padding(.vertical)
            .background(Color.primary.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    var LightImage: some View {
        Image("Light")
            .resizable()
            .overlay {
                ZStack {
                    Rectangle()
                        .frame(height: 10)
                        .foregroundColor(Color.black.opacity(0.3))
                        .offset(x: 0, y: -20)
                    ZStack {
                        VStack {
                            HStack(spacing: 3) {
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 5, height: 5)
                                Circle()
                                    .foregroundColor(.yellow)
                                    .frame(width: 5, height: 5)
                                Circle()
                                    .foregroundColor(.green)
                                    .frame(width: 5, height: 5)
                                Spacer()
                            }
                            .padding(3)
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            Spacer()
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: 30)
                        }
                    }
                    .frame(width: 60, height: 40)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(5)
                    .offset(x: 10, y: 20)
                }
            }
            .clipShape(Rectangle())
    }
    
    var DarkImage: some View {
        Image("Dark")
            .resizable()
            .overlay {
                ZStack {
                    Rectangle()
                        .frame(height: 10)
                        .foregroundColor(Color.black.opacity(0.3))
                        .offset(x: 0, y: -20)
                    VStack {
                        HStack(spacing: 3) {
                            Circle()
                                .foregroundColor(.red)
                                .frame(width: 5, height: 5)
                            Circle()
                                .foregroundColor(.yellow)
                                .frame(width: 5, height: 5)
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 5, height: 5)
                            Spacer()
                        }
                        .padding(3)
                        Spacer()
                    }
                    .frame(width: 60, height: 40)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(5)
                    .offset(x: 10, y: 20)
                }
            }
            .clipShape(Rectangle())
    }
    
    var PopoverWidthBlock: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                Text("Popup Width")
                Text("\(Int(mainViewModel.Setting.PopoverWidth))")
                    .monospacedDigit()
            }
            .frame(width: _TextWidth, alignment: .leading)
            Slider(
                value: $mainViewModel.Setting.PopoverWidth,
                in: Config.Popover.MinWidth...Config.Popover.MaxWidth,
                step: 50
            )
            .frame(width: mainViewModel.Setting.WindowsWidth*_SliderScale - _TextWidth - 45)
            .foregroundColor(.accentColor)
        }
    }
    
    var PopoverClickBlock: some View {
        HStack(spacing: 10) {
            Toggle("", isOn: $mainViewModel.Setting.PopoverClick)
            Text("Click To Popup")
            Spacer()
        }
    }
    
    var PopoverKeepBlock: some View {
        HStack(spacing: 10) {
            Toggle("", isOn: $mainViewModel.Setting.PopoverAutoClose)
            Text("Auto Close Popup")
            Spacer()
        }
    }
    
    var HideBlockedBlock: some View {
        HStack(spacing: 10) {
            Toggle("", isOn: $mainViewModel.Setting.HideBlock)
            Text("Hide") + Text(" '\(blockTitle)'")
            Spacer()
        }
    }
    
    var HideEmergencyBlock: some View {
        HStack(spacing: 10) {
            Toggle("", isOn: $mainViewModel.Setting.HideEmergency)
            Text("Hide") + Text(" '\(Config.Task.Emergency.Title)'")
            Spacer()
        }
    }
    
    var SwapEmergencyBlockedBlock: some View {
        HStack(spacing: 10) {
            Toggle("", isOn: $mainViewModel.Setting.SwapEmergencyBlock)
            Text("Swap") +
            Text(" '\(Config.Task.Emergency.Title)'") +
            Text(" '\(Config.Task.Block.Title)'")
            Spacer()
        }
    }
    
    var AutoArchiveBlock: some View {
        HStack(spacing: 10) {
            Toggle("", isOn: $mainViewModel.Setting.AutoArchive)
            Text("Auto Archive Completed Tasks")
            Spacer()
        }
    }
    
    var WindowWidthBlock: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                Text("App Width")
                Text("\(Int(windowWidth))")
                    .monospacedDigit()
            }
            .frame(width: _TextWidth, alignment: .leading)
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
            .frame(width: mainViewModel.Setting.WindowsWidth*_SliderScale - _TextWidth - 45)
            .foregroundColor(.accentColor)
        }
    }
    
    var WindowHeightBlock: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                Text("App Height")
                Text("\(Int(mainViewModel.Setting.WindowsHeight))")
                    .monospacedDigit()
            }
            .frame(width: _TextWidth, alignment: .leading)
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
            .frame(width: mainViewModel.Setting.WindowsWidth*_SliderScale - _TextWidth - 45)
            .foregroundColor(.accentColor)
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
                ButtonCustom(width: 70, height: 15) {
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
            .environment(\.locale, .init(identifier: "en_US"))
        
        
        SettingView()
            .frame(
                width: CGFloat(MainViewModel().Setting.WindowsWidth),
                height: CGFloat(MainViewModel().Setting.WindowsHeight)
            )
            .environmentObject(Mock.mainViewModel)
            .preferredColorScheme(.dark)
    }
}
