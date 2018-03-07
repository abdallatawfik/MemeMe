//
//  Model.swift
//  MemeMe
//
//  Created by Abdalla Tawfik on 2/17/18.
//  Copyright © 2018 AT Apps. All rights reserved.
//

import UIKit
import CoreData

class Model {
    
    // MARK: - Properties
    
    let coreDataStack = CoreDataStack(modelName: CoreDataConstants.ModelName)!
    
    // MARK: - Audio Record Management
    
    func addMeme(topText:String, bottomText:String, originalImage:Data, memedImage:Data) {
        _ = Meme(topText:topText, bottomText:bottomText, originalImage:originalImage, memedImage:memedImage, context:coreDataStack.context)
        try? coreDataStack.saveContext()
    }
    
    func deleteMeme(meme:Meme) {
        coreDataStack.context.delete(meme)
        try? coreDataStack.saveContext()
    }
    
    func getAllMemes() -> [Meme] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataConstants.MemeEntityName)
        
        var fetchedMemes = [Meme]()
        do {
            fetchedMemes = try coreDataStack.context.fetch(fetchRequest) as! [Meme]
        } catch {
            fatalError("Failed to fetch Memes: \(error)")
        }
        
        return fetchedMemes
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Model {
        struct Singleton {
            static var sharedInstance = Model()
        }
        return Singleton.sharedInstance
    }
}

