//
//  MyKit.h
//  MyKit
//
//  Created by Hai Nguyen on 7/24/15.
//
//

#if defined(TARGET_IOS)
    @import UIKit;
#elif defined(TARGET_OSX)
    @import AppKit;
#endif

@import CoreData;
@import CoreLocation;
@import CloudKit;

//! Project version number for MyKit.
FOUNDATION_EXPORT double MyKitVersionNumber;

//! Project version string for MyKit.
FOUNDATION_EXPORT const unsigned char MyKitVersionString[];