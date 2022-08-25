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
    @Published var complete: Bool = false
    
    init(title: String = "", note: String = "", ohter: String = "", deadline: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.note = note
        self.other = ohter
        self.deadline = deadline
    }
    
    enum CodingKeys: CodingKey {
        case id, title, note, other, deadline, complete
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(note, forKey: .note)
        try container.encode(other, forKey: .other)
        try container.encode(deadline, forKey: .deadline)
        try container.encode(complete, forKey: .complete)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        note = try container.decode(String.self, forKey: .note)
        other = try container.decode(String.self, forKey: .other)
        deadline = try container.decode(Date?.self, forKey: .deadline)
        complete = try container.decode(Bool.self, forKey: .complete)
    }
    
}
