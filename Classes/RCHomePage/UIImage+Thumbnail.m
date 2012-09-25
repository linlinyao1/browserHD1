//
//  UIImage+Thumbnail.m
//  browserHD
//
//  Created by imac on 12-9-4.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "UIImage+Thumbnail.h"

@implementation UIImage (Thumbnail)
- (UIImage *) makeThumbnailOfSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    // draw scaled image into thumbnail context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
        NSLog(@"could not scale image");
    return newThumbnail;
}
@end
