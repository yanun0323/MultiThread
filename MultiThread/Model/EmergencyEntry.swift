//
//  DatabaseUserTask.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/23.
//

import CoreData

// MARK: Function
extension EmergencyEntry {
    static func Create(_ context: NSManagedObjectContext, _ userTask: UserTask, _ index: Int) throws {
        let newData = EmergencyEntry(context: context)
        newData.id = userTask.id
        newData.index = Int64(index)
        newData.title = userTask.title
        newData.note = userTask.note
        newData.other = userTask.other
        newData.deadline = userTask.deadline

        try context.save()
    }

    static func Update(context: NSManagedObjectContext) {
        
    }

    static func Delete(context: NSManagedObjectContext, index: Int) {
    }

    //    func addItem() {
    //        let newData = UserTask(context: context)
    //        newData.Style = input.Style
    //        newData.name = input.Name
    //        newData.content = input.Content
    //        newData.order = input.Order
    //
    //        do {
    //            try context.save()
    //        } catch {
    //            print(error)
    //        }
    //
    //        input = UserButton()
    //    }
    //
    //    func deleteTask(index: Int) {
    //        let itemToDelete = buttons[index]
    //        context.delete(itemToDelete)
    //
    //        DispatchQueue.main.async {
    //            do{
    //                try context.save()
    //            } catch {
    //                print(error)
    //            }
    //        }
    //    }
}
