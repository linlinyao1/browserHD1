//
//  RCUrlViewController.m
//  browserHD
//
//  Created by imac on 12-9-12.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCUrlViewController.h"
#import "RCUrlEditingViewController.h"
#import "EGOImageLoader.h"
#import "RCUrlMovingViewController.h"
#import "UIImage+Thumbnail.h"

@interface RCUrlViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UIView *navBar;
@property (nonatomic,strong) NSMutableArray* deleteArray;
@end

@implementation RCUrlViewController
@synthesize tableView = _tableView;
@synthesize navBar = _navBar;
@synthesize editing = _editing;
@synthesize listContent = _listContent;

-(void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        
        if (_editing) {
            self.navBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.navBar.frame.size.height);// CGRectOffset(self.navBar.frame, 0, self.navBar.frame.size.height);
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.navBar.frame));
        }else{
            self.navBar.frame = CGRectMake(0, -self.navBar.frame.size.height, self.view.bounds.size.width, self.navBar.frame.size.height);//CGRectOffset(self.navBar.frame, 0, -self.navBar.frame.size.height);
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.bounds.size.width, self.view.bounds.size.height);
        }
        [self.tableView setEditing:_editing animated:YES];
    }
}

-(void)setFolder:(Folder *)folder
{
//    if (_folder != folder) {
        _folder = folder;
        self.listContent = [[[folder.bookmarks allObjects] sortedArrayUsingComparator:^NSComparisonResult(Bookmark* obj1, Bookmark* obj2) {
            return [obj1.createDate compare:obj2.createDate];
        }] mutableCopy];
        [self.tableView reloadData];
//    }
}


-(void)setupNavBar
{
    UIButton* buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    //    buttonAdd.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonAdd.frame = CGRectMake(5, 9, 73, 32);
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@"bookmark_rightEdit_normal"] forState:UIControlStateNormal];
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@"bookmark_rightEdit_hite"] forState:UIControlStateHighlighted];
    [buttonAdd setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 73-32)];
    [buttonAdd setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [buttonAdd setImage:[UIImage imageNamed:@"bookmark_rightEdit_sign"] forState:UIControlStateNormal];
    [buttonAdd setTitle:@"添加" forState:UIControlStateNormal];
    buttonAdd.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonAdd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buttonAdd addTarget:self action:@selector(handleButtonAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:buttonAdd];
    
    
    UIButton* buttonClear = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonClear.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonClear.frame = CGRectMake(self.navBar.bounds.size.width-94-5, 9, 94, 32);
//    [buttonClear setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [buttonClear setBackgroundImage:[UIImage imageNamed:@"bookmark_rightClear_normal"] forState:UIControlStateNormal];
    [buttonClear setBackgroundImage:[UIImage imageNamed:@"bookmark_rightClear_hite"] forState:UIControlStateHighlighted];
    [buttonClear setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 94-32)];
    [buttonClear setImage:[UIImage imageNamed:@"bookmark_leftClear_sign"] forState:UIControlStateNormal];
    [buttonClear setTitle:@"删除所选" forState:UIControlStateNormal];
    buttonClear.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonClear addTarget:self action:@selector(handleButtonDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:buttonClear];
    
    
//    UIButton* buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonSelect.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
//    buttonSelect.frame = CGRectMake(buttonClear.frame.origin.x-94-5, 9, 94, 32);
//    [buttonSelect setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [buttonSelect setBackgroundImage:[UIImage imageNamed:@"bookmark_rightSelect_normal"] forState:UIControlStateNormal];
//    [buttonSelect setBackgroundImage:[UIImage imageNamed:@"bookmark_rightSelect_hite"] forState:UIControlStateHighlighted];
//    [buttonSelect setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 94-32)];
//    [buttonSelect setImage:[UIImage imageNamed:@"bookmark_rightSelect_sign"] forState:UIControlStateNormal];
//    [buttonSelect setTitle:@"选择全部" forState:UIControlStateNormal];
//    buttonSelect.titleLabel.font = [UIFont systemFontOfSize:15];
//    [buttonSelect addTarget:self action:@selector(handleButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBar addSubview:buttonSelect];
    
    UIButton* buttonMove = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMove.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonMove.frame = CGRectMake(buttonClear.frame.origin.x-94-5, 9, 94, 32);
    [buttonMove setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buttonMove setBackgroundImage:[UIImage imageNamed:@"bookmark_rightMove_normal"] forState:UIControlStateNormal];
    [buttonMove setBackgroundImage:[UIImage imageNamed:@"bookmark_rightMove_hite"] forState:UIControlStateHighlighted];
    [buttonMove setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 94-32)];
//    [buttonMove setTitleEdgeInsets:UIEdgeInsetsZero];
    [buttonMove setImage:[UIImage imageNamed:@"bookmark_rightMove_sign"] forState:UIControlStateNormal];
    [buttonMove setTitle:@"移动到" forState:UIControlStateNormal];
    buttonMove.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonMove addTarget:self action:@selector(handleButtonMove:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:buttonMove];
    
}

-(void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    ////////////start of navBar////////////
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 50)];
    self.navBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_rightNavBG"]];
    self.navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.navBar];
    ////////////end of navBar////////////
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_rightTableBG"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.view addSubview:self.tableView];
    self.deleteArray = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

-(void)handleButtonAdd:(UIButton*)sender
{
    RCUrlEditingViewController *vc = [[RCUrlEditingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    Bookmark* bookmark =[self.listContent objectAtIndex:0];
    vc.folder = self.folder;//bookmark.folder;
    vc.mainVC =self;
//    [vc setupViews];
}
-(void)handleButtonDelete:(UIButton*)sender
{
    if (self.deleteArray.count == 0) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"没有选中项" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除所选收藏网址？" message:@"删除后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"删除"]) {
        if ([alertView.title isEqualToString:@"确认删除所选收藏网址？"]) {
            for (Bookmark* bookmark in self.deleteArray) {
                [[CoreDataManager defaultManager].managedObjectContext deleteObject:bookmark];
            }
            [[CoreDataManager defaultManager] saveContext];
            self.folder = self.folder;
        }
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

-(void)handleButtonMove:(UIButton*)sender
{
    if (self.deleteArray.count == 0) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"没有选中项" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    RCUrlMovingViewController *vc = [[RCUrlMovingViewController alloc] init];
    vc.movingArray = self.deleteArray;
    vc.mainVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}
//-(void)handleButtonSelect:(UIButton*)sender
//{
//    for (int i = 0; i < [self.tableView numberOfSections]; i++) {
//        for (int j = 0; j < [self.tableView numberOfRowsInSection:i]; j++) {
//            NSUInteger ints[2] = {i,j};
//            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
//            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
////            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//            //Here is your code
//            
//        }
//    }
//}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listContent.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark_rightCellBG"]];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_cellBG_lv1"]];
    }
    Bookmark* bookmark = [self.listContent objectAtIndex:indexPath.row];
    
    cell.textLabel.text = bookmark.title;
    cell.detailTextLabel.text = bookmark.url;
    NSURL* url = [NSURL URLWithString:bookmark.url];
    UIImage* image = [[EGOImageLoader sharedImageLoader] imageForURL:[[NSURL alloc] initWithScheme:[url scheme] host:[url host] path:@"/favicon.ico"] shouldLoadWithObserver:nil];
    if (!image) {
        image = [UIImage imageNamed:@"tab_newtab"];
    }
    cell.imageView.image = [image makeThumbnailOfSize:CGSizeMake(20, 20)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        [self.deleteArray addObject:[self.listContent objectAtIndex:indexPath.row]];
    }else{
        Bookmark* bookmark = [self.listContent objectAtIndex:indexPath.row];
        [self.delegate urlNeedToBelunched:[NSURL URLWithString:bookmark.url]];
    }
//    RCFolderEditingViewController *vc = [[RCFolderEditingViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    [vc setupViews];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        Bookmark* bookmark =  [self.listContent objectAtIndex:indexPath.row];
        [self.deleteArray removeObjectIdenticalTo:bookmark];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle==UITableViewCellEditingStyleDelete) {
//
//    }
//}


@end
