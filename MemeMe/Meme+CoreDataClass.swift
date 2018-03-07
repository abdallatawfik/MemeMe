//
//  Meme+CoreDataClass.swift
//  MemeMe
//
//  Created by Abdalla Tawfik on 2/17/18.
//  Copyright © 2018 AT Apps. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Meme)
public class Meme: NSManagedObject {
    
    convenience init(topText:String, bottomText:String, originalImage:Data, memedImage:Data, context:NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: CoreDataConstants.MemeEntityName, in: context) {
            self.init(entity: ent, insertInto: context)
            self.topText = topText
            self.bottomText = bottomText
            self.originalImage = NSData(data: originalImage)
            self.memedImage = NSData(data: memedImage)
            self.createdAt = NSDate()
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
