//
//  UIView+ScreenShot.m
//  browserHD
//
//  Created by imac on 12-8-16.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "UIView+ScreenShot.h"
#import "QuartzCore/QuartzCore.h"

@implementation UIView (ScreenShot)


-(UIImage *)screenShotImage
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.bounds.size);
    
//    UIGraphicsBeginImageContext(self.bounds.size); //theView.bounds.size
    CGContextRef context =UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage *)screenShotImageWithRoundConor:(CGFloat)cornerRadius
{
    UIView *view = self;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    [view.layer renderInContext:context];
    UIImage *img =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
