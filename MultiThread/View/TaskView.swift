//
//  TodoView.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import SwiftUI
import UIComponent
import AppKit

struct TaskView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var mainViewModel: MainViewModel
    @Binding var taskList: [UserTask]
    @State var title: String
    @State var mainColor: Color
    @State private var hovered: Bool = false
    
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.index) ])
    private var emergencyEntry: FetchedResults<EmergencyEntry>
    
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.index) ])
    private var processingEntry: FetchedResults<ProcessingEntry>
    
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.index) ])
    private var todoEntry: FetchedResults<TodoEntry>
    
    var body: some View {
        HStack(spacing: 0) {
            LeftbarBlock
            TaskListBlock
        }
        .padding(5)
    }
}

// MARK: View Block
extension TaskView {
    var LeftbarBlock: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.title)
                .fontWeight(.thin)
                .frame(width: 25)
            Spacer()
            CountAndCreaterBlock
        }
        .background(.background)
        .zIndex(2)
    }
    
    var TaskListBlock: some View {
        ZStack {
            if taskList.isEmpty {
                List {
                    ListEmptyBlock
                        .onInsert(of: ["UTType.SwiftUIReorderData"], perform: InserAction(_:_:))
                        .animation(.none, value: taskList)
                }
                .transition(.opacity)
                .listStyle(.plain)
                .background(.clear)
                .onTapGesture {
                    print("Tap List")
                }
            } else {
                List {
                    ListExistBlock
                        .onInsert(of: ["UTType.SwiftUIReorderData"], perform: InserAction(_:_:))
                        .animation(.none, value: taskList)
                }
                .transition(.opacity)
                .listStyle(.plain)
                .background(.clear)
                .onTapGesture {
                    print("Tap List")
                }
            }
        }
        .transition(.opacity)
        .onTapGesture {
            print("Tap ZStack")
        }
    }
    
    var CountAndCreaterBlock: some View {
        ZStack {
            if hovered {
                CreateButton {
                    CreateAction()
                }
                .transition(.opacity)
            } else {
                CountBlock
                    .transition(.opacity)
            }
        }
        .onHover { hovered in
            withAnimation(Config.Animation.Default) {
                self.hovered = hovered
            }
        }
    }
    
    func CreateButton(action: @escaping () -> Void) -> some View  {
        ButtonCustom(width: 25, action: action) {
            Text("+")
                .foregroundColor(mainColor)
                .font(.title)
                .fontWeight(.thin)
                .frame(width: 25)
                .lineLimit(1)
        }
    }
    
    var CountBlock: some View {
        Text("\(taskList.count)")
            .foregroundColor(mainColor)
            .font(.title2)
            .fontWeight(.thin)
            .frame(width: 25)
            .lineLimit(1)
    }
    
    var ListExistBlock: some DynamicViewContent {
        ForEach(taskList) { task in
            TaskRow(userTask: .constant(task),
                    title: task.title,
                    note: task.note,
                    other: task.other,
                    color: mainColor)
                .onDrag {
                    return NSItemProvider(object: SwiftUIListReorder(task, taskList))
                } preview: {
                    HStack {
                        Rectangle()
                            .foregroundColor(mainColor)
                            .frame(width: 3)
                        Text(task.title)
                            .font(.body)
                            .fontWeight(.light)
                        Spacer()
                    }
                    .background(.background)
                }
                .contextMenu {
                    Button("刪除") {
                        withAnimation(Config.Animation.Default) {
                            DispatchQueue.main.async {
                                taskList.removeAll(where: { $0.id == task.id })
                            }
                        }
                    }
                }
        }
    }
    
    var ListEmptyBlock: some DynamicViewContent {
        ForEach(["無\(title)項目"], id: \.self) { text in
            HStack {
                Spacer()
                Text(text)
                    .font(.title2)
                    .fontWeight(.ultraLight)
                    .foregroundColor(.primary25)
                Spacer()
            }
        }
    }
}


// MARK: Function
extension TaskView {
    
    func CreateAction() {
        withAnimation(Config.Animation.Default) {
            DispatchQueue.main.async {
                taskList.append(UserTask())
            }
        }
    }
    
    func InserAction(_ index: Int, _ providers: [NSItemProvider]) -> Void {
        for item in providers {
            item.loadObject(ofClass: SwiftUIListReorder.self) { recoder, error in
                if let error = error {
                    print(error)
                }
                guard let recoder = recoder as? SwiftUIListReorder else { return }
                    var destination = index
                    if taskList.contains(where: { $0.id == recoder.userTask.id })
                        && index >= taskList.count{
                        destination = taskList.count - 1
                    }
                    withAnimation(Config.Animation.Default) {
                        guard let removed = mainViewModel.RemoveFromTask(id: recoder.userTask.id) else {
                            return
                    }
                    if taskList.isEmpty {
                        DispatchQueue.main.async {
                            taskList.append(removed)
                            taskList = taskList
                        }
                    } else {
                        DispatchQueue.main.async {
                            taskList.insert(removed, at: destination)
                            taskList = taskList
                        }
                    }
                }
            }
        }
    }
    
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(taskList: .constant(Mock.mainViewModel.Task.Emergency),
                 title: Config.Task.Emergency.Title,
                 mainColor: Config.Task.Emergency.Color)
            .frame(width: 350,height: 150)
            .background(.background)
        
        
        TaskView(taskList: .constant(Mock.mainViewModel.Task.Processing),
                 title: Config.Task.Processing.Title,
                 mainColor: Config.Task.Processing.Color)
            .frame(width: 350,height: 150)
            .background(.background)
    
        TaskView(taskList: .constant([]),
                 title: Config.Task.Todo.Title,
                 mainColor: Config.Task.Todo.Color)
            .frame(width: 350,height: 150)
            .background(.background)
        
        TaskView(taskList: .constant(Mock.mainViewModel.Task.Emergency),
                 title: Config.Task.Emergency.Title,
                 mainColor: Config.Task.Emergency.Color)
            .frame(width: 350,height: 150)
            .background(.background)
            .preferredColorScheme(.dark)
        
        
        TaskView(taskList: .constant(Mock.mainViewModel.Task.Processing),
                 title: Config.Task.Processing.Title,
                 mainColor: Config.Task.Processing.Color)
            .frame(width: 350,height: 150)
            .background(.background)
            .preferredColorScheme(.dark)
    
        TaskView(taskList: .constant([]),
                 title: Config.Task.Todo.Title,
                 mainColor: Config.Task.Todo.Color)
            .frame(width: 350,height: 150)
            .background(.background)
            .preferredColorScheme(.dark)
    }
}
