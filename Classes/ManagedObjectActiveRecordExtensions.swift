//
// NSManagedObjectActiveRecord.swift
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

extension NSManagedObject {
    //MARK: - Create
    public class func create() -> AnyObject {
        return createInContext(NSManagedObjectContext.defaultContext)
    }
    
    public class func createInContext(context: NSManagedObjectContext) -> AnyObject {
        return NSEntityDescription.insertNewObjectForEntityForName(self.entityName!, inManagedObjectContext: context)
    }
    
    public class func create(attributes: Dictionary<String, AnyObject>!, context: NSManagedObjectContext) -> AnyObject? {
        if let localAttributes = attributes {
            let entity: AnyObject = createInContext(context)
            //TODO
            
            return entity
        }
        
        return nil
    }
    
    //MARK: - Update
    public func update(attributes: Dictionary<String, AnyObject>) {
        
    }
    
    //MARK: - Delete
    public func delete() {
        managedObjectContext?.deleteObject(self)
    }
    
    public class func deleteAll() {
        deleteAllInContext(NSManagedObjectContext.defaultContext)
    }
    
    public class func deleteAllInContext(context: NSManagedObjectContext) {
        for object in allInContext(context)! {
            object.delete()
        }
    }
    
    //MARK: - Finders
    
    //MARK: All
    public class func all() -> Array<AnyObject>? {
        return allInContext(NSManagedObjectContext.defaultContext)
    }
    
    public class func allWithOrder(order: AnyObject) -> Array<AnyObject>? {
        return allInContext(NSManagedObjectContext.defaultContext, order: order)
    }
    
    public class func allInContext(context: NSManagedObjectContext) -> Array<AnyObject>? {
        return allInContext(context, order: nil)
    }
    
    public class func allInContext(context: NSManagedObjectContext, order: AnyObject!) -> Array<AnyObject>? {
        return fetch(nil, context: context, order: order, limit: nil)
    }

    //MARK: Find
//    public class func find(conditions: AnyObject..) -> AnyObject {
//        
//    }
    
    //MARK: Where
    public class func whereCondition(condition: AnyObject, order: AnyObject) -> Array<AnyObject>? {
        return fetch(condition, context: NSManagedObjectContext.defaultContext, order: order, limit: nil)
    }
    
    public class func whereCondition(condition: AnyObject, limit: Int) -> Array<AnyObject>? {
        return fetch(condition, context: NSManagedObjectContext.defaultContext, order: nil, limit: limit)
    }
    
    public class func whereCondition(condition: AnyObject, order: AnyObject, limit: Int) -> Array<AnyObject>? {
        return fetch(condition, context: NSManagedObjectContext.defaultContext, order: order, limit: limit)
    }
    
    public class func whereCondition(condition: AnyObject, context: NSManagedObjectContext) -> Array<AnyObject>? {
        return fetch(condition, context: context, order: nil, limit: nil)
    }
    
    public class func whereCondition(condition: AnyObject, context: NSManagedObjectContext, order: AnyObject) -> Array<AnyObject>? {
        return fetch(condition, context: context, order: order, limit: nil)
    }
    
    public class func whereCondition(condition: AnyObject, context: NSManagedObjectContext, limit: Int) -> Array<AnyObject>? {
        return fetch(condition, context: context, order: nil, limit: limit)
    }
    
    public class func whereCondition(condition: AnyObject, context: NSManagedObjectContext, order: AnyObject, limit: Int) -> Array<AnyObject>? {
        return fetch(condition, context: context, order: order, limit: limit)
    }

    //MARK: Count
    public class func count() -> Int {
        return countInContext(NSManagedObjectContext.defaultContext)
    }
    
    public class func countInContext(context: NSManagedObjectContext) -> Int {
        return countForFetch(nil, context: context)
    }
    
    public class func countWhere(condition: AnyObject, context: NSManagedObjectContext) -> Int {
        let predicate = predicateFromObject(condition)
        
        return countForFetch(predicate, context: context)
    }
    
    //MARK: - Save
    public func save() -> Bool {
        return self.saveTheContext()
    }
    
    //MARK: - Naming
    public class var entityName: String? {
        get {
            var classString = NSStringFromClass(self)
            let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
            
            if let localRange = range {
                return classString.substringFromIndex(localRange.endIndex)
            } else {
                return classString
            }
        }
    }
    
    //MARK: - Private Functions
    
    //MARK: Fetching
    private class func createFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest {
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(entityName!, inManagedObjectContext: context)
        
        return request
    }
    
    private class func fetch(condition: AnyObject?, context: NSManagedObjectContext, order: AnyObject?, limit: Int?) -> Array<AnyObject>? {
        let request = createFetchRequest(context)
        
        if let localCondition: AnyObject = condition {
            request.predicate = predicateFromObject(localCondition)
        }
        
        if let localOrder: AnyObject = order {
            request.sortDescriptors = sortDescriptiorsFromObject(localOrder)
        }
        
        if let localLimit = limit {
            request.fetchLimit = localLimit
        }
        
        return context.executeFetchRequest(request, error: nil)
    }
    
    //MARK: Predicating
    private class func predicateFromDictionary(dictionary: Dictionary<String, AnyObject>) -> NSPredicate {
        var subpredicates = []
        
        for (key, value) in dictionary {
            subpredicates.arrayByAddingObject(NSPredicate(format:  "\(key) == \(value)")!)
        }
        
        return NSCompoundPredicate.andPredicateWithSubpredicates(subpredicates)
    }
    
    private class func predicateFromObject(condition: AnyObject, arguments: AnyObject...) -> NSPredicate? {
        if condition is NSPredicate {
            return condition as? NSPredicate
        } else if condition is String {
            return NSPredicate(format: condition as String, [arguments])
        } else if condition is NSDictionary {
            return predicateFromDictionary(condition as Dictionary)
        }
        
        return nil
    }
    
    //MARK: Sorting
    private class func sortDescriptorFromDictionary(dictionary: Dictionary<String, String>) -> NSSortDescriptor {
        let isAsscending = dictionary.values.first!.uppercaseString == "ASC"
        
        return NSSortDescriptor(key: dictionary.keys.first!, ascending: isAsscending)
    }
    
    private class func sortDescriptorFromString(order: String) -> NSSortDescriptor {
        let components = order.componentsSeparatedByString(" ")
        
        let key: String = components.first!
        let value: String = components.count > 1 ? components[1] : "ASC"
        
        return sortDescriptorFromDictionary([key : value])
    }
    
    private class func sortDescriptorFromObject(order: AnyObject) -> NSSortDescriptor? {
        if order is NSSortDescriptor {
            return order as? NSSortDescriptor
        } else if order is String {
            return sortDescriptorFromString(order as String)
        } else if order is Dictionary<String, String> {
            return sortDescriptorFromDictionary(order as Dictionary<String, String>)
        } else {
            return nil;
        }
    }
    
    private class func sortDescriptiorsFromObject(order: AnyObject) -> Array<NSSortDescriptor> {
        if order is NSString {
            return [sortDescriptorFromObject(order.componentsSeparatedByString(","))!]
        } else if order is Array<AnyObject> {
            var a = order as Array<AnyObject>
            a.map {(object) -> NSSortDescriptor in
                return self.sortDescriptorFromObject(object)!
            }
        }
        
        return [sortDescriptorFromObject(order)!]
    }
    
    //MARK: Counting
    private class func countForFetch(predicate: NSPredicate!, context: NSManagedObjectContext) -> Int {
        let request = createFetchRequest(context)
        request.predicate = predicate
        
        return context.countForFetchRequest(request, error: nil)
    }
    
    //MARK: Saving
    private func saveTheContext() -> Bool {
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
    
    //MARK: Updating
    private class func transformProperties(properties: Dictionary<String, AnyObject>, object: NSManagedObject, context: NSManagedObjectContext) -> Dictionary<String, AnyObject> {
        let entity = NSEntityDescription.entityForName(entityName!, inManagedObjectContext: context)
        
        let attributes = entity?.attributesByName
        let relationships = entity?.relationshipsByName
        
        var transformed = Dictionary<String, AnyObject>(minimumCapacity: properties.count)
        
        for key in properties {
            
        }
        
        return transformed
    }
}