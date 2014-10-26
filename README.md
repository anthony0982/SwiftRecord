# SwiftRecord [![Build Status][ci-bdg]][ci]

[ci-bdg]: https://travis-ci.org/dglancy/SwiftRecord.svg
[ci]: https://travis-ci.org/dglancy/SwiftRecord

SwiftRecord is a lightweight ActiveRecord way of interacting with Core Data objects.

Its easy to get up and running with no AppDelegate code required. Fully tested using Apple's XCTest framework.

#### Usage

1. Install with [CocoaPods](http://cocoapods.org) or clone
2. `import SwiftRecord` module into your model or .pch file.

#### Create / Save / Delete

``` swift
let john = Person.create() as Person
john.name = "John"
john.save()
john.delete()
```

#### Finders

```` swift
// all Person entities from the database
var people = Person.all()

// Person entities with name John
var johns = Person.where("name == 'John'")

// And of course, John Doe!
let johnDoe = Person.find("name == 'John' AND surename == 'Doe'") as? Person
````

#### Order and Limit

```` swift
// Just the first 5 people named John sorted by last name
var fivePeople = Person.where("name == 'John'",
                              order:["surname" : "ASC"],
                              limit:5);
````

#### Reset

Reset the core data context, persistent data store and remove the sqllite database (if being used). Reset is helpful if you wish to completely remove the core data stack, for example, when a user logs out of your application.

This function shoud be used with caution as you have to make sure that there are no existing Managed Objects being referenced.

``` swift
CoreDataManager.manager.reset()
```

#### Testing

SwiftRecord supports Core Data's in-memory store. In any place, before your tests start running, its enough to call:

``` swift
CoreDataManager.manager.useInMemoryStore()
```

#### Origins

SwiftRecord is a port of the objective-c based [ObjectiveRecord](https://github.com/supermarin/ObjectiveRecord) library for Swift
