//
//  TaskView.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import Foundation
import SwiftUI
import UIComponent

struct TaskRow: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @Environment(\.openURL) private var openURL
    @Binding var userTask: UserTask
    @State var color: Color
    @State var input: UserTask = UserTask(title: "")
    @State private var detail = false
    @State private var linked = false
    
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
            Block(width: 10)
            
            PopoverTrigerBlock
        }
        .frame(height: 30)
        .lineLimit(1)
        .truncationMode(.tail)
        .background(.background)
        .onChange(of: input.title) { _ in
            userTask.title = input.title
        }
        .onChange(of: input.note) { _ in
            userTask.note = input.note
            linked = IsLink(input.note)
        }
        .onChange(of: input.other) { _ in
            userTask.other = input.other
        }
        .onAppear {
            input = userTask
            linked = IsLink(input.note)
        }
    }
}

// MARK: View Block

extension TaskRow {
    var TitleRowBlock: some View {
        HStack(spacing: 0) {
            Block(width: 5)
            
            TextField("輸入標題...", text: $input.title)
                .font(.system(size: 14, weight: .light, design: .default))
                .lineLimit(1)
                .textFieldStyle(.plain)
                .onSubmit {
                    print("OnSubmit")
                    userTask.title = input.title
                }
            
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

            TextField("輸入備註...", text: $input.note)
                .foregroundColor(.primary75)
                .font(.system(size: 10, weight: .thin, design: .default))
                .frame(height: 10)
                .lineLimit(1)
                .textFieldStyle(.plain)
                .onSubmit {
                    print("OnSubmit")
                    userTask.note = input.note
                    linked = IsLink(userTask.note)
                }
        }
    }
    
    var PopoverTrigerBlock: some View {
        Image(systemName: "chevron.right")
            .opacity(0.5)
            .onHover(perform: { value in
                detail = mainViewModel.Setting.PopoverKeep ? true : value
            })
            .popover(isPresented: $detail, arrowEdge: .trailing) {
                ZStack {
                    TextEditor(text: $input.other)
                        .font(.system(size: 14, weight: .thin, design: .default))
                        .background(.clear)
                        .frame(width: mainViewModel.Setting.PopoverWidth,
                               height: CGFloat((input.other.filter { $0 == "\n" }.count+1) * (14+3)),
                               alignment: .leading)
//                        .onChange(of: other) { value in
//                            userTask.other = value
//                            print("OnChange - \(userTask.other)")
//                        }
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
//                .onDisappear {
//                    print("OnDisappear")
//                    userTask.other = other
//                }
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
        TaskRow(userTask: .constant(Mock.mainViewModel.Task.Todo[0]), color: .blue)
            .frame(width: 350)
            .preferredColorScheme(.light)
        
        TaskRow(userTask: .constant(Mock.mainViewModel.Task.Todo[2]), color: .blue)
            .frame(width: 350)
            .preferredColorScheme(.light)
            
        TaskRow(userTask: .constant(Mock.mainViewModel.Task.Todo[0]), color: .blue)
            .frame(width: 350)
            .preferredColorScheme(.dark)
    }
}
