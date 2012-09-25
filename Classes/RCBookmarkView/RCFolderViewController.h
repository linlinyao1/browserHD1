//
//  RCFolderViewController.h
//  browserHD
//
//  Created by imac on 12-9-11.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSimpleFolderViewController.h"

@interface RCFolderViewController : RCSimpleFolderViewController

@property (nonatomic,assign) BOOL editing;

-(void)setupNavBar;
@end
