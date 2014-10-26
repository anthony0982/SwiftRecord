//
// CoreDataManagerTests.swift
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

import XCTest
import CoreData
import SampleProject

class CoreDataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        CoreDataManager.manager.reset()
        super.tearDown()
    }
    
    func testCoreDataManagerGetManager() {
        let instance = CoreDataManager.manager
        XCTAssertNotNil(instance, "instance should not be nil")
    }
    
    func testCoreDataManagerActsAsASingleton() {
        let instance = CoreDataManager.manager
        XCTAssertNotNil(instance, "instance should not be nil")
        
        let instanceB = CoreDataManager.manager
        XCTAssertNotNil(instanceB, "instanceB should not be nil")
        
        XCTAssertEqual(instance, instanceB, "instances should be identical as per singleton pattern")
    }
    
    func testCoreDataManagerReset() {
        let managedObjectContextA = CoreDataManager.manager.managedObjectContext!
        let persistentStoreCoordinatorA = CoreDataManager.manager.persistentStoreCoordinator!
        
        XCTAssertNotNil(managedObjectContextA, "should not be nil")
        XCTAssertNotNil(persistentStoreCoordinatorA, "should not be nil")
        
        CoreDataManager.manager.reset()
        
        let managedObjectContextB = CoreDataManager.manager.managedObjectContext!
        let persistentStoreCoordinatorB = CoreDataManager.manager.persistentStoreCoordinator!
        
        XCTAssertNotNil(managedObjectContextB, "should not be nil")
        XCTAssertNotNil(persistentStoreCoordinatorB, "should not be nil")
        
        XCTAssertNotEqual(managedObjectContextA, managedObjectContextB, "contexts should not be equal after a reset")
        XCTAssertNotEqual(persistentStoreCoordinatorA, persistentStoreCoordinatorB, "stores should not be equal after a reset")
    }
    
    func testManagedObjectModelIsNotNil() {
        let managedObjectModel = CoreDataManager.manager.managedObjectModel!
        XCTAssertNotNil(managedObjectModel, "managedObjectModel should not be nil")
    }
    
    func testCoreDataMangerHasAPersistentStoreCoordinator() {
        let coordinator = CoreDataManager.manager.persistentStoreCoordinator!
        XCTAssertNotNil(coordinator, "persistentStoreCoordinator should not be nil")
        XCTAssertTrue(coordinator.persistentStores.count > 0, "should have at least 1 persistent store")
    }
    
    func testCreateDiskBasedPersistentStoreCoordinator() {
        let store = CoreDataManager.manager.persistentStoreCoordinator!.persistentStores[0] as NSPersistentStore
        XCTAssert(store.type == NSSQLiteStoreType, "store should be NSSQLiteStoreType based")
    }
    
    func testCreateMemoryBasedPersistentStoreCoordinator() {
        CoreDataManager.manager.useInMemoryStore()
        
        let store = CoreDataManager.manager.persistentStoreCoordinator!.persistentStores[0] as NSPersistentStore
        XCTAssert(store.type == NSInMemoryStoreType, "store should be NSInMemoryStoreType based")
    }
    
    func testHasAManagedObjectContext() {
        let context = CoreDataManager.manager.managedObjectContext!
        XCTAssertNotNil(context, "context should not be nil")
    }
}
