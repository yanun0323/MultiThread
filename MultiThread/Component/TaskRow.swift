//
//  TaskView.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import SwiftUI
import UIComponent

struct TaskRow: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @Environment(\.openURL) private var openURL
    @Binding var userTask: UserTask
    @State var color: Color
    @State private var detail = false
    @State private var linked = false
    @State private var title = ""
    @State private var note = ""
    @State private var other = ""
    
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
        .onAppear {
            title = userTask.title
            note = userTask.note
            other = userTask.other
            linked = IsLink(note)
        }
    }
}

// MARK: View Block
extension TaskRow {
    
    var TitleRowBlock: some View {
        HStack(spacing: 0) {
            
            Block(width: 5)
            
            TextField("輸入標題...", text: $title)
                .font(.system(size: 14, weight: .light, design: .default))
                .lineLimit(1)
                .textFieldStyle(.plain)
                .onChange(of: title) { value in
                    userTask.title = value
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
                    let str = userTask.note.split(separator: " ")
                    let url = str.first(where: {$0.contains("https://")})
                    if let url = URL(string: url?.description ?? ""){
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

            TextField("輸入備註...", text: $note)
                .foregroundColor(.primary75)
                .font(.system(size: 10, weight: .thin, design: .default))
                .frame(height: 10)
                .lineLimit(1)
                .textFieldStyle(.plain)
                .onChange(of: note, perform: { value in
                    userTask.note = value
                    linked = IsLink(value)
                })
                .onSubmit {
                    userTask.note = note
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
                    TextEditor(text: $other)
                        .font(.system(size: 14, weight: .thin, design: .default))
                        .background(.clear)
                        .frame(width: mainViewModel.Setting.PopoverWidth,
                               height: CGFloat((other.filter({ $0 == "\n" }).count+1) * (14+3)),
                               alignment: .leading)
                        .onChange(of: other) { value in
                            userTask.other = value
                        }
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
