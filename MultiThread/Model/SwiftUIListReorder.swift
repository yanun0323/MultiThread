//
//  SwiftUIListReorder.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/22.
//

import Foundation
import SwiftUI

final class SwiftUIListReorder: NSObject, NSItemProviderReading, NSItemProviderWriting, Codable, ObservableObject {
    static var readableTypeIdentifiersForItemProvider: [String] = ["com.apple.SwiftUI.listReorder"]
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> SwiftUIListReorder {
        let decoder = JSONDecoder()
        let reorderData = try decoder.decode(SwiftUIListReorder.self, from: data)
        return reorderData
    }
    
    static var writableTypeIdentifiersForItemProvider: [String] = ["com.apple.SwiftUI.listReorder"]
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(self)
            completionHandler(json, nil)
        } catch {
            print(error.localizedDescription)
            completionHandler(nil, error)
        }
        return nil
    }
    
    @Published var userTask: UserTask
    @Published var source: [UserTask]
    init(_ values: UserTask, _ source: [UserTask]) {
        self.userTask = values
        self.source = source
    }
    
    enum CodingKeys: CodingKey {
        case userTask, source
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(userTask, forKey: .userTask)
        try container.encode(source, forKey: .source)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userTask = try container.decode(UserTask.self, forKey: .userTask)
        source = try container.decode([UserTask].self, forKey: .source)
    }
    
}

//struct SwiftUIListReorderDropDelegate: DropDelegate {
//  @Binding var recoder: SwiftUIListReorder?
//
//  func performDrop(info: DropInfo) -> Bool {
//    guard info.hasItemsConforming(to: ["com.apple.SwiftUI.listReorder"]) else {
//      return false
//    }
//
//    let itemProviders = info.itemProviders(for: ["com.apple.SwiftUI.listReorder"])
//    guard let itemProvider = itemProviders.first else {
//      return false
//    }
//
//    itemProvider.loadObject(ofClass: SwiftUIListReorder.self) { recoder, _ in
//      let recoder = recoder as? SwiftUIListReorder
//
//      DispatchQueue.main.async {
//          self.recoder = recoder
//      }
//    }
//
//    return true
//  }
//}

