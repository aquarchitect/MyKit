//
//  NSData+MD5.h
//  MyKit
//
//  Created by Hai Nguyen on 7/11/17.
//
//

// as CommonCrypto doesn't provide a public header for Swift,
// this is implemented in Objective-C and bridge via private module
// under MyKit/PrivateModule/module.modulemap.

#import <Foundation/Foundation.h>

@interface NSData (MD5) // message digest algorithm 5

@property (readonly) NSString* md5;

@end
