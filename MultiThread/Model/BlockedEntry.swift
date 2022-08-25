//
//  BlockEntry.swift
//  MultiThread
//
//  Created by YanunYang on 2022/8/3.
//

import CoreData

public class BlockedEntry: NSManagedObject, DataEntry {
    @NSManaged public var id: UUID
    @NSManaged public var index: Int64
    @NSManaged public var title: String
    @NSManaged public var note: String
    @NSManaged public var other: String
    @NSManaged public var deadline: Date?
    @NSManaged public var complete: Bool
}

// MARK: Function
extension BlockedEntry {
}
