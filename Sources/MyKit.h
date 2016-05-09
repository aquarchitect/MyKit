//
//  MyKit.h
//  MyKit
//
//  Created by Hai Nguyen on 7/24/15.
//
//

/*
 * TARGET_OS_SIMULATOR, TARGET_OS_IPHONE, and TARGET_OS_MAC macros
 * require TargetConditionals module to work
 */
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
    @import UIKit;
#elif TARGET_OS_MAC
    @import AppKit;
#endif

@import CoreData;
@import CloudKit;

//! Project version number for MyKit.
FOUNDATION_EXPORT double MyKitVersionNumber;

//! Project version string for MyKit.
FOUNDATION_EXPORT const unsigned char MyKitVersionString[];