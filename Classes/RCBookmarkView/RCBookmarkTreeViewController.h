//
//  RCBookmarkTreeViewController.h
//  browserHD
//
//  Created by imac on 12-9-13.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderTreeViewController.h"

@protocol RCBookmarkTreeViewControllerDelegate <NSObject>

-(void)bookmarkFolderSelected:(Folder*)folder;
@end

@interface RCBookmarkTreeViewController : RCFolderTreeViewController
@property (nonatomic,assign) BOOL editing;
@property (nonatomic,assign) NSObject<RCBookmarkTreeViewControllerDelegate> *delegate;
@end
