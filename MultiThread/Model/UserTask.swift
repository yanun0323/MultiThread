//
//  Task.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import Foundation
import SwiftUI

final class UserTask: NSObject, ObservableObject, Identifiable, Codable {
    @Published var id: UUID = UUID()
    @Published var title: String = ""
    @Published var note: String = ""
    @Published var other: String = ""
    @Published var deadline: Date? = nil
    
    init(title: String, note: String = "", ohter: String = "", deadline: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.note = note
        self.other = ohter
        self.deadline = deadline
    }
    
    enum CodingKeys: CodingKey {
        case id, title, note, other, deadline
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(note, forKey: .note)
        try container.encode(other, forKey: .other)
        try container.encode(deadline, forKey: .deadline)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        note = try container.decode(String.self, forKey: .note)
        other = try container.decode(String.self, forKey: .other)
        deadline = try container.decode(Date?.self, forKey: .deadline)
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
