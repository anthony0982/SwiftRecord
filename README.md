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
var john = Person.create()
john.name = "John"
john.save()
john.delete()

```

#### Origins

SwiftRecord is a port of the objective-c based [ObjectiveRecord](https://github.com/supermarin/ObjectiveRecord) library for Swift
