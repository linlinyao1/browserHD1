//
//  RCFolderEditingViewController.h
//  browserHD
//
//  Created by imac on 12-9-11.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager+BookMark.h"

enum {
    FolderEditingModeCreat=0,
    FolderEditingModeEdit
};
typedef NSInteger FolderEditingMode; 


@interface RCFolderEditingViewController : UIViewController
@property (nonatomic,assign) UIViewController* mainVC;
@property (nonatomic,strong) UITextField *titleField;
@property (nonatomic,assign) FolderEditingMode editingMode;
@property (nonatomic,strong) Folder* folder;
@property (nonatomic,strong) Folder* backupFolder;
-(void)setupViews;
@end
