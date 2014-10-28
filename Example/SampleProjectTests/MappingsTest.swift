//
//  MappingsTest.swift
//  SampleProject
//
//  Created by Damien Glancy on 28/10/2014.
//  Copyright (c) 2014 Damien Glancy. All rights reserved.
//

import XCTest
import CoreData
import SampleProject

class MappingsTest: XCTestCase {
    
    var person: Person? = nil
    
    override func setUp() {
        super.setUp()
        
        CoreDataManager.manager.useInMemoryStore()
        
        let JSON = [
            "first_name" : "Damien",
            "last_name" : "Glancy",
            "date_of_birth" : "16111975"
        ]
        
        person = Person.create(JSON, context: NSManagedObjectContext.defaultContext) as? Person
    }
    
    override func tearDown() {
        CoreDataManager.manager.reset()
        super.tearDown()
    }
    
    func testCreateUsingMapping() {
        
    }
}
