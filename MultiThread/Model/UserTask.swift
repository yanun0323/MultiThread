//
//  Task.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import Foundation
import SwiftUI

final class UserTask: NSObject, Identifiable, Codable {
    var id: UUID = UUID()
    var title: String = ""
    var note: String = ""
    var other: String = ""
    var deadline: Date
    
    init(title: String, note: String = "", ohter: String = "", deadline: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.note = note
        self.other = ohter
        self.deadline = deadline ?? Date.Parse(date: "2000-01-01", layout: "yyyy-MM-dd")!
    }
}

// MARK: Dragable
//extension UserTask: NSItemProviderWriting {
//  static let typeIdentifier = "com.yanunyang.MultiTread.UserTask"
//
//  static var writableTypeIdentifiersForItemProvider: [String] {
//    [typeIdentifier]
//  }
//
//  func loadData(
//    withTypeIdentifier typeIdentifier: String,
//    forItemProviderCompletionHandler completionHandler:
//      @escaping (Data?, Error?) -> Void
//  ) -> Progress? {
//      print("Encode")
//    do {
//      let encoder = JSONEncoder()
//      encoder.outputFormatting = .prettyPrinted
//      completionHandler(try encoder.encode(self), nil)
//    } catch {
//      completionHandler(nil, error)
//    }
//
//    return nil
//  }
//}

// MARK: Dropable
//extension UserTask: NSItemProviderReading {
//  static var readableTypeIdentifiersForItemProvider: [String] {
//    [typeIdentifier]
//  }
//
//  static func object(
//    withItemProviderData data: Data,
//    typeIdentifier: String
//  ) throws -> UserTask {
//      print("Decode")
//    let decoder = JSONDecoder()
//    return try decoder.decode(UserTask.self, from: data)
//  }
//}

// MARK: DropDelegate
//struct UserTaskDropDelegate: DropDelegate {
//  @Binding var selected: UserTask?
//
//  func performDrop(info: DropInfo) -> Bool {
//    guard info.hasItemsConforming(to: [UserTask.typeIdentifier]) else {
//      return false
//    }
//
//    let itemProviders = info.itemProviders(for: [UserTask.typeIdentifier])
//    guard let itemProvider = itemProviders.first else {
//      return false
//    }
//
//    itemProvider.loadObject(ofClass: UserTask.self) { userTask, _ in
//      let userTask = userTask as? UserTask
//
//      DispatchQueue.main.async {
//          self.selected = userTask
//      }
//    }
//
//    return true
//  }
//}
