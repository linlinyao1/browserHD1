//
//  UIColor+HexValue.m
//  browserHD
//
//  Created by imac on 12-9-3.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "UIColor+HexValue.h"

@implementation UIColor (HexValue)
+ (UIColor*)colorWithHexValue:(NSString*)hex {
    if (!hex) return nil;
    
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    
    NSString *rStr = nil, *gStr = nil, *bStr = nil, *aStr = nil;
    
    if (hex.length == 3) {
        rStr = [hex substringWithRange:NSMakeRange(0, 1)];
        rStr = [NSString stringWithFormat:@"%@%@", rStr, rStr];
        gStr = [hex substringWithRange:NSMakeRange(1, 1)];
        gStr = [NSString stringWithFormat:@"%@%@", gStr, gStr];
        bStr = [hex substringWithRange:NSMakeRange(2, 1)];
        bStr = [NSString stringWithFormat:@"%@%@", bStr, bStr];
        aStr = @"FF";
    } else if (hex.length == 4) {
        rStr = [hex substringWithRange:NSMakeRange(0, 1)];
        rStr = [NSString stringWithFormat:@"%@%@", rStr, rStr];
        gStr = [hex substringWithRange:NSMakeRange(1, 1)];
        gStr = [NSString stringWithFormat:@"%@%@", gStr, gStr];
        bStr = [hex substringWithRange:NSMakeRange(2, 1)];
        bStr = [NSString stringWithFormat:@"%@%@", bStr, bStr];
        aStr = [hex substringWithRange:NSMakeRange(3, 1)];
        aStr = [NSString stringWithFormat:@"%@%@", aStr, aStr];
    } else if (hex.length == 6) {
        rStr = [hex substringWithRange:NSMakeRange(0, 2)];
        gStr = [hex substringWithRange:NSMakeRange(2, 2)];
        bStr = [hex substringWithRange:NSMakeRange(4, 2)];
        aStr = @"FF";
    } else if (hex.length == 8) {
        rStr = [hex substringWithRange:NSMakeRange(0, 2)];
        gStr = [hex substringWithRange:NSMakeRange(2, 2)];
        bStr = [hex substringWithRange:NSMakeRange(4, 2)];
        aStr = [hex substringWithRange:NSMakeRange(6, 2)];
    } else {
        // Unknown encoding
        return nil;
    }
    
    unsigned r, g, b, a;
    [[NSScanner scannerWithString:rStr] scanHexInt:&r];
    [[NSScanner scannerWithString:gStr] scanHexInt:&g];
    [[NSScanner scannerWithString:bStr] scanHexInt:&b];
    [[NSScanner scannerWithString:aStr] scanHexInt:&a];
    
    if (r == g && g == b) {
        // Optimal case for grayscale
        return [UIColor colorWithWhite:(((CGFloat)r)/255.0f) alpha:(((CGFloat)a)/255.0f)];
    } else {
        return [UIColor colorWithRed:(((CGFloat)r)/255.0f) green:(((CGFloat)g)/255.0f) blue:(((CGFloat)b)/255.0f) alpha:(((CGFloat)a)/255.0f)];
    }
}
@end
