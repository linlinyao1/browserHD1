//
//  RCTreeTable.h
//  Examinations
//
//  Created by imac on 12-9-12.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitle @"title"
#define kUrl @"url"
#define kIsFolder @"isFolder"


@interface RCTreeTable : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImage *cellBG;
@property (nonatomic,strong) UIImage *selectedCellBG;

-(void)setUpData:(NSMutableArray*)data;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

-(NSString*)nameForCurrentFolder;
@end
