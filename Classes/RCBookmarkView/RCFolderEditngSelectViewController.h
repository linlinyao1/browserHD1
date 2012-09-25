//
//  RCFolderEditngSelectViewController.h
//  browserHD
//
//  Created by imac on 12-9-18.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCFolderEditingViewController.h"

@interface RCFolderEditngSelectViewController : UIViewController
@property (nonatomic,assign) RCFolderEditingViewController *mainVC;\
@property (nonatomic,strong) Folder* folder;
@end
