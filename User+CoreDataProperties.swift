//
//  User+CoreDataProperties.swift
//  CoreDataAsyncExample
//
//  Created by Marius Landwehr on 06.02.17.
//  Copyright © 2017 Marius Landwehr. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var gender: String?
    @NSManaged public var title: String?
    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var street: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var postcode: String?
    @NSManaged public var img: String?

}
