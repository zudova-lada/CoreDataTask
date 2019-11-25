//
//  OneImage+CoreDataProperties.swift
//  CoreDataTask
//
//  Created by Лада on 25/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//
//

import Foundation
import CoreData


extension OneImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OneImage> {
        return NSFetchRequest<OneImage>(entityName: "OneImage")
    }

    @NSManaged public var image: NSData
    @NSManaged public var name: String?

}
