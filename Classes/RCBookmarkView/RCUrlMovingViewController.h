//
//  RCUrlMovingViewController.h
//  browserHD
//
//  Created by imac on 12-9-18.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCFolderTable.h"
#import "RCUrlViewController.h"

@interface RCUrlMovingViewController : UIViewController
@property (nonatomic,strong) NSMutableArray* movingArray;
@property (nonatomic,assign) RCUrlViewController* mainVC;
@property (nonatomic,strong) Folder* folder;
@end
