MyKit
=====

[![Swift Version](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat-square)](https://swift.org)  [![Build Status](https://img.shields.io/travis/aquarchitect/MyKit.svg?style=flat-square)](https://travis-ci.org/aquarchitect/MyKit/)  [![Platform Support](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20-lightgrey.svg?style=flat-square)](https://developer.apple.com/xcode/download/)

### INTRODUCTION

__MyKit__ is a wide-ranged collection of codes from extensions to small modular frameworks covering from data structure to user interface. For record purposes, everything is listed in the directory tree below; exciting features are highlighted with an embedded link directly to the source codes.

Thanks for checking it out, and Happy coding!

<details><summary>Directory Tree</summary>
<big><pre>
Common/
├── Utilities/
|   ├── [Arbitrary](Sources/Common/Utilities/Arbitrary.swift)
|   ├── Box
|   ├── [Curry](Sources/Common/Utilities/Curry.swift)
|   ├── [Change](Sources/Common/Utilities/Change.swift)
|   ├── [Draw](Sources/Common/Utilities/Draw.swift)
|   ├── [Matrix](Sources/Common/Utilities/Matrix.swift)
|   ├── [Promise](Sources/Common/Utilities/Promise.swift)
|   ├── [Result](Sources/Common/Utilities/Result.swift)
|   ├── [Schedule](Sources/Common/Utilities/Schedule.swift)
|   ├── [Swizzle](Sources/Common/Utilities/Swizzle.swift)
|   └── [Then](Sources/Common/Utilities/Then.swift)
├── Extensions/
|   ├── Native/
|   |   ├── CountableRange+
|   |   ├── [String+](Sources/Common/Extensions/Native/String+.swift)
|   |   ├── [Dictionary+](Sources/Common/Extensions/Native/Dictionary+.swift)
|   |   ├── [Collection+](Sources/Common/Extensions/Native/Collection+.swift)
|   |   ├── AnyIterator+
|   |   └── RangeReplaceableCollection+
|   ├── Foundation/
|   |   ├── Bundle+
|   |   ├── [Date+](Sources/Common/Extensions/Foundation/Date+.swift)
|   |   ├── [DateFormatter+](Sources/Common/Extensions/Foundation/DateFormatter+.swift)
|   |   ├── [Scanner+](Sources/Common/Extensions/Foundation/Scanner+.swift)
|   |   ├── [URLSession+](Sources/Common/Extensions/Foundation/URLSession+.swift)
|   |   ├── [NSLayoutConstraint+](Sources/Common/Extensions/Foundation/NSLayoutConstraint+.swift)
|   |   ├── [NSMutableAttributedString+](Sources/Common/Extensions/Foundation/NSMutableAttributedString+.swift)
|   |   └── NSRange+
|   ├── CoreGraphics/
|   |   ├── CGPoint+
|   |   ├── CGRect+
|   |   └── CGSize+
|   ├── CoreData/
|   |   ├── NSAttributeDescription+
|   |   └── NSRelationshipDescription+
|   └── CloudKit/
|       ├── [CKContainer+](Sources/Common/Extensions/CloudKit/CKContainer+.swift)
|       ├── [CKDatabase+](Sources/Common/Extensions/CloudKit/CKDatabase+.swift)
|       ├── [CKRecord+](Sources/Common/Extensions/CloudKit/CKRecord+.swift)
|       └── [CKRecordID+](Sources/Common/Extensions/CloudKit/CKRecordID+.swift)
└── Frameworks/
    ├── [_FontLoading](Sources/Common/Frameworks/_FontLoading/)
    ├── [_LoremIpsum](Sources/Common/Frameworks/_LoremIpsum/)
    ├── [ActionTrailing](Sources/Common/Frameworks/ActionTrailing/)
    ├── [ColorHexing](Sources/Common/Frameworks/ColorHexing/)
    ├── [CloudKit](Sources/Common/Frameworks/CloudKit/)
    ├── [OpenWeather](Sources/Common/Frameworks/OpenWeather/)
    ├── [SymbolIcon](Sources/Common/Frameworks/SymbolIcon/)
    └── [PersistentStack](Sources/Common/Frameworks/PersistentStack/)
iOS/
├── Extensions/
|   ├── Draw+
|   ├── [UIBezierPath+](Sources/iOS/Extensions/UIBezierPath+.swift)
|   ├── [UICollectionView+](Sources/iOS/Extensions/UICollectionView+.swift)
|   ├── UIEdgeInsets+
|   ├── UILabel+
|   ├── UIScreen+
|   ├── UIScrollView+
|   ├── [UITableView+](Sources/iOS/Extensions/UITableView+.swift)
|   ├── UIView+
|   └── UIViewController+
└── Frameworks/
    ├── [LongPress](Sources/iOS/Frameworks/LongPress/)
    ├── [GrowingText](Sources/iOS/Frameworks/GrowingText/)
    ├── [GenericInterface](Sources/iOS/Frameworks/GenericInterface/) - including table/collection view
    └── [CollectionLayout](Sources/iOS/Frameworks/CollectionLayout/) - including Paraboloid and Snapping
</pre></big>
</details>

### NOTES

##### Naming Convention
- When passing a function as a variable, the input argument name should be a verb for `@noescaping` and a noun for `@escaping`.
- Transforming method from one type to another is named as `map` and `flatMap` in order to be consistent with `Optional`, especially in the case of [`Promise`](Sources/Common/Utilities/Promise.swift) and [`Result`](Sources/Common/Utilities/Result.swift).

##### Documentation Set
Due to `jazzy` difficulties, the support for documentation is now __deprecated__. . Meanwhile, the search for a better alternative continues.

> The old `jazzy` and `travis-ci` combination's result and implementation can be found at [gh-pages](http://aquarchitect.github.io/MyKit/) and [`Makefile`](https://github.com/aquarchitect/MyKit/blob/swift-legacy/Makefile) respectively.

### ABOUT

The library was originally just for organizing all of the Swift boilerplate codes. However, over the years it has been growing quickly and becomes an essential arsenal in my development workflow. If there is a __generic__ implementation for a problem, it likely will end up here.

> Difference between __Library__ and __Framework__:
> - _Framework_ call you
> - You call _Library_

### LICENSE

All content is licensed under the terms of the MIT open source license.
