//
//  UserTaskEntry.swift
//  MultiThread
//
//  Created by Yanun on 2022/7/24.
//

import Foundation

protocol IUserTask: Identifiable {
    var id: UUID { get set }
    var index: Int64 { get set }
    var title: String { get set }
    var note: String { get set }
    var other: String { get set }
    var deadline: Date? { get set }
}
