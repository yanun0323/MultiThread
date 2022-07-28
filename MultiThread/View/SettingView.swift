//
//  Setting.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/23.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @State private var popoverWidth: Double = 200
    @State private var windowsWidth: Double = 350
    @State private var windowsHeight: Double = 800
    
    var body: some View {
        
        VStack {
            PopoverWidthBlock
            PopoverKeepBlock
            Spacer()
            WindowWidthBlock
            WindowHeightBlock
            Text("＊更改視窗長寬高需重新啟動程式才會生效＊")
                .fontWeight(.thin)
                .foregroundColor(.red)
            Spacer()
        }
        .padding()
        .onAppear {
            popoverWidth = mainViewModel.Setting.PopoverWidth
            windowsWidth = Double(mainViewModel.Setting.WindowsWidth)
            windowsHeight = Double(mainViewModel.Setting.WindowsHeight)
        }
    }
}

// MARK: View Block
extension SettingView {
    
    var PopoverWidthBlock: some View {
        HStack(spacing: 10) {
            Text("備註視窗寬度")
                .fontWeight(.thin)
            Text("\(Int(popoverWidth))")
                .fontWeight(.thin)
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
            Text("備註視窗不自動隱藏")
                .fontWeight(.thin)
            Toggle("", isOn: $mainViewModel.Setting.PopoverKeep)
            Spacer()
        }
    }
    
    var WindowWidthBlock: some View {
        HStack(spacing: 10) {
            Text("視窗寬度")
                .fontWeight(.thin)
            Text("\(Int(windowsWidth))")
                .fontWeight(.thin)
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
                .fontWeight(.thin)
            Text("\(Int(windowsHeight))")
                .fontWeight(.thin)
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
    }
}
