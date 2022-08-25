//
//  Entry.swift
//  MultiThread
//
//  Created by YanunYang on 2022/8/24.
//

import CoreData

public protocol DataEntry {
    var id: UUID        { get set }
    var index: Int64    { get set }
    var title: String   { get set }
    var note: String    { get set }
    var other: String   { get set }
    var deadline: Date? { get set }
    var complete: Bool  { get set }
}
