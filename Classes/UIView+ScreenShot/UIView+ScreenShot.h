//
//  UIView+ScreenShot.h
//  browserHD
//
//  Created by imac on 12-8-16.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ScreenShot)
-(UIImage*)screenShotImage;
-(UIImage*)screenShotImageWithRoundConor:(CGFloat) cornerRadius;
@end
