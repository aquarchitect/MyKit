MyKit
=====

[![Swift Version](https://img.shields.io/badge/swift-2.2-orange.svg?style=flat-square)](https://swift.org)  [![Build Status](https://img.shields.io/travis/aquarchitect/MyKit.svg?style=flat-square)](https://travis-ci.org/aquarchitect/MyKit/)  [![Platform Support](https://img.shields.io/badge/platforms-iOS%20%7C%20OS%20X%20-lightgrey.svg?style=flat-square)](https://developer.apple.com/xcode/download/)  [![Documentation Page](https://img.shields.io/badge/docs-6%-green.svg?style=flat-square)](http://aquarchitect.github.io/MyKit/)

### INTRODUCTION

__MyKit__ is a wide-ranged collection of codes from native APIs extensions to frameworks covering from data structure to user interface.

<big><pre> 
[Common](Sources/Common/)
 +-- [Utilities](Sources/Common/Utilities/)
 |   +-- [Miscellaneous](Srouces/Common/Utitlities/Miscellaneous.swift)
 |   +-- [Arbitrary](Srouces/Common/Utitlities/Arbitrary.swift)
 |   +-- [Box](Srouces/Common/Utitlities/Box.swift)
 |   +-- [Curry](Srouces/Common/Utitlities/Curry.swift)
 |   +-- [Diff](Srouces/Common/Utitlities/Diff.swift)
 |   +-- [Draw](Srouces/Common/Utitlities/Draw.swift)
 |   +-- [Matrix](Srouces/Common/Utitlities/Matrix.swift)
 |   +-- [Promise](Srouces/Common/Utitlities/Promise.swift)
 |   +-- [Queue](Srouces/Common/Utitlities/Queue.swift)
 |   +-- [Result](Srouces/Common/Utitlities/Result.swift)
 |   +-- [Schedule](Srouces/Common/Utitlities/Schedule.swift)
 |   +-- [Swizzle](Srouces/Common/Utitlities/Swizzle.swift)
 |   +-- [Then](Srouces/Common/Utitlities/Then.swift)
 |   +-- [Timing](Srouces/Common/Utitlities/Timing.swift)
 +-- [Extensions](Sources/Common/Extensions/)
 |   +-- [Native](Srouces/Common/Extensions/Native/)
 |   |   +-- [Range+](Srouces/Common/Extensions/Native/Range+.swift)
 |   |   +-- [String+](Srouces/Common/Exntesions/Native/String+.swift)
 |   |   +-- [Dictionary+](Srouces/Common/Extensions/Native/Dictionary+.swift)
 |   |   +-- [CollectionType+](Srouces/Common/Extensions/Native/CollectionType+.swift)
 |   |   +-- [SequenceType+](Srouces/Common/Extensions/Native/SequenceType+.swift)
 |   +-- [Foundation](Srouces/Common/Extensions/Foundation/)
 |   |   +-- [NSBundle+](Srouces/Common/Extensions/Foundation/NSBundle+.swift)
 |   |   +-- [NSCache+](Srouces/Common/Extensions/Foundation/NSCache+.swift)
 |   |   +-- [NSDate+](Srouces/Common/Extensions/Foundation/NSDate+.swift)
 |   |   +-- [NSDateFormatter+](Srouces/Common/Extensions/Foundation/NSDateFormatter+.swift)
 |   |   +-- [NSIndexPath+](Srouces/Common/Extensions/Foundation/NSIndexPath+.swift)
 |   |   +-- [NSLayoutConstraint+](Srouces/Common/Extensions/Foundation/NSLayoutConstraint+.swift)
 |   |   +-- [NSMutableAttributedString+](Srouces/Common/Extensions/Foundation/NSMutableAttributedString+.swift)
 |   |   +-- [NSRange+](Srouces/Common/Extensions/Foundation/NSRange+.swift)
 |   |   +-- [NSScanner+](Srouces/Common/Extensions/Foundation/NSScanner+.swift)
 |   +-- [CoreGraphics](Srouces/Common/Extensions/CoreGraphics/)
 |   |   +-- [CGPoint+](Srouces/Common/Extensions/CoreGraphics/CGPoint+.swift)
 |   |   +-- [CGRect+](Srouces/Common/Extensions/CoreGraphics/CGRect+.swift)
 |   |   +-- [CGSize+](Srouces/Common/Extensions/CoreGraphics/CGSize+.swift)
 |   +-- [CoreData](Srouces/Common/Extensions/CoreData/)
 |   |   +-- [NSAttributeDescription+](Srouces/Common/Extensions/CoreData/NSAttributeDescription+.swift)
 |   |   +-- [NSEntityDescription+](Srouces/Common/Extensions/CoreData/NSEntityDescription+.swift)
 |   |   +-- [NSFetchRequest+](Srouces/Common/Extensions/CoreData/NSFetchRequest+.swift)
 |   |   +-- [NSManagedObject+](Srouces/Common/Extensions/CoreData/NSManagedObject+.swift)
 |   |   +-- [NSManagedObjectContext+](Srouces/Common/Extensions/CoreData/NSManagedObjectContext+.swift)
 |   |   +-- [NSRelationshipDescription+](Srouces/Common/Extensions/CoreData/NSRelationshipDescription+.swift)
 |   +-- [CloudKit](Srouces/Common/Extensions/CloudKit/)
 |   |   +-- [CKContainer+](Srouces/Common/Extensions/CKContainer+/)
 |   |   +-- [CKDatabase+](Srouces/Common/Extensions/CKDatabase+/)
 |   |   +-- [CKQuery+](Srouces/Common/Extensions/CKQuery+/)
 |   |   +-- [CKRecord+](Srouces/Common/Extensions/CKRecord+/)
 |   |   +-- [CKRecordID+](Srouces/Common/Extensions/CKRecordID+/)
 +-- [Frameworks](Sources/Common/Frameworks/)
     +-- [_FontLoading](Srouces/Common/Frameworks/_FontLoading/)
     +-- [_LoremIpsum](Srouces/Common/Frameworks/_LoremIpsum/)
     +-- [ActionTrailing](Srouces/Common/Frameworks/ActionTrailing/)
     +-- [ColorHexing](Srouces/Common/Frameworks/ColorHexing/)
     +-- [CloudKit](Srouces/Common/Frameworks/CloudKit/)
     +-- [DateIndex](Srouces/Common/Frameworks/DataIndex/)
     +-- [OpenWeather](Srouces/Common/Frameworks/OpenWeather/)
     +-- [SymbolIcon](Srouces/Common/Frameworks/SymbolIcon/)
     +-- [StreamService](Srouces/Common/Frameworks/StreamService/)
     +-- [PersistentStack](Srouces/Common/Frameworks/PersistentStack/)
 [iOS](Sources/iOS/)
 +-- [Extensions](Sources/iOS/Extensions/)
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
 +-- [Frameworks](Sources/iOS/Frameworks/)
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