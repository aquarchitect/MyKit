//
//  Bridging.h
//  MyKit-iOSDemo
//
//  Created by Hai Nguyen on 3/29/16.
//
//

#if TARGET_OS_IPHONE
    @import UIKit;
#elif TARGET_OS_MAC
    @import AppKit;
#endif

@import MyKit;