//
//  RCBookmarkView.m
//  browserHD
//
//  Created by imac on 12-9-10.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCBookmarkView.h"
#import "RCSegment.h"
#import "RCFolderViewController.h"
#import "RCRecordData.h"
#import "RCUrlViewController.h"
#import "RCBookmarkTreeViewController.h"
#import "RCHistoryView.h"
#import "UIImage+Thumbnail.h"

@interface RCBookmarkView ()<RCSegmentDelegate,RCBookmarkTreeViewControllerDelegate,RCUrlViewControllerDelegate,RCHistoryViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIView *navBar;
@property (nonatomic,strong) RCBookmarkTreeViewController* leftTableController;
@property (nonatomic,strong) UINavigationController *leftNavController;
@property (nonatomic,strong) RCUrlViewController* rightTableController;
@property (nonatomic,strong) UINavigationController *rightNavController;

@property (nonatomic,strong) RCHistoryView* historyView;

@property (unsafe_unretained, nonatomic) IBOutlet RCSegment *segment;

@property (nonatomic,strong) NSMutableArray*leftContentList;

@end

@implementation RCBookmarkView
@synthesize rootVC = _rootVC;
@synthesize navBar = _navBar;
@synthesize leftTableController = _leftTableController;
@synthesize leftNavController = _leftNavController;
@synthesize rightTableController = _rightTableController;
@synthesize rightNavController = _rightNavController;
@synthesize segment = _segment;
@synthesize leftContentList = _leftContentList;
@synthesize editing = _editing;


-(id)init
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RCBookmarkView" owner:nil options:nil];
    self = [arr objectAtIndex:0];
    if (self) {
        self.navBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_navBG"]];
        self.segment.firstImage = [UIImage imageNamed:@"bookmark_segment1"];
        self.segment.secondImage = [UIImage imageNamed:@"bookmark_segment2"];
        [self.segment setSelectIndex:0];
        self.segment.delegate = self;
        
        RCBookmarkTreeViewController* lefttable = [[RCBookmarkTreeViewController alloc] initWithNibName:nil bundle:nil];
        lefttable.view.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), 225, self.bounds.size.height-CGRectGetMaxY(self.navBar.frame));
//        [lefttable layOutViews];
        
        UINavigationController *leftnav = [[UINavigationController alloc] initWithRootViewController:lefttable];
        [leftnav setNavigationBarHidden:YES];
        self.leftTableController = lefttable;
        self.leftNavController = leftnav;
        [self addSubview:leftnav.view];

        
        RCUrlViewController* righttable = [[RCUrlViewController alloc] init];
        righttable.view.frame = CGRectMake(CGRectGetMaxX(lefttable.view.frame), CGRectGetMaxY(self.navBar.frame), self.bounds.size.width-CGRectGetMaxX(lefttable.view.frame), self.bounds.size.height-CGRectGetMaxY(self.navBar.frame));
        [righttable setupNavBar];
        righttable.delegate = self;
        UINavigationController *rightnav = [[UINavigationController alloc] initWithRootViewController:righttable];
        [rightnav setNavigationBarHidden:YES];
        self.rightTableController = righttable;
        self.rightNavController = rightnav;
        [self addSubview:rightnav.view];
        
        lefttable.delegate = self;
    }
    return self;
}

-(void)layoutSubviews
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.leftNavController.view.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), 300, self.bounds.size.height-CGRectGetMaxY(self.navBar.frame));
    }else{
        self.leftNavController.view.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), 225, self.bounds.size.height-CGRectGetMaxY(self.navBar.frame));
    }
    self.rightNavController.view.frame = CGRectMake(CGRectGetMaxX(self.leftNavController.view.frame), CGRectGetMaxY(self.navBar.frame), self.bounds.size.width-CGRectGetMaxX(self.leftNavController.view.frame), self.bounds.size.height-CGRectGetMaxY(self.navBar.frame));
    
    [self bringSubviewToFront:self.navBar];
}


- (IBAction)dismissButtonTap:(UIButton *)sender {
    [self.rootVC reloadHomePage];
    [self removeFromSuperview];
}


- (IBAction)editingButtonTap:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"清空"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空历史记录？" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
        [alert show];
        return;
    }else{
        [UIView animateWithDuration:.2 animations:^{
            if (!self.editing) {
                [sender setTitle:@"完成" forState:UIControlStateNormal];
                self.editing = YES;
                self.leftTableController.editing = YES;
                self.rightTableController.editing = YES;
            }else{
                self.editing = NO;
                [sender setTitle:@"编辑" forState:UIControlStateNormal];
                self.leftTableController.editing = NO;
                self.rightTableController.editing = NO;
                [self.leftNavController popToRootViewControllerAnimated:NO];
                [self.rightNavController popToRootViewControllerAnimated:NO];
            }
        }];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"清空"]) {
        if ([alertView.title isEqualToString:@"确认清空历史记录？"]) {
//            [RCRecordData updateRecord:nil ForKey:RCRD_HISTORY];
            [self.historyView clearHistory];
        }
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

-(void)bookmarkFolderSelected:(Folder *)folder
{
//    NSMutableArray* array = [[[folder.bookmarks allObjects] sortedArrayUsingComparator:^NSComparisonResult(Bookmark* obj1, Bookmark* obj2) {
//        return [obj1.createDate compare:obj2.createDate];
//    }] mutableCopy];
    
    self.rightTableController.folder = folder;
//    [self.rightTableController.tableView reloadData];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        self.rootVC.DashBoardFav.enabled = NO;
    }else{
        self.rootVC.DashBoardFav.enabled = YES;
    }
}

#pragma mark -RCSegmentDelegate

-(void)segment:(RCSegment *)segment selectionChange:(NSInteger)newIndex
{
    if (newIndex == 1) {
        RCHistoryView* historyView = [[RCHistoryView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.bounds.size.width, self.leftTableController.view.bounds.size.height)];
        self.historyView = historyView;
//        self.rightNavButton.hidden = YES;
        self.historyView.delegate = self;
        [self addSubview:historyView];
        
//        UIImage* image = [UIImage imageNamed:@"historyClear"];
        [self.rightNavButton setBackgroundImage:[UIImage imageNamed:@"historyClear"] forState:UIControlStateNormal];
        [self.rightNavButton setTitle:@"清空" forState:UIControlStateNormal];

        if (self.editing) {
            self.editing = NO;
            self.leftTableController.editing = NO;
            self.rightTableController.editing = NO;
            [self.leftNavController popToRootViewControllerAnimated:NO];
            [self.rightNavController popToRootViewControllerAnimated:NO];
        }
    }else{
        if (self.historyView) {
            [self.historyView removeFromSuperview];
            self.historyView = nil;
//            self.rightNavButton.hidden = NO;
            
            [self.rightNavButton setBackgroundImage:[UIImage imageNamed:@"bookmark_navEdit_normal"] forState:UIControlStateNormal];
            [self.rightNavButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
    }
    

}

-(void)urlNeedToBelunched:(NSURL *)url
{
    [self removeFromSuperview];
    [self.rootVC loadUrlforCurrentTab:url];
}

-(void)historyURLSelected:(NSURL *)url
{
    [self removeFromSuperview];
    [self.rootVC loadUrlforCurrentTab:url];
}

@end
