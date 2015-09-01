//
//  Bridging.h
//  MyKit
//
//  Created by Hai Nguyen on 8/31/15.
//
//

@import XCTest;

#if TARGET_OS_MAC
    @import MyKitOSX;
#elif TARGET_OS_IPHONE
    @import MyKitiOS;
#endif