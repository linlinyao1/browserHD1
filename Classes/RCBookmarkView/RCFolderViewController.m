//
//  RCFolderViewController.m
//  browserHD
//
//  Created by imac on 12-9-11.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderViewController.h"
#import "RCFolderEditingViewController.h"
#import "RCRecordData.h"


@interface RCFolderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *navBar;
//@property (nonatomic,strong) NSMutableArray* l;
@end

@implementation RCFolderViewController
@synthesize navBar = _navBar;
@synthesize editing = _editing;
//@synthesize contentList = _contentList;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 50)];
    self.navBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_cellBG_lv1"]];
    self.navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.navBar];
    
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.bounds.size.width, self.view.bounds.size.height);
    [self.tableView setUpData:[RCRecordData recordDataWithKey:RCRD_BOOKMARK]];
}

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

-(void)setupNavBar
{
    UIButton* buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    //    buttonAdd.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonAdd.frame = CGRectMake(5, 9, 73, 32);
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@"bookmark_leftEdit_normal"] forState:UIControlStateNormal];
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@"bookmark_leftEdit_hite"] forState:UIControlStateHighlighted];
    [buttonAdd setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 73-32)];
    [buttonAdd setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [buttonAdd setImage:[UIImage imageNamed:@"bookmark_leftEdit_sign"] forState:UIControlStateNormal];
    [buttonAdd setTitle:@"添加" forState:UIControlStateNormal];
    buttonAdd.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonAdd addTarget:self action:@selector(handleButtonAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:buttonAdd];
    
    UIButton* buttonClear = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonClear.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonClear.frame = CGRectMake(self.navBar.bounds.size.width-73-5, 9, 73, 32);
    [buttonClear setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [buttonClear setBackgroundImage:[UIImage imageNamed:@"bookmark_leftClear_normal"] forState:UIControlStateNormal];
    [buttonClear setBackgroundImage:[UIImage imageNamed:@"bookmark_leftClear_hite"] forState:UIControlStateHighlighted];
    [buttonClear setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 73-32)];
    [buttonClear setImage:[UIImage imageNamed:@"bookmark_leftClear_sign"] forState:UIControlStateNormal];
    [buttonClear setTitle:@"清空" forState:UIControlStateNormal];
    buttonClear.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navBar addSubview:buttonClear];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)handleButtonAdd:(UIButton*)sender
{
    RCFolderEditingViewController *vc = [[RCFolderEditingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setupViews];
}



@end
