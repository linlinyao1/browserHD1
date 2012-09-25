//
//  RCFolderAddNewViewController.h
//  browserHD
//
//  Created by imac on 12-9-18.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCFolderButton.h"
#import "CoreDataManager+BookMark.h"

@interface RCFolderAddNewViewController : UIViewController
@property (nonatomic,strong) RCFolderButton* folderButton;
@property (nonatomic,strong) Folder* folder;
@end
