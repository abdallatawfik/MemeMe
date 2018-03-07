//
//  Meme+CoreDataProperties.swift
//  MemeMe
//
//  Created by Abdalla Tawfik on 2/17/18.
//  Copyright © 2018 AT Apps. All rights reserved.
//
//

import Foundation
import CoreData


extension Meme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meme> {
        return NSFetchRequest<Meme>(entityName: "Meme")
    }

    @NSManaged public var bottomText: String?
    @NSManaged public var memedImage: NSData?
    @NSManaged public var originalImage: NSData?
    @NSManaged public var topText: String?
    @NSManaged public var createdAt: NSDate?

}
