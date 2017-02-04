# MyKit

[![Build Status](https://img.shields.io/travis/aquarchitect/MyKit.svg?style=flat-square)](https://travis-ci.org/aquarchitect/MyKit/) [![Platform Support](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-lightgrey.svg?style=flat-square)](https://developer.apple.com/xcode/download/) [![Carthage compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/ReSwift/ReSwift/blob/master/LICENSE.md)

## INTRODUCTION

**MyKit** is a wide-ranged collection of codes from extensions to small modular frameworks covering from data structure to user interface. For record purposes, everything is listed in the directory tree below; exciting features are highlighted with an embedded link directly to the source codes.

Thanks for checking it out, and Happy coding!

<details><summary>Directory Tree</summary>
<big>
  <pre>Common/
├── Utilities/
|   ├── <a href="Sources/Common/Utilities/Arbitrary.swift">Arbitrary</a>
|   ├── Box
|   ├── <a href="Sources/Common/Utilities/Curry.swift">Curry</a>
|   ├── <a href="Sources/Common/Utilities/Change.swift">Change</a>
|   ├── <a href="Sources/Common/Utilities/Draw.swift">Draw</a>
|   ├── <a href="Sources/Common/Utilities/Matrix.swift">Matrix</a>
|   ├── <a href="Sources/Common/Utilities/Result.swift">Result</a>
|   ├── <a href="Sources/Common/Utilities/Schedule.swift">Schedule</a>
|   ├── <a href="Sources/Common/Utilities/Swizzle.swift">Swizzle</a>
|   └── <a href="Sources/Common/Utilities/Then.swift">Then</a>
├── Extensions/
|   ├── Native/
|   |   ├── CountableRange+
|   |   ├── <a href="Sources/Common/Extensions/Native/String+.swift">String+</a>
|   |   ├── <a href="Sources/Common/Extensions/Native/Dictionary+.swift">Dictionary+</a>
|   |   ├── <a href="Sources/Common/Extensions/Native/Collection+.swift">Collection+</a>
|   |   ├── AnyIterator+
|   |   └── RangeReplaceableCollection+
|   ├── Foundation/
|   |   ├── Bundle+
|   |   ├── <a href="Sources/Common/Extensions/Foundation/Date+.swift">Date+</a>
|   |   ├── <a href="Sources/Common/Extensions/Foundation/DateFormatter+.swift">DateFormatter+</a>
|   |   ├── <a href="Sources/Common/Extensions/Foundation/Scanner+.swift">Scanner+</a>
|   |   ├── <a href="Sources/Common/Extensions/Foundation/URLSession+.swift">URLSession+</a>
|   |   ├── <a href="Sources/Common/Extensions/Foundation/NSLayoutConstraint+.swift">NSLayoutConstraint+</a>
|   |   ├── <a href="Sources/Common/Extensions/Foundation/NSMutableAttributedString+.swift">NSMutableAttributedString+</a>
|   |   └── NSRange+
|   ├── CoreGraphics/
|   |   ├── CGPoint+
|   |   ├── CGRect+
|   |   └── CGSize+
|   ├── CoreData/
|   |   ├── NSAttributeDescription+
|   |   └── NSRelationshipDescription+
|   └── CloudKit/
|       ├── <a href="Sources/Common/Extensions/CloudKit/CKContainer+.swift">CKContainer+</a>
|       ├── <a href="Sources/Common/Extensions/CloudKit/CKDatabase+.swift">CKDatabase+</a>
|       ├── <a href="Sources/Common/Extensions/CloudKit/CKRecord+.swift">CKRecord+</a>
|       └── <a href="Sources/Common/Extensions/CloudKit/CKRecordID+.swift">CKRecordID+</a>
└── Frameworks/
    ├── <a href="Sources/Common/Frameworks/_FontLoading/">_FontLoading</a>
    ├── <a href="Sources/Common/Frameworks/_LoremIpsum/">_LoremIpsum</a>
    ├── <a href="Sources/Common/Frameworks/ActionTrailing/">ActionTrailing</a>
    ├── <a href="Sources/Common/Frameworks/ColorHexing/">ColorHexing</a>
    ├── <a href="Sources/Common/Frameworks/CloudKit/">CloudKit</a>
    ├── <a href="Sources/Common/Frameworks/OpenWeather/">OpenWeather</a>
    ├── <a href="Sources/Common/Frameworks/SymbolIcon/">SymbolIcon</a>
    └── <a href="Sources/Common/Frameworks/PersistentStack/">PersistentStack</a>
iOS/
├── Extensions/
|   ├── Draw+
|   ├── <a href="Sources/iOS/Extensions/UIBezierPath+.swift">UIBezierPath+</a>
|   ├── <a href="Sources/iOS/Extensions/UICollectionView+.swift">UICollectionView+</a>
|   ├── UIEdgeInsets+
|   ├── UILabel+
|   ├── UIScreen+
|   ├── UIScrollView+
|   ├── <a href="Sources/iOS/Extensions/UITableView+.swift">UITableView+</a>
|   ├── UIView+
|   └── UIViewController+
└── Frameworks/
    ├── <a href="Sources/iOS/Frameworks/LongPress/">LongPress</a>
    ├── <a href="Sources/iOS/Frameworks/GrowingText/">GrowingText</a>
    ├── <a href="Sources/iOS/Frameworks/GenericInterface/">GenericInterface</a> - including table/collection view
    └── <a href="Sources/iOS/Frameworks/CollectionLayout/">CollectionLayout</a> - including Paraboloid and Snapping
</pre>
</big></details>

## NOTES

### Documentation Set

Due to `jazzy` difficulties, the support for documentation is now **deprecated**. . Meanwhile, the search for a better alternative continues.

## ABOUT

The library was originally just for organizing all of the Swift boilerplate codes. However, over the years it has been growing quickly and becomes an essential arsenal in my development workflow. If there is a **generic** implementation for a problem, it likely will end up here.

> Difference between **Library** and **Framework**:

> - _Framework_ call you
> - You call _Library_

## LICENSE

All content is licensed under the terms of the MIT open source license.
