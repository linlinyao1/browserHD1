//
//  RCHistoryView.m
//  browserHD
//
//  Created by imac on 12-9-18.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCHistoryView.h"
#import "RCRecordData.h"
#import "EGOImageLoader.h"
#import "UIImage+Thumbnail.h"

@interface RCHistoryView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView* leftTable;
@property (nonatomic,strong) UITableView* rightTable;
@property (nonatomic,strong) NSMutableArray* listContent;
@property (nonatomic,strong) NSMutableArray* historyRange;
@end

@implementation RCHistoryView

-(void)clearHistory
{
    [RCRecordData updateRecord:nil ForKey:RCRD_HISTORY];
    [RCRecordData updateRecord:nil ForKey:RCRD_FAV];
    [self tableView:self.leftTable didSelectRowAtIndexPath:[self.leftTable indexPathForSelectedRow]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = RCViewAutoresizingInternal;
        // Initialization code
        self.listContent = [NSMutableArray array];

        self.leftTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 225, frame.size.height) style:UITableViewStylePlain];
        self.leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.leftTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_leftTableBG"]];
        self.leftTable.dataSource = self;
        self.leftTable.delegate = self;
        [self addSubview:self.leftTable];
        
        self.rightTable = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftTable.frame), 0, self.bounds.size.width-CGRectGetMaxX(self.leftTable.frame), self.bounds.size.height) style:UITableViewStylePlain];
        self.rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rightTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_rightTableBG"]];
        self.rightTable.dataSource = self;
        self.rightTable.delegate = self;
        [self addSubview:self.rightTable];
        
        self.historyRange = [NSMutableArray arrayWithObjects:@"今天",@"昨天",@"最近一周",@"最近一月",@"更早", nil];
        [self.leftTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.leftTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    return self;
}

-(void)layoutSubviews
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.leftTable.frame = CGRectMake(0, 0, 300, self.bounds.size.height);
    }else{
        self.leftTable.frame = CGRectMake(0, 0, 225, self.bounds.size.height);

    }
    self.rightTable.frame = CGRectMake(CGRectGetMaxX(self.leftTable.frame), 0, self.bounds.size.width-CGRectGetMaxX(self.leftTable.frame), self.bounds.size.height);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView == self.leftTable) {
        count = self.historyRange.count;
    }else if (tableView == self.rightTable){
        count = self.listContent.count;
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTable) {
        static NSString* leftCell = @"left cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:leftCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCell];
            cell.imageView.image = [UIImage imageNamed:@"historyImage"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark_cellBG_lv2"]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark_leftCellSBG"]];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        cell.textLabel.text = [self.historyRange objectAtIndex:indexPath.row];
        return cell;
    }else if(tableView == self.rightTable){
        static NSString* rightCell = @"right cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:rightCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:rightCell];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark_rightCellBG"]];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        }
        BookmarkObject* history = [self.listContent objectAtIndex:indexPath.row];
        cell.textLabel.text = history.name;
        cell.detailTextLabel.text = history.url.absoluteString;
        
        NSURL* url = history.url;
        UIImage* image = [[EGOImageLoader sharedImageLoader] imageForURL:[[NSURL alloc] initWithScheme:[url scheme] host:[url host] path:@"/favicon.ico"] shouldLoadWithObserver:nil];
        if (!image) {
            image = [UIImage imageNamed:@"tab_newtab"];
        }
        cell.imageView.image = [image makeThumbnailOfSize:CGSizeMake(20, 20)];
        return cell;
    }
    
    return nil;
}

//-(NSMutableArray* )getHistorysByRange:(NSString*)range
//{
//    NSMutableArray* array = [NSMutableArray array];
//    
//    NSMutableArray* historys = [RCRecordData recordDataWithKey:RCRD_HISTORY];
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlag = NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit;
//    
//    if ([range isEqualToString:@"今天"]) {
//        for (BookmarkObject* history in historys) {
//            NSDateComponents* todayComponents = [calendar components:unitFlag fromDate:[NSDate date]];
//            NSDateComponents* historyComponents = [calendar components:unitFlag fromDate:history.date];
//            if ( todayComponents.year == historyComponents.year && todayComponents.month == historyComponents.month && todayComponents.day == historyComponents.day) {
//                [array addObject:history];
//            }
//        }
//    }else if([range isEqualToString:@"昨天"]){
//        for (BookmarkObject* history in historys) {
//            NSTimeInterval secondsPerDay = 24 * 60 * 60;
//            NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
//            NSDateComponents* yestodayComponents = [calendar components:unitFlag fromDate:yearsterDay];
//            NSDateComponents* historyComponents = [calendar components:unitFlag fromDate:history.date];
//            if ( yestodayComponents.year == historyComponents.year && yestodayComponents.month == historyComponents.month && yestodayComponents.day == historyComponents.day) {
//                [array addObject:history];
//            }
//        }
//    }else if ([range isEqualToString:@"最近一周"]){
//        for (BookmarkObject* history in historys) {
//            NSTimeInterval secondsPerDay = 7 * 24 * 60 * 60;
//            NSDate *monthearlier =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
//            NSMutableArray* today = [self getHistorysByRange:@"今天"];
//            NSMutableArray* yestoday = [self getHistorysByRange:@"昨天"];
//            if ([history.date compare:monthearlier]>0 ) {
////                for (BookmarkObject* obj in today) {
////                    if ([history.url.absoluteString isEqualToString:obj.url.absoluteString]) {
////                        <#statements#>
////                    }
////                }
//                if ([today indexOfObjectIdenticalTo:history]==NSNotFound && [yestoday indexOfObjectIdenticalTo:history]==NSNotFound) {
//                    [array addObject:history];
//                }
//            }
//        }
//    }else if ([range isEqualToString:@"最近一月"]){
//        for (BookmarkObject* history in historys) {
//            NSTimeInterval secondsPerDay = 30 * 24 * 60 * 60;
//            NSDate *monthearlier =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
//            NSMutableArray* lastweek = [self getHistorysByRange:@"最近一周"];
//            if ([history.date compare:monthearlier]>0) {
//                if ([lastweek indexOfObjectIdenticalTo:history]==NSNotFound) {
//                    [array addObject:history];
//                }
//            }
//        }
//    }else if ([range isEqualToString:@"更早"]){
//        for (BookmarkObject* history in historys) {
//            NSTimeInterval secondsPerDay = 30 * 24 * 60 * 60;
//            NSDate *monthearlier =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
//            if ([history.date compare:monthearlier]< 0) {
//                [array addObject:history];
//            }
//        }
//    }
//    return array;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTable) {
        [self.listContent removeAllObjects];
        NSMutableArray* historys = [RCRecordData recordDataWithKey:RCRD_HISTORY];

        NSString* range = [self.historyRange objectAtIndex:[self.leftTable indexPathForSelectedRow].row];
//        self.listContent = [self getHistorysByRange:range];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlag = NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit;
        
        if ([range isEqualToString:@"今天"]) {
            for (BookmarkObject* history in historys) {
                NSDateComponents* todayComponents = [calendar components:unitFlag fromDate:[NSDate date]];
                NSDateComponents* historyComponents = [calendar components:unitFlag fromDate:history.date];
                if ( todayComponents.year == historyComponents.year && todayComponents.month == historyComponents.month && todayComponents.day == historyComponents.day) {
                    [self.listContent addObject:history];
                }
            }
        }else if([range isEqualToString:@"昨天"]){
            for (BookmarkObject* history in historys) {
                NSTimeInterval secondsPerDay = 24 * 60 * 60;
                NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
                NSDateComponents* yestodayComponents = [calendar components:unitFlag fromDate:yearsterDay];
                NSDateComponents* historyComponents = [calendar components:unitFlag fromDate:history.date];
                if ( yestodayComponents.year == historyComponents.year && yestodayComponents.month == historyComponents.month && yestodayComponents.day == historyComponents.day) {
                    [self.listContent addObject:history];
                }
            }
        }else if ([range isEqualToString:@"最近一周"]){
            for (BookmarkObject* history in historys) {
                NSTimeInterval secondsPerDay = 7 * 24 * 60 * 60;
                NSDate *monthearlier =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
                if ([history.date compare:monthearlier]>0 ) {
                    [self.listContent addObject:history];
                }
            }
        }else if ([range isEqualToString:@"最近一月"]){
            for (BookmarkObject* history in historys) {
                NSTimeInterval secondsPerDay = 30 * 24 * 60 * 60;
                NSDate *monthearlier =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
                if ([history.date compare:monthearlier]>0) {
                    [self.listContent addObject:history];
                }
            }
        }else if ([range isEqualToString:@"更早"]){
            for (BookmarkObject* history in historys) {
                NSTimeInterval secondsPerDay = 30 * 24 * 60 * 60;
                NSDate *monthearlier =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
                if ([history.date compare:monthearlier]< 0) {
                    [self.listContent addObject:history];
                }
            }
        }
        
        [self.rightTable reloadData];
    }else if (tableView == self.rightTable){
        BookmarkObject* history = [self.listContent objectAtIndex:indexPath.row];
        [self.delegate historyURLSelected:history.url];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTable) {
        return NO;
    }
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.rightTable) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            BookmarkObject* history = [self.listContent objectAtIndex:indexPath.row];
            NSMutableArray* historys = [RCRecordData recordDataWithKey:RCRD_HISTORY];
            for (BookmarkObject* obj in historys) {
                if ([obj.url.absoluteString isEqualToString:history.url.absoluteString]) {
                    [historys removeObject:obj];
                    [RCRecordData updateRecord:historys ForKey:RCRD_HISTORY];
                    [self tableView:self.leftTable didSelectRowAtIndexPath:[self.leftTable indexPathForSelectedRow]];
                    return;
                }
            }
        }
    }
}


@end
