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
    @State private var popoverWidth: Double = 200
    @State private var windowsWidth: Double = 350
    @State private var windowsHeight: Double = 800
    @State private var appearance: Int = 0
    
    var body: some View {
        
        VStack(spacing: 40) {
            
            ThemeBlock
                .padding(.vertical)
                .background(Color.primary.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            PopoverWidthBlock
            
            VStack(spacing: 0) {
                WindowWidthBlock
                WindowHeightBlock
                Text("＊視窗長寬需重新啟動程式才會生效＊")
                    .font(.system(size: 11, weight: .light, design: .default))
                    .foregroundColor(.red)
            }
            
            PopoverKeepBlock
            
            Spacer()
            
            Text("Version \(VERSION)")
                .font(.system(size: 14, weight: .light, design: .default))
                .foregroundColor(.primary25)
                .monospacedDigit()
        }
        .padding()
        .onAppear {
            popoverWidth = mainViewModel.Setting.PopoverWidth
            windowsWidth = Double(mainViewModel.Setting.WindowsWidth)
            windowsHeight = Double(mainViewModel.Setting.WindowsHeight)
            appearance = mainViewModel.Setting.AppearanceInt
        }
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
            Text("\(Int(popoverWidth))")
                .monospacedDigit()
            Slider(value: $popoverWidth, in: 100...500, step: 50) { changed in
                mainViewModel.Setting.PopoverWidth = popoverWidth
            }
            .foregroundColor(.accentColor)
            .padding(.horizontal)
        }
    }
    
    var PopoverKeepBlock: some View {
        HStack(spacing: 10) {
            Text("備註不自動隱藏")
            Toggle("", isOn: $mainViewModel.Setting.PopoverKeep)
            Spacer()
        }
    }
    
    var WindowWidthBlock: some View {
        HStack(spacing: 10) {
            Text("視窗寬度")
            Text("\(Int(windowsWidth))")
                .monospacedDigit()
            Slider(value: $windowsWidth, in: 350...500, step: 50) { changed in
                mainViewModel.Setting.WindowsWidth = Int(windowsWidth)
            }
            .foregroundColor(.accentColor)
            .padding(.horizontal)
        }
    }
    
    var WindowHeightBlock: some View {
        HStack(spacing: 10) {
            Text("視窗高度")
            Text("\(Int(windowsHeight))")
                .monospacedDigit()
            Slider(value: $windowsHeight, in: 400...1000, step: 100) { changed in
                mainViewModel.Setting.WindowsHeight = Int(windowsHeight)
            }
            .foregroundColor(.accentColor)
            .padding(.horizontal)
        }
    }
    
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .frame(width: 350, height: 500)
            .environmentObject(Mock.mainViewModel)
            .preferredColorScheme(.light)
        
        
        SettingView()
            .frame(width: 350, height: 500)
            .environmentObject(Mock.mainViewModel)
            .preferredColorScheme(.dark)
    }
}
