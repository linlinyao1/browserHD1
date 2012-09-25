//
//  RCUrlViewController.h
//  browserHD
//
//  Created by imac on 12-9-12.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager+BookMark.h"

@protocol RCUrlViewControllerDelegate <NSObject>
-(void)urlNeedToBelunched:(NSURL*)url;
@end

@interface RCUrlViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL editing;
@property (nonatomic,strong) NSMutableArray* listContent;
@property (nonatomic,strong) Folder* folder;
@property (nonatomic,assign) NSObject<RCUrlViewControllerDelegate> *delegate;
-(void)setupNavBar;

@end
