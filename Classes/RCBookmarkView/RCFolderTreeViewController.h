//
//  RCFolderTreeViewController.h
//  browserHD
//
//  Created by imac on 12-9-13.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderTable.h"

@interface RCFolderTreeViewController : UIViewController
@property (unsafe_unretained, nonatomic) IBOutlet UIView *navBar;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *leftNavButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *rightNavButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *navTitle;

@property (unsafe_unretained, nonatomic) IBOutlet RCFolderTable *tableTree;
@end
