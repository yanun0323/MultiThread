//
//  TodoView.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import SwiftUI
import UIComponent
import AppKit

struct TaskView<T>: View where T: NSManagedObject & DataEntry {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.locale) private var locale
    @EnvironmentObject private var mainViewModel: MainViewModel
    @Binding var taskList: [UserTask]
    @State var title: String
    @State var mainColor: Color
    @State var type: TaskType
    @State private var hovered: Bool = false
    
    @State private var DatabaseTaskRowTrigger: Int = 0
    
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.index) ])
    private var emergencyEntry: FetchedResults<EmergencyEntry>
    
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.index) ])
    private var processingEntry: FetchedResults<ProcessingEntry>
    
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.index) ])
    private var todoEntry: FetchedResults<TodoEntry>
    
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.index) ])
    private var blockedEntry: FetchedResults<BlockedEntry>
    
    var body: some View {
        HStack(spacing: 0) {
            LeftbarBlock
            TaskListBlock
        }
        .padding(5)
        .onAppear {
            RefreshFromDatabase()
        }
    }
    
}

// MARK: View Block
extension TaskView {
    var LeftbarBlock: some View {
        VStack(spacing: 5) {
            if locale.description.split(separator: "_")[0].contains("en") {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.thin)
                        .foregroundColor(.primary75)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .fixedSize()
                        .frame(height: 25)
                        .rotationEffect(Angle(degrees: 90), anchor: .bottomLeading)
                        .multilineTextAlignment(.leading)
                        .offset(x: 0, y: -25)
                }
                .frame(
                    width: 25,
                    height: mainViewModel.Setting.WindowsHeight/count - 65,
                    alignment: .topLeading
                )
                .clipped()
            } else {
                Text(title)
                    .font(.title)
                    .fontWeight(.thin)
                    .frame(width: 25)
                    .minimumScaleFactor(1)
            }
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
            } else {
                List {
                    ListExistBlock
                        .onInsert(of: ["UTType.SwiftUIReorderData"], perform: InserAction(_:_:))
                        .animation(.none, value: taskList)
                }
                .transition(.opacity)
                .listStyle(.plain)
                .background(.clear)
            }
        }
        .animation(Config.Animation.Default, value: taskList.count)
    }
    
    var CountAndCreaterBlock: some View {
        ZStack {
            if hovered || taskList.isEmpty {
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
        ButtonCustom(width: 25, height: 22, action: action) {
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
            TaskRow(userTask: task,
                    title: task.title,
                    note: task.note,
                    other: task.other,
                    color: mainColor,
                    trigger: $DatabaseTaskRowTrigger)
                .onDrag {
                    return NSItemProvider(object: SwiftUIListReorder(task))
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
                    Button {
                        withAnimation(Config.Animation.Default) {
                            DispatchQueue.main.async {
                            }
                        }
                    } label: {
                        Text("Archive Task")
                    }
                    Button{
                        withAnimation(Config.Animation.Default) {
                            DispatchQueue.main.async {
                                taskList.removeAll(where: { $0.id == task.id })
                                DeleteFromDatabase(task)
                            }
                        }
                    } label: {
                        Text("Delete Task")
                            .foregroundColor(.red)
                    }
                }
                .onChange(of: DatabaseTaskRowTrigger) { _ in
                    #if DEBUG
                    print("onChange - task")
                    #endif
                    DispatchQueue.main.async {
                        UpdateDatabase()
                    }
                }
        }
    }
    
    var ListEmptyBlock: some DynamicViewContent {
        ForEach(0...0, id: \.self) { text in
            HStack {
                Spacer()
                Text("No task here")
                    .font(.title2)
                    .fontWeight(.ultraLight)
                    .foregroundColor(.primary25)
                Spacer()
            }
        }
    }
}

// MARK: Property
extension TaskView {
    var count: Double {
        var c: Double = 4
        if mainViewModel.Setting.HideBlock { c = 3 }
        if mainViewModel.Setting.HideEmergency { c = 2 }
        return c
    }
}


// MARK: Function
extension TaskView {
    
    func CreateAction() {
        withAnimation(Config.Animation.Default) {
            DispatchQueue.main.async {
                let newTask = UserTask()
                taskList.append(newTask)
                CreateDatabaseFrom(newTask)
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
                    
                guard let removed = RemoveFromTask(id: recoder.userTask.id) else {
                    return
                }
                
                if taskList.isEmpty {
                    DispatchQueue.main.async {
                        taskList.append(removed)
                        CreateDatabaseFrom(removed)
                        UpdateDatabase()
                    }
                } else {
                    DispatchQueue.main.async {
                        taskList.insert(removed, at: destination)
                        CreateDatabaseFrom(removed)
                        UpdateDatabase()
                    }
                }
                
            }
        }
    }
    
    func GenUserTaskFrom(_ entries: FetchedResults<EmergencyEntry>) -> [UserTask] {
        var result: [UserTask] = []
        for entry in entries {
            let userTask = UserTask()
            userTask.id = entry.id
            userTask.title = entry.title
            userTask.note = entry.note
            userTask.other = entry.other
            userTask.deadline = entry.deadline
            userTask.complete = entry.complete
            result.append(userTask)
        }
        return result
    }
    
    func GenUserTaskFrom(_ entries: FetchedResults<ProcessingEntry>) -> [UserTask] {
        var result: [UserTask] = []
        for entry in entries {
            let userTask = UserTask()
            userTask.id = entry.id
            userTask.title = entry.title
            userTask.note = entry.note
            userTask.other = entry.other
            userTask.deadline = entry.deadline
            userTask.complete = entry.complete
            result.append(userTask)
        }
        return result
    }
    
    func GenUserTaskFrom(_ entries: FetchedResults<TodoEntry>) -> [UserTask] {
        var result: [UserTask] = []
        for entry in entries {
            let userTask = UserTask()
            userTask.id = entry.id
            userTask.title = entry.title
            userTask.note = entry.note
            userTask.other = entry.other
            userTask.deadline = entry.deadline
            userTask.complete = entry.complete
            result.append(userTask)
        }
        return result
    }
    
    func GenUserTaskFrom(_ entries: FetchedResults<BlockedEntry>) -> [UserTask] {
        var result: [UserTask] = []
        for entry in entries {
            let userTask = UserTask()
            userTask.id = entry.id
            userTask.title = entry.title
            userTask.note = entry.note
            userTask.other = entry.other
            userTask.deadline = entry.deadline
            userTask.complete = entry.complete
            result.append(userTask)
        }
        return result
    }
    
    func RefreshFromDatabase() {
        mainViewModel.Task.Emergency = GenUserTaskFrom(emergencyEntry)
        mainViewModel.Task.Processing = GenUserTaskFrom(processingEntry)
        mainViewModel.Task.Todo = GenUserTaskFrom(todoEntry)
        mainViewModel.Task.Blocked = GenUserTaskFrom(blockedEntry)
        #if DEBUG
        print("Done! - RefreshFromDatabase")
        #endif
    }
    
    func DeleteFromDatabase(_ userTask: UserTask) {
        #if DEBUG
        print("Start - DeleteFromDatabase")
        #endif
        do{
            for entry in emergencyEntry {
                if entry.id != userTask.id { continue }
                context.delete(entry)
                try context.save()
                #if DEBUG
                print("Saved! - DeleteFromDatabase")
                #endif
                return
            }
            for entry in processingEntry {
                if entry.id != userTask.id { continue }
                context.delete(entry)
                try context.save()
                #if DEBUG
                print("Saved! - DeleteFromDatabase")
                #endif
                return
            }
            for entry in todoEntry {
                if entry.id != userTask.id { continue }
                context.delete(entry)
                try context.save()
                #if DEBUG
                print("Saved! - DeleteFromDatabase")
                #endif
                return
            }
            for entry in blockedEntry {
                if entry.id != userTask.id { continue }
                context.delete(entry)
                try context.save()
                #if DEBUG
                print("Saved! - DeleteFromDatabase")
                #endif
                return
            }
            #if DEBUG
            print("Not Save! - DeleteFromDatabase")
            #endif
        } catch {
            print(error)
        }
    }
    
    func UpdateDatabase() {
        
        for index in 0 ..< emergencyEntry.count {
            let task = mainViewModel.Task.Emergency[index]
            let entry = emergencyEntry[index]
            entry.index = Int64(index)
            entry.id = task.id
            entry.title = task.title
            entry.note = task.note
            entry.other = task.other
            entry.deadline = task.deadline
            entry.complete = task.complete
        }
        
        for index in 0 ..< processingEntry.count {
            let task = mainViewModel.Task.Processing[index]
            let entry = processingEntry[index]
            entry.index = Int64(index)
            entry.id = task.id
            entry.title = task.title
            entry.note = task.note
            entry.other = task.other
            entry.deadline = task.deadline
            entry.complete = task.complete
        }
        
        for index in 0 ..< todoEntry.count {
            let task = mainViewModel.Task.Todo[index]
            let entry = todoEntry[index]
            entry.index = Int64(index)
            entry.id = task.id
            entry.title = task.title
            entry.note = task.note
            entry.other = task.other
            entry.deadline = task.deadline
            entry.complete = task.complete
        }
        
        for index in 0 ..< blockedEntry.count {
            let task = mainViewModel.Task.Blocked[index]
            let entry = blockedEntry[index]
            entry.index = Int64(index)
            entry.id = task.id
            entry.title = task.title
            entry.note = task.note
            entry.other = task.other
            entry.deadline = task.deadline
            entry.complete = task.complete
        }
        
        do {
            try context.save()
            #if DEBUG
            print("Saved! - UpdateDatabase")
            #endif
        } catch {
            print(error)
        }
    }
    
    func CreateDatabaseFrom(_ userTask: UserTask) {
        switch type {
        case .Emergency:
            let newItem = EmergencyEntry(context: context)
            newItem.index = Int64(emergencyEntry.count)
            newItem.id = userTask.id
            newItem.title = userTask.title
            newItem.note = userTask.note
            newItem.other = userTask.other
            newItem.deadline = userTask.deadline
            newItem.complete = userTask.complete
        case .Processing:
            let newItem = ProcessingEntry(context: context)
            newItem.index = Int64(processingEntry.count)
            newItem.id = userTask.id
            newItem.title = userTask.title
            newItem.note = userTask.note
            newItem.other = userTask.other
            newItem.deadline = userTask.deadline
            newItem.complete = userTask.complete
        case .Todo:
            let newItem = TodoEntry(context: context)
            newItem.index = Int64(todoEntry.count)
            newItem.id = userTask.id
            newItem.title = userTask.title
            newItem.note = userTask.note
            newItem.other = userTask.other
            newItem.deadline = userTask.deadline
            newItem.complete = userTask.complete
        case .Blocked:
            let newItem = BlockedEntry(context: context)
            newItem.index = Int64(blockedEntry.count)
            newItem.id = userTask.id
            newItem.title = userTask.title
            newItem.note = userTask.note
            newItem.other = userTask.other
            newItem.deadline = userTask.deadline
            newItem.complete = userTask.complete
        }
        
        do {
            try context.save()
            #if DEBUG
            print("Saved! - CreateDatabaseFrom")
            #endif
        } catch {
            print(error)
        }
    }
    
    func RemoveFromTask(id: UUID) -> UserTask? {
        if let index = mainViewModel.Task.Emergency.firstIndex(where: { $0.id == id }) {
            DeleteFromDatabase(mainViewModel.Task.Emergency[index])
            return mainViewModel.Task.Emergency.remove(at: index)
        }
        if let index = mainViewModel.Task.Processing.firstIndex(where: { $0.id == id }) {
            DeleteFromDatabase(mainViewModel.Task.Processing[index])
            return mainViewModel.Task.Processing.remove(at: index)
        }
        if let index = mainViewModel.Task.Todo.firstIndex(where: { $0.id == id }) {
            DeleteFromDatabase(mainViewModel.Task.Todo[index])
            return mainViewModel.Task.Todo.remove(at: index)
        }
        if let index = mainViewModel.Task.Blocked.firstIndex(where: { $0.id == id }) {
            DeleteFromDatabase(mainViewModel.Task.Blocked[index])
            return mainViewModel.Task.Blocked.remove(at: index)
        }
        return nil
    }
    
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView<EmergencyEntry>(taskList: .constant(Mock.mainViewModel.Task.Emergency),
                 title: Config.Task.Emergency.Title,
                 mainColor: Config.Task.Emergency.Color
                 ,type: .Emergency)
            .frame(width: 350,height: 110)
            .background(.background)
            .environmentObject(MainViewModel())
            .environment(\.locale, .init(identifier: "en"))
        
        
        TaskView<ProcessingEntry>(taskList: .constant(Mock.mainViewModel.Task.Processing),
                 title: Config.Task.Processing.Title,
                 mainColor: Config.Task.Processing.Color
                 ,type: .Processing)
            .frame(width: 350,height: 110)
            .background(.background)
            .environmentObject(MainViewModel())
            .environment(\.locale, .init(identifier: "en"))
    
        TaskView<TodoEntry>(taskList: .constant([]),
                 title: Config.Task.Todo.Title,
                 mainColor: Config.Task.Todo.Color
                 ,type: .Todo)
            .frame(width: 350,height: 150)
            .background(.background)
            .environmentObject(MainViewModel())
            .environment(\.locale, .init(identifier: "en"))
        
        TaskView<EmergencyEntry>(taskList: .constant(Mock.mainViewModel.Task.Emergency),
                 title: Config.Task.Emergency.Title,
                 mainColor: Config.Task.Emergency.Color
                 ,type: .Emergency)
            .frame(width: 350,height: 150)
            .background(.background)
            .preferredColorScheme(.dark)
            .environmentObject(MainViewModel())
        
        
        TaskView<ProcessingEntry>(taskList: .constant(Mock.mainViewModel.Task.Processing),
                 title: Config.Task.Processing.Title,
                 mainColor: Config.Task.Processing.Color
                 ,type: .Processing)
            .frame(width: 350,height: 150)
            .background(.background)
            .preferredColorScheme(.dark)
            .environmentObject(MainViewModel())
    
        TaskView<TodoEntry>(taskList: .constant([]),
                 title: Config.Task.Todo.Title,
                 mainColor: Config.Task.Todo.Color
                 ,type: .Todo)
            .frame(width: 350,height: 150)
            .background(.background)
            .preferredColorScheme(.dark)
            .environmentObject(MainViewModel())
    }
}
