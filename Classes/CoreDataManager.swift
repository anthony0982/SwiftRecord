//
// CoreDataManager.swift
// SwiftRecord
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Damien Glancy <damien.glancy@icloud.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// This software started life as a direct-port to Swift of ObjectiveRecord by
// Marin Usalj (https://github.com/supermarin/ObjectiveRecord)
//

import Foundation
import CoreData

public class CoreDataManager: Equatable {
    
    public class var manager: CoreDataManager {
        struct Static {
            static let instance: CoreDataManager = CoreDataManager()
        }
        return Static.instance
    }
    
    //MARK: - Public Properties
    public lazy var managedObjectModel: NSManagedObjectModel? = {
        let modelURL = NSBundle(forClass: CoreDataManager.self).URLForResource(self.modelName, withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: modelURL!)!
    }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        return self.createPersistentStoreCoordinator(NSSQLiteStoreType, storeURL: self.sqliteStoreURL)
    }()
    
    public lazy var managedObjectContext: NSManagedObjectContext? = {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    //MARK: - Public Functions
    public func deleteStoreAndResetManager() {
        NSFileManager.defaultManager().removeItemAtURL(self.sqliteStoreURL, error: nil)
        #if DEBUG
            println("[SwiftRecord] Removed SQL store at \(self.sqliteStoreURL)")
        #endif
        
        CoreDataManager.manager.persistentStoreCoordinator = self.createPersistentStoreCoordinator(NSSQLiteStoreType, storeURL: self.sqliteStoreURL)
        #if DEBUG
            println("[SwiftRecord] Re-created SQL store at \(self.sqliteStoreURL)")
        #endif
        
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        CoreDataManager.manager.managedObjectContext = context
    }
    
    public func useInMemoryStore() {
        self.persistentStoreCoordinator = self.createPersistentStoreCoordinator(NSInMemoryStoreType, storeURL: nil)
    }
    
    public func saveContext() -> Bool {
        var result = false
        
        if let context = self.managedObjectContext {
            if context.hasChanges {
                var error: NSError?
                result = context.save(&error)
                if let localError = error {
                    println("[SwiftRecord] Unresolved error in saving context: \(localError), \(localError.userInfo)")
                }
            }
        }
        
        return result
    }
    
    //MARK: - Private Properties
    private lazy var appName: String = {
        return NSBundle(forClass: CoreDataManager.self).infoDictionary!["CFBundleName"] as String
    }()
    
    private lazy var databaseName: String = {
        return "\(self.appName).sqlite"
    }()
    
    private lazy var modelName: String = {
        return self.appName
    }()
    
    private lazy var sqliteStoreURL: NSURL = {
        let directory = self.isRunningOnOSX()! ? self.applicationSupportDirectory : self.applicationDocumentsDirectory
        self.createApplicationSupportDirIfRequired(directory)
        let url = directory.URLByAppendingPathComponent(self.databaseName)
        
        #if DEBUG
            println("[SWIFTRECORD] store url = \(url)")
        #endif
        
        return url
    }()
    
    //MARK: - Private Functions
    private func createPersistentStoreCoordinator(storeType: String, storeURL: NSURL?) -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        
        var error: NSError?
        coordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: options, error: &error)
        if let localError = error {
            println("[SWIFTRECORD] Error creating persistent store coordinator: \(localError), \(localError.userInfo)")
        }
        
        return coordinator
    }
    
    private func isRunningOnOSX() -> Bool? {
        #if os(OSX)
            return true
            #elseif os(iOS)
            return false
        #endif
    }
    
    //MARK: - Private SQLite location directory
    private lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as NSURL
        }()
    
    private lazy var applicationSupportDirectory: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as NSURL
        }()
    
    private func createApplicationSupportDirIfRequired(url: NSURL) {
        if !(NSFileManager.defaultManager().fileExistsAtPath(url.absoluteString!)) {
            NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
    }

}

public func == (lhs: CoreDataManager, rhs: CoreDataManager) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
