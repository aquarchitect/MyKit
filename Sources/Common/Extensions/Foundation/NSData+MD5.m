//
//  NSData+MD5.m
//  MyKit
//
//  Created by Hai Nguyen on 7/11/17.
//
//

#import <CommonCrypto/CommonCrypto.h>
#import <NSData+MD5.h>

@implementation NSData (MD5)

- (NSString *)md5 {
    const char *cStr = [self bytes];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)[self length], digest);

    static NSString *format = @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x";

    return [NSString stringWithFormat: format,
          digest[0], digest[1],
          digest[2], digest[3],
          digest[4], digest[5],
          digest[6], digest[7],
          digest[8], digest[9],
          digest[10], digest[11],
          digest[12], digest[13],
          digest[14], digest[15]
    ];
}

@end
