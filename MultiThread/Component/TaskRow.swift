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
    @Binding var userTask: UserTask
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
            
            VStack(alignment: .leading, spacing: 0) {
                TitleRowBlock
                NoteRowBlock
            }
            Block(width: 5)
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
            
            TextField("輸入標題...", text: Binding(
                get: {
                    title
                }, set: { value in
                    if userTask.title != value {
                        userTask.title = value
                        trigger = (trigger+1)%10
                        print("Changed!")
                    }
                }))
                .font(.system(size: 14, weight: .light, design: .default))
                .lineLimit(1)
                .textFieldStyle(.plain)
            
            Spacer()
        }
    }
    
    var NoteRowBlock: some View {
        HStack(spacing: 0) {
            Block(width: 5)
            
            if linked {
                ButtonCustom(
                    width: 30, height: 11, color: .primary25, radius: 1,
                    border: 0, style: .linked
                ) {
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

            TextField("輸入備註...", text: Binding(
                get: {
                    note
                }, set: { value in
                    if userTask.note != value {
                        userTask.note = value
                        linked = IsLink(value)
                        trigger = (trigger+1)%10
                        print("Changed!")
                    }
                }))
                .foregroundColor(.primary75)
                .font(.system(size: 10, weight: .thin, design: .default))
                .frame(height: 10)
                .lineLimit(1)
                .textFieldStyle(.plain)
        }
    }
    
    var PopoverTrigerBlock: some View {
        Image(systemName: other.isEmpty ?  "bubble.right" : "bubble.right.fill")
            .foregroundColor( .primary50.opacity(0.75))
            .padding([.leading, .vertical], 5)
            .onHover(perform: { value in
                detail = mainViewModel.Setting.PopoverKeep ? true : value
            })
            .popover(isPresented: $detail, arrowEdge: .trailing) {
                ZStack {
                    TextEditor(text: Binding(
                        get: {
                            other
                        }, set: { value in
                            other = value
                            if userTask.other != value {
                                userTask.other = value
                                trigger = (trigger+1)%10
                                print("Changed!")
                            }
                        }))
                        .font(.system(size: 14, weight: .thin, design: .default))
                        .background(.clear)
                        .frame(width: mainViewModel.Setting.PopoverWidth,
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
        TaskRow(userTask: .constant(Mock.mainViewModel.Task.Todo[0]),
                title: Mock.mainViewModel.Task.Todo[0].title,
                note: Mock.mainViewModel.Task.Todo[0].note,
                other: Mock.mainViewModel.Task.Todo[0].other,
                color: .blue, trigger: .constant(0))
            .frame(width: 350)
            .preferredColorScheme(.light)
        
        TaskRow(userTask: .constant(Mock.mainViewModel.Task.Todo[2]),
                title: Mock.mainViewModel.Task.Todo[0].title,
                note: Mock.mainViewModel.Task.Todo[0].note,
                other: Mock.mainViewModel.Task.Todo[0].other,
                color: .blue, trigger: .constant(0))
            .frame(width: 350)
            .preferredColorScheme(.light)
            
        TaskRow(userTask: .constant(Mock.mainViewModel.Task.Todo[0]),
                title: Mock.mainViewModel.Task.Todo[0].title,
                note: Mock.mainViewModel.Task.Todo[0].note,
                other: Mock.mainViewModel.Task.Todo[0].other,
                color: .blue, trigger: .constant(0))
            .frame(width: 350)
            .preferredColorScheme(.dark)
    }
}
