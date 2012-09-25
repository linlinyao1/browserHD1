//
//  RCBookmarkView.h
//  browserHD
//
//  Created by imac on 12-9-10.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCViewController.h"
@interface RCBookmarkView : UIView
@property (nonatomic,assign) RCViewController *rootVC;
@property (nonatomic,assign)BOOL editing;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *rightNavButton;
@end
