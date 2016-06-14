MyKit
=====

[![Swift Version](https://img.shields.io/badge/swift-2.2-orange.svg?style=flat-square)](https://swift.org)  [![Build Status](https://img.shields.io/travis/aquarchitect/MyKit.svg?style=flat-square)](https://travis-ci.org/aquarchitect/MyKit/)  [![Platform Support](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20-lightgrey.svg?style=flat-square)](https://developer.apple.com/xcode/download/)  [![Documentation Page](https://img.shields.io/badge/docs-6%-green.svg?style=flat-square)](http://aquarchitect.github.io/MyKit/)

### INTRODUCTION

__MyKit__ is a wide-ranged collection of codes from native APIs extensions to frameworks covering from data structure to user interface.

<big><pre>
[Common/](Sources/Common/)
+-- [Utilities/](Sources/Common/Utilities/)
|   +-- [Miscellaneous](Sources/Common/Utilities/Miscellaneous.swift)
|   +-- [Arbitrary](Sources/Common/Utilities/Arbitrary.swift)
|   +-- [Box](Sources/Common/Utilities/Box.swift)
|   +-- [Curry](Sources/Common/Utilities/Curry.swift)
|   +-- [Diff](Sources/Common/Utilities/Diff.swift)
|   +-- [Draw](Sources/Common/Utilities/Draw.swift)
|   +-- [Matrix](Sources/Common/Utilities/Matrix.swift)
|   +-- [Promise](Sources/Common/Utilities/Promise.swift)
|   +-- [Queue](Sources/Common/Utilities/Queue.swift)
|   +-- [Result](Sources/Common/Utilities/Result.swift)
|   +-- [Schedule](Sources/Common/Utilities/Schedule.swift)
|   +-- [Swizzle](Sources/Common/Utilities/Swizzle.swift)
|   +-- [Then](Sources/Common/Utilities/Then.swift)
|   +-- [Timing](Sources/Common/Utilities/Timing.swift)
+-- [Extensions/](Sources/Common/Extensions/)
|   +-- [Native/](Sources/Common/Extensions/Native/)
|   |   +-- [Range+](Sources/Common/Extensions/Native/Range+.swift)
|   |   +-- [String+](Sources/Common/Exntesions/Native/String+.swift)
|   |   +-- [Dictionary+](Sources/Common/Extensions/Native/Dictionary+.swift)
|   |   +-- [CollectionType+](Sources/Common/Extensions/Native/CollectionType+.swift)
|   |   +-- [SequenceType+](Sources/Common/Extensions/Native/SequenceType+.swift)
|   +-- [Foundation/](Sources/Common/Extensions/Foundation/)
|   |   +-- [NSBundle+](Sources/Common/Extensions/Foundation/NSBundle+.swift)
|   |   +-- [NSCache+](Sources/Common/Extensions/Foundation/NSCache+.swift)
|   |   +-- [NSDate+](Sources/Common/Extensions/Foundation/NSDate+.swift)
|   |   +-- [NSDateFormatter+](Sources/Common/Extensions/Foundation/NSDateFormatter+.swift)
|   |   +-- [NSIndexPath+](Sources/Common/Extensions/Foundation/NSIndexPath+.swift)
|   |   +-- [NSLayoutConstraint+](Sources/Common/Extensions/Foundation/NSLayoutConstraint+.swift)
|   |   +-- [NSMutableAttributedString+](Sources/Common/Extensions/Foundation/NSMutableAttributedString+.swift)
|   |   +-- [NSRange+](Sources/Common/Extensions/Foundation/NSRange+.swift)
|   |   +-- [NSScanner+](Sources/Common/Extensions/Foundation/NSScanner+.swift)
|   +-- [CoreGraphics/](Sources/Common/Extensions/CoreGraphics/)
|   |   +-- [CGPoint+](Sources/Common/Extensions/CoreGraphics/CGPoint+.swift)
|   |   +-- [CGRect+](Sources/Common/Extensions/CoreGraphics/CGRect+.swift)
|   |   +-- [CGSize+](Sources/Common/Extensions/CoreGraphics/CGSize+.swift)
|   +-- [CoreData/](Sources/Common/Extensions/CoreData/)
|   |   +-- [NSAttributeDescription+](Sources/Common/Extensions/CoreData/NSAttributeDescription+.swift)
|   |   +-- [NSEntityDescription+](Sources/Common/Extensions/CoreData/NSEntityDescription+.swift)
|   |   +-- [NSFetchRequest+](Sources/Common/Extensions/CoreData/NSFetchRequest+.swift)
|   |   +-- [NSManagedObject+](Sources/Common/Extensions/CoreData/NSManagedObject+.swift)
|   |   +-- [NSManagedObjectContext+](Sources/Common/Extensions/CoreData/NSManagedObjectContext+.swift)
|   |   +-- [NSRelationshipDescription+](Sources/Common/Extensions/CoreData/NSRelationshipDescription+.swift)
|   +-- [CloudKit/](Sources/Common/Extensions/CloudKit/)
|   |   +-- [CKContainer+](Sources/Common/Extensions/CloudKit/CKContainer+.swift)
|   |   +-- [CKDatabase+](Sources/Common/Extensions/CloudKit/CKDatabase+.swift)
|   |   +-- [CKQuery+](Sources/Common/Extensions/CloudKit/CKQuery+.swift)
|   |   +-- [CKRecord+](Sources/Common/Extensions/CloudKit/CKRecord+.swift)
|   |   +-- [CKRecordID+](Sources/Common/Extensions/CloudKit/CKRecordID+.swift)
+-- [Frameworks/](Sources/Common/Frameworks/)
    +-- [_FontLoading](Sources/Common/Frameworks/_FontLoading/)
    +-- [_LoremIpsum](Sources/Common/Frameworks/_LoremIpsum/)
    +-- [ActionTrailing](Sources/Common/Frameworks/ActionTrailing/)
    +-- [ColorHexing](Sources/Common/Frameworks/ColorHexing/)
    +-- [CloudKit](Sources/Common/Frameworks/CloudKit/)
    +-- [DateIndex](Sources/Common/Frameworks/DataIndex/)
    +-- [OpenWeather](Sources/Common/Frameworks/OpenWeather/)
    +-- [SymbolIcon](Sources/Common/Frameworks/SymbolIcon/)
    +-- [StreamService](Sources/Common/Frameworks/StreamService/)
    +-- [PersistentStack](Sources/Common/Frameworks/PersistentStack/)
[iOS/](Sources/iOS/)
+-- [Extensions/](Sources/iOS/Extensions/)
|   +-- [Draw+](Sources/iOS/Extensions/Draw+.swift)
|   +-- [UIBezierPath+](Sources/iOS/Extensions/UIBezierPath+.swift)
|   +-- [UICollectionView+](Sources/iOS/Extensions/UICollectionView+.swift)
|   +-- [UICollectionViewLayout+](Sources/iOS/Extensions/UICollectionViewLayout+.swift)
|   +-- [UIEdgeInsets+](Sources/iOS/Extensions/UIEdgeInsets+.swift)
|   +-- [UILabel+](Sources/iOS/Extensions/UILabel+.swift)
|   +-- [UIScreen+](Sources/iOS/Extensions/UIScreen+.swift)
|   +-- [UIScrollView+](Sources/iOS/Extensions/UIScreenView+.swift)
|   +-- [UITableView+](Sources/iOS/Extensions/UITableView+.swift)
|   +-- [UIViewController+](Sources/iOS/Extensions/UIViewController+.swift)
+-- [Frameworks/](Sources/iOS/Frameworks/)
    +-- [GrowingText](Sources/iOS/Frameworks/GrowingText/)
    +-- [TransitionAnimator](Sources/iOS/Frameworks/TransitionAnimator/)
    +-- [GenericInterface](Sources/iOS/Frameworks/GrowingText/): Table and Collection
    +-- [CollectionLayout](Sources/iOS/Frameworks/CollectionLayout/): Snap, Center, and Magnify
</pre></big>

### ABOUT

This library was originally for organizing all of the common codes in Swift development. However over the year, it has been growing rapidly and becoming a track record of all APIs that I have ever worked on. Every time there is a possibility of a __generic__ implementation it will end up here.

This is more or less an educational diary of mine to the programming world since I started out from a nontechnical background; and most importantly it is an essential pocket arsenals that I use in daily based tasks.

Happy Coding!

### LICENSE

All content is licensed under the terms of the MIT open source license.