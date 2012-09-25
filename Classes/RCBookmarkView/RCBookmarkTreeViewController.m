//
//  RCBookmarkTreeViewController.m
//  browserHD
//
//  Created by imac on 12-9-13.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCBookmarkTreeViewController.h"
#import "RCRecordData.h"
#import "RCFolderEditingViewController.h"
#import "CoreDataManager+BookMark.h"

@interface RCBookmarkTreeViewController ()<RCFolderTableDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) NSMutableArray* listContent;
@property (nonatomic,strong) Folder* currentFolder;
@end

@implementation RCBookmarkTreeViewController
@synthesize listContent = _listContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RCFolderTreeViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.listContent = [NSMutableArray array];
        self.currentFolder = [[CoreDataManager defaultManager] getFolderByUnique:[NSNumber numberWithInt:0]];
    }
    return self;
}

-(void)setDelegate:(NSObject<RCBookmarkTreeViewControllerDelegate> *)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        [self.delegate bookmarkFolderSelected:[self.listContent objectAtIndex:0]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
	// Do any additional setup after loading the view.
    [self.leftNavButton setBackgroundImage:[UIImage imageNamed:@"bookmark_leftEdit_normal"] forState:UIControlStateNormal];
    [self.leftNavButton setBackgroundImage:[UIImage imageNamed:@"bookmark_leftEdit_hite"] forState:UIControlStateHighlighted];
    [self.leftNavButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 73-32)];
    [self.leftNavButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [self.leftNavButton setImage:[UIImage imageNamed:@"bookmark_leftEdit_sign"] forState:UIControlStateNormal];
    [self.leftNavButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.leftNavButton addTarget:self action:@selector(handleLeftNavButton) forControlEvents:UIControlEventTouchUpInside];
    self.leftNavButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.rightNavButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [self.rightNavButton setBackgroundImage:[UIImage imageNamed:@"bookmark_leftClear_normal"] forState:UIControlStateNormal];
    [self.rightNavButton setBackgroundImage:[UIImage imageNamed:@"bookmark_leftClear_hite"] forState:UIControlStateHighlighted];
    [self.rightNavButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 73-32)];
    [self.rightNavButton setImage:[UIImage imageNamed:@"bookmark_leftClear_sign"] forState:UIControlStateNormal];
    [self.rightNavButton setTitle:@"清空" forState:UIControlStateNormal];
    [self.rightNavButton addTarget:self action:@selector(handleRightNavButton) forControlEvents:UIControlEventTouchUpInside];

    self.rightNavButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    self.navBar.frame = CGRectMake(0, -50, self.view.bounds.size.width, 50);
    self.tableTree.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.tableTree.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_leftTableBG"]];
    self.tableTree.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableTree.tableView.rowHeight = 50;
    self.tableTree.tableView.allowsSelectionDuringEditing = YES;
    self.tableTree.delegate = self;
    self.tableTree.cellBG = [UIImage imageNamed:@"bookmark_cellBG_lv2"];
    self.tableTree.selectedCellBG = [UIImage imageNamed:@"bookmark_leftCellSBG"];

    [self reloadData];
    [self.tableTree.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [self.delegate bookmarkFolderSelected:[self.listContent objectAtIndex:0]];
}



-(void)reloadData
{
    [self.listContent removeAllObjects];
    self.listContent = [[CoreDataManager defaultManager] sharedFolderList];
    [self.tableTree setUpData:self.listContent];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath* index = [self.tableTree.tableView indexPathForSelectedRow];
    [self reloadData];
    [self.tableTree.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.delegate bookmarkFolderSelected:[self.listContent objectAtIndex:0]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        if (_editing) {
            self.navBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.navBar.frame.size.height);// CGRectOffset(self.navBar.frame, 0, self.navBar.frame.size.height);
            self.tableTree.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.navBar.frame));
        }else{
            self.navBar.frame = CGRectMake(0, -self.navBar.frame.size.height, self.view.bounds.size.width, self.navBar.frame.size.height);//CGRectOffset(self.navBar.frame, 0, -self.navBar.frame.size.height);
            self.tableTree.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.bounds.size.width, self.view.bounds.size.height);
        }
        NSIndexPath* index = [self.tableTree.tableView indexPathForSelectedRow];
        [self.tableTree setEditing:_editing animated:YES];
        [self.tableTree.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}


-(void)handleLeftNavButton
{
    RCFolderEditingViewController *vc = [[RCFolderEditingViewController alloc] init];
    
    vc.editingMode = FolderEditingModeCreat;
    vc.mainVC = self;
    NSIndexPath* index = [self.tableTree.tableView indexPathForSelectedRow];
    if (index) {
        vc.folder = [self.listContent objectAtIndex:index.row];
    }

    [self.navigationController pushViewController:vc animated:YES];
    [vc setupViews];
}

-(void)handleRightNavButton
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空收藏夹？" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"清空"]) {
        if ([alertView.title isEqualToString:@"确认清空收藏夹？"]) {
            Folder* root = [[CoreDataManager defaultManager] getFolderByUnique:[NSNumber numberWithInt:0]];
            [root removeBookmarks:root.bookmarks];
            [root removeChild:root.child];
            [[CoreDataManager defaultManager] saveContext];
            
            NSIndexPath* index = [self.tableTree.tableView indexPathForSelectedRow];
            [self reloadData];
            [self.tableTree.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.delegate bookmarkFolderSelected:[self.listContent objectAtIndex:0]];
        }
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma  mark - RCFolderTableDelegate
-(void)FolderTable:(RCFolderTable *)table folderSelected:(Folder *)folder isEditing:(BOOL)editing
{
    if (editing) {
        if (folder.level.intValue != 0) {
            RCFolderEditingViewController *vc = [[RCFolderEditingViewController alloc] init];
            vc.editingMode = FolderEditingModeEdit;
            vc.mainVC = self;
            vc.folder = folder;
            [self.navigationController pushViewController:vc animated:YES];
            [vc setupViews];
        }

    }else{
        [self.delegate bookmarkFolderSelected:folder];
    }

}

-(void)FolderTable:(RCFolderTable *)table folderDeleted:(Folder *)folder
{
    [[CoreDataManager defaultManager].managedObjectContext deleteObject:folder];
    [self reloadData];
    [self.tableTree.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}


@end
