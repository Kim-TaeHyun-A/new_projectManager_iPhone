//
//  Entity+CoreDataProperties.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/19.
//
//

import Foundation
import CoreData

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var title: String?
    @NSManaged public var status: String?
    @NSManaged public var deadline: Date?
    @NSManaged public var body: String?
    @NSManaged public var id: UUID?

}

extension Project: Identifiable {

}
