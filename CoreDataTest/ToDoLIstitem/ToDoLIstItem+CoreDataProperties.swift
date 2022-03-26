//
//  ToDoLIstItem+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Pablo Gatgens on 3/26/22.
//
//

import Foundation
import CoreData


extension ToDoLIstItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoLIstItem> {
        return NSFetchRequest<ToDoLIstItem>(entityName: "ToDoLIstItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoLIstItem : Identifiable {

}
