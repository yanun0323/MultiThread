//
//  TaskView.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import Foundation
import SwiftUI
import UIComponent

@MainActor
struct TaskRow: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @Environment(\.openURL) private var openURL
    @StateObject var userTask: UserTask
    @State var title: String
    @State var note: String
    @State var other: String

    @State var color: Color
    @State private var detail = false
    @State private var linked = false
    
    @Binding var trigger: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .foregroundColor(color)
                .frame(width: 5)
                .padding(.vertical, 1)
                .opacity(userTask.complete ? 0.2 : 1)
            
            VStack(alignment: .leading, spacing: 0) {
                TitleRowBlock
                NoteRowBlock
            }
            Block(width: 5)
            CompleteBlock
            PopoverTrigerBlock
        }
        .frame(height: 30)
        .lineLimit(1)
        .truncationMode(.tail)
        .background(.background)
        .onAppear {
            linked = IsLink(note)
        }
    }
}

// MARK: View Block

extension TaskRow {
    var TitleRowBlock: some View {
        HStack(spacing: 0) {
            Block(width: 5)
            
            TextField("Title...", text: Binding(
                get: {
                    title
                }, set: { value in
                    if userTask.title != value {
                        title = value
                        userTask.title = value
                        trigger = (trigger+1)%10
                        #if DEBUG
                        print("Changed!")
                        #endif
                    }
                }))
                .font(.system(size: 14, weight: .light, design: .default))
                .lineLimit(1)
                .textFieldStyle(.plain)
                .disabled(userTask.complete)
            
            Spacer()
        }
    }
    
    var NoteRowBlock: some View {
        HStack(spacing: 0) {
            Block(width: 5)
            
            if linked {
                ButtonCustom(width: 30, height: 11, color: .primary25, radius: 1) {
                    let str = userTask.note.split(separator: " ").first(where: { $0.contains("https://") })
                    guard let separated = str?.split(separator: "/", maxSplits: 1, omittingEmptySubsequences: true) else { return }
                    if separated.isEmpty { return }
                    guard var component = URLComponents(string: separated[0].description) else { return }
                    if separated.count > 0 {
                        component.path = separated[1].description
                    }
                    if let url = component.url {
                        openURL(url)
                    }
                } content: {
                    Text("link")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                }
                .padding(.trailing, 5)
            }

            TextField("Link or Description...", text: Binding(
                get: {
                    note
                }, set: { value in
                    if userTask.note != value {
                        note = value
                        userTask.note = value
                        linked = IsLink(value)
                        trigger = (trigger+1)%10
                        #if DEBUG
                        print("Changed!")
                        #endif
                    }
                }))
                .foregroundColor(.primary75)
                .font(.system(size: 10, weight: .thin, design: .default))
                .frame(height: 10)
                .lineLimit(1)
                .textFieldStyle(.plain)
                .disabled(userTask.complete)
        }
    }
    
    var CompleteBlock: some View {
        ButtonCustom(width: 25, height: 25, color: .clean, radius: 5) {
            withAnimation(Config.Animation.Default) {
                userTask.complete.toggle()
                trigger = (trigger+1)%10
            }
        } content: {
            Image(systemName: userTask.complete ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundColor(.primary50.opacity( userTask.complete ? 0.3 : 0.75))
        }
    }
    
    var PopoverTrigerBlock: some View {
        ButtonCustom(width: 25, height: 25, color: .clean, radius: 5) {
            if mainViewModel.Setting.PopoverClick {
                detail = true
            }
        } content: {
            Image(systemName: other.isEmpty ?  "bubble.middle.bottom" : "bubble.middle.bottom.fill")
                .foregroundColor(.primary50.opacity( userTask.complete ? 0.3 : 0.75))
        }
        .onHover(perform: { value in
            if mainViewModel.page == -1 {
                detail = false
                return
            }
            
            if mainViewModel.Setting.PopoverClick {
                detail = detail
                return
            }
            
            if mainViewModel.Setting.PopoverAutoClose {
                detail = value
                return
            }
            detail = true
            
        })
        .popover(isPresented: $detail, arrowEdge: .trailing) {
            ZStack {
                TextEditor(text: userTask.complete ? .constant(other) : Binding(
                    get: {
                        other
                    }, set: { value in
                        other = value
                        if userTask.other != value {
                            userTask.other = value
                            trigger = (trigger+1)%10
                            #if DEBUG
                            print("Changed!")
                            #endif
                        }
                    }))
                    .font(.system(size: 14, weight: .thin, design: .default))
                    .background(.clear)
                    .frame(width: CGFloat(mainViewModel.Setting.PopoverWidth),
                           height: CGFloat((other.filter { $0 == "\n" }.count+1) * (14+3)),
                           alignment: .leading)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
    }
}

// MARK: Function

extension TaskRow {
    func IsLink(_ str: String) -> Bool {
        str.contains("https://")
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Row(.red)
            Row(.yellow)
            Row(.blue)
            Row(.gray)
        }
        .frame(width: 300)
        .padding()
        .preferredColorScheme(.light)
        .background(.background)
        
        VStack {
            Row(.red)
            Row(.yellow)
            Row(.blue)
            Row(.gray)
        }
        .frame(width: 300)
        .padding()
        .preferredColorScheme(.dark)
        .background(.background)
    }
    
    @MainActor
    static func Row(_ color: Color) -> some View {
        TaskRow(
            userTask: UserTask(),
            title: "",
            note: "",
            other: "",
            color: color,
            trigger: .constant(0))
        .environment(\.locale, .init(identifier: "en_US"))
    }
}
