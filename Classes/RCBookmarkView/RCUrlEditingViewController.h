//
//  RCUrlEditingViewController.h
//  browserHD
//
//  Created by imac on 12-9-12.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager+BookMark.h"
#import "RCUrlViewController.h"

@interface RCUrlEditingViewController : UIViewController
@property (nonatomic,strong) Folder* folder;
@property (nonatomic,assign) RCUrlViewController* mainVC;
@end
