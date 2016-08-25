MyKit
=====

[![Swift Version](https://img.shields.io/badge/swift-2.2-orange.svg?style=flat-square)](https://swift.org)  [![Build Status](https://img.shields.io/travis/aquarchitect/MyKit.svg?style=flat-square)](https://travis-ci.org/aquarchitect/MyKit/)  [![Platform Support](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20-lightgrey.svg?style=flat-square)](https://developer.apple.com/xcode/download/)  [![Documentation Page](https://img.shields.io/badge/docs-6%-green.svg?style=flat-square)](http://aquarchitect.github.io/MyKit/)

### INTRODUCTION

__MyKit__ is a wide-ranged collection of codes from extensions to small modular frameworks that are covering from data structure to user interface. For record purposes, everything is listed below in a directory tree, and the most exciting features will have an embedded link to the source codes.

Thanks for checking out, and Happy coding!

<big><pre>
Common/
├── Utilities/
|   ├── _Minor
|   ├── [Arbitrary](Sources/Common/Utilities/Arbitrary.swift)
|   ├── Box
|   ├── [Curry](Sources/Common/Utilities/Curry.swift)
|   ├── [Diff](Sources/Common/Utilities/Diff.swift)
|   ├── [Draw](Sources/Common/Utilities/Draw.swift)
|   ├── [Matrix](Sources/Common/Utilities/Matrix.swift)
|   ├── [Promise](Sources/Common/Utilities/Promise.swift)
|   ├── Queue
|   ├── [Result](Sources/Common/Utilities/Result.swift)
|   ├── [Schedule](Sources/Common/Utilities/Schedule.swift)
|   ├── [Swizzle](Sources/Common/Utilities/Swizzle.swift)
|   ├── [Then](Sources/Common/Utilities/Then.swift)
|   ├── [Timing](Sources/Common/Utilities/Timing.swift)
├── Extensions/
|   ├── Native/
|   |   ├── Range+
|   |   ├── [String+](Sources/Common/Extensions/Native/String+.swift)
|   |   ├── [Dictionary+](Sources/Common/Extensions/Native/Dictionary+.swift)
|   |   ├── [CollectionType+](Sources/Common/Extensions/Native/CollectionType+.swift)
|   |   └── [SequenceType+](Sources/Common/Extensions/Native/SequenceType+.swift)
|   ├── Foundation/
|   |   ├── NSBundle+
|   |   ├── [NSCache+](Sources/Common/Extensions/Foundation/NSCache+.swift)
|   |   ├── [NSDate+](Sources/Common/Extensions/Foundation/NSDate+.swift)
|   |   ├── [NSDateFormatter+](Sources/Common/Extensions/Foundation/NSDateFormatter+.swift)
|   |   ├── [NSIndexPath+](Sources/Common/Extensions/Foundation/NSIndexPath+.swift)
|   |   ├── [NSLayoutConstraint+](Sources/Common/Extensions/Foundation/NSLayoutConstraint+.swift)
|   |   ├── [NSMutableAttributedString+](Sources/Common/Extensions/Foundation/NSMutableAttributedString+.swift)
|   |   ├── NSRange+
|   |   └── [NSScanner+](Sources/Common/Extensions/Foundation/NSScanner+.swift)
|   ├── CoreGraphics/
|   |   ├── CGPoint+
|   |   ├── CGRect+
|   |   └── CGSize+
|   ├── CoreData/
|   |   ├── NSAttributeDescription+
|   |   ├── NSEntityDescription+
|   |   ├── NSFetchRequest+
|   |   ├── NSManagedObject+
|   |   ├── [NSManagedObjectContext+](Sources/Common/Extensions/CoreData/NSManagedObjectContext+.swift)
|   |   └── NSRelationshipDescription+
|   └── CloudKit/
|       ├── [CKContainer+](Sources/Common/Extensions/CloudKit/CKContainer+.swift)
|       ├── [CKDatabase+](Sources/Common/Extensions/CloudKit/CKDatabase+.swift)
|       ├── [CKQuery+](Sources/Common/Extensions/CloudKit/CKQuery+.swift)
|       ├── [CKRecord+](Sources/Common/Extensions/CloudKit/CKRecord+.swift)
|       └── [CKRecordID+](Sources/Common/Extensions/CloudKit/CKRecordID+.swift)
└── Frameworks/
    ├── [_FontLoading](Sources/Common/Frameworks/_FontLoading/)
    ├── [_LoremIpsum](Sources/Common/Frameworks/_LoremIpsum/)
    ├── [ActionTrailing](Sources/Common/Frameworks/ActionTrailing/)
    ├── [ColorHexing](Sources/Common/Frameworks/ColorHexing/)
    ├── [CloudKit](Sources/Common/Frameworks/CloudKit/)
    ├── [DateIndex](Sources/Common/Frameworks/DataIndex/)
    ├── [OpenWeather](Sources/Common/Frameworks/OpenWeather/)
    ├── [SymbolIcon](Sources/Common/Frameworks/SymbolIcon/)
    ├── [StreamService](Sources/Common/Frameworks/StreamService/)
    └── [PersistentStack](Sources/Common/Frameworks/PersistentStack/)
iOS/
├── Extensions/
|   ├── [Draw+](Sources/iOS/Extensions/Draw+.swift)
|   ├── [UIBezierPath+](Sources/iOS/Extensions/UIBezierPath+.swift)
|   ├── [UICollectionView+](Sources/iOS/Extensions/UICollectionView+.swift)
|   ├── [UICollectionViewLayout+](Sources/iOS/Extensions/UICollectionViewLayout+.swift)
|   ├── UIEdgeInsets+
|   ├── UILabel+
|   ├── UIScreen+
|   ├── [UIScrollView+](Sources/iOS/Extensions/UIScreenView+.swift)
|   ├── [UITableView+](Sources/iOS/Extensions/UITableView+.swift)
|   └── UIViewController+
└── Frameworks/
    ├── [GrowingText](Sources/iOS/Frameworks/GrowingText/)
    ├── [TransitionAnimator](Sources/iOS/Frameworks/TransitionAnimator/)
    ├── [GenericInterface](Sources/iOS/Frameworks/GrowingText/)
    └── [CollectionLayout](Sources/iOS/Frameworks/CollectionLayout/)
</pre></big>

### ABOUT

This library was originally just for organizing the common boilerplate codes in my Swift development workflow; and if has been growing larger over years. If there is a __generic__ implementation's possibility it likely will end up here.

This is more or less an educational diary of mine to programming; but most importantly it is an essential arsenal for any of my Swift project.

### LICENSE

All content is licensed under the terms of the MIT open source license.
