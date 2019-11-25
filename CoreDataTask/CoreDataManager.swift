//
//  CoreDataManager.swift
//  CoreDataTask
//
//  Created by Лада on 23/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageList")
        container.loadPersistentStores(completionHandler: { (images, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()
    
    var context: NSManagedObjectContext!
    var lists = [OneImage]()
    let request: NSFetchRequest<OneImage> = OneImage.fetchRequest()
    
    func saveContext (image: ImageViewModel) {
        let savingImage = OneImage(context: context)
        let imgData = image.image.pngData()
        savingImage.name = image.descrip
        savingImage.image = NSData(data: imgData!) as NSData
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllElements () {
        do {
            lists = try context.fetch(request)
            for data in lists {
                context.delete(data)
            }
            
        } catch {
            print(error)
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData()-> [OneImage]{
        print("Fetching Data..")
     
        do {
            lists = try context.fetch(request)
        } catch {
            print(error)
        }
        
        return lists
    }
}
