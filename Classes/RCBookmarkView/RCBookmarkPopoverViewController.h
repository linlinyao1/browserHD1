//
//  RCBookmarkPopoverViewController.h
//  browserHD
//
//  Created by imac on 12-9-17.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager+BookMark.h"
#import "RCFolderButton.h"

@interface RCBookmarkPopoverViewController : UIViewController
@property (nonatomic,assign) UIPopoverController* popover;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *bookmarkTitle;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *bookmarkUrl;
@property (nonatomic,strong) RCFolderButton* bookmarkFolder;

@property (nonatomic,strong) Folder* folder;
@end
