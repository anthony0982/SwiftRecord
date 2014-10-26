//
// NSManagedObjectActiveRecordTests.swift
// SwiftRecord
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Damien Glancy <damien.glancy@icloud.com>
//
// Permission is hereby granted, free of charge, to any entity obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit entitys to whom the Software is
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

class FindersAndCreatorsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        CoreDataManager.manager.reset()
        super.tearDown()
    }
        
    func testEntityName() {
        XCTAssert(Person.entityName == "Person", "entity should be named entity, not \(Person.entityName)")
    }
    
    func testGetDefaultManagedObjectContextViaExtension() {
        let context = NSManagedObjectContext.defaultContext
        XCTAssertNotNil(context, "context should not be nil")
    }
    
    func testCreateSomePeople() {
        XCTAssert(Person.all()!.count == 0, "count should be zero not \(Person.all()!.count)")
        createSomePeople()
        XCTAssert(Person.all()!.count == 10, "count should be 10 not \(Person.all()!.count)")
    }
    
    func testCreateEntity() {
        let entity = Person.create() as Person
        XCTAssertNotNil(entity, "entity should not be nil")
    }

    func testCreateEntityUsingSuppliedContext() {
        let context = NSManagedObjectContext.defaultContext
        XCTAssertNotNil(context, "context should not be nil")
        
        let entity = Person.createInContext(context) as Person
        XCTAssertNotNil(entity, "entity should not be nil")
    }
    
    func testSaveEntity() {
        let entity = Person.create() as Person
        XCTAssertNotNil(entity, "entity should not be nil")
        XCTAssertTrue(entity.hasChanges, "entity should have changes (its a new unsaved entity in the context)")
        
        let result = entity.save()
        XCTAssertTrue(result, "save result should be true (successful)")
        XCTAssertFalse(entity.hasChanges, "entity should now longer have changes")
    }
    
    func testDeleteEntity() {
        let entity = Person.create() as Person
        let result = entity.save()
        
        XCTAssertTrue(result, "save result should be true (successful)")
        XCTAssertFalse(entity.hasChanges, "entity should now longer have changes")
        
        XCTAssertFalse(entity.deleted, "entity should not be marked as deleted")
        entity.delete()
        XCTAssertTrue(entity.deleted, "entity should be marked as deleted")
    }
    
    func testEntityAll() {
        let results = Person.all()
        XCTAssertNotNil(results!, "results should not be nil")
        XCTAssert(results!.count == 0, "all count should be zero")
        
        let entity = Person.create() as Person
        entity.save()
        
        let results2 = Person.all()
        XCTAssertNotNil(results2!, "results should not be nil")
        XCTAssert(results2!.count == 1, "all count should be 1 not \(results2!.count)")
    }
    
    func testDeleteAll() {
        Person.deleteAll()
        
        let results = Person.all()
        XCTAssertNotNil(results, "results should not be nil")
    }
    
    func testCount() {
        let count = Person.count()
        
        XCTAssertNotNil(count, "count should not be nil")
        XCTAssert(count == 0, "count should be zero")
    }
    
    //MARK: - Private functions
    
    private func createSomePeople() {
        for var count = 0; count < 10; count++ {
            let entity = Person.create() as Person
            entity.save()
        }
    }
}
