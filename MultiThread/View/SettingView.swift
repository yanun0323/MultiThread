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
    
    var body: some View {
        
        VStack {
            PopoverWidthBlock
            PopoverKeepBlock
            Spacer()
        }
        .padding()
        .onAppear {
            popoverWidth = mainViewModel.Setting.PopoverWidth
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
    
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .frame(width: 350, height: 500)
            .environmentObject(Mock.mainViewModel)
    }
}
