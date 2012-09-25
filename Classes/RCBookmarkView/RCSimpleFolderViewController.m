//
//  RCSimpleFolderViewController.m
//  browserHD
//
//  Created by imac on 12-9-13.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCSimpleFolderViewController.h"

@interface RCSimpleFolderViewController ()

@end

@implementation RCSimpleFolderViewController
@synthesize tableView = _tableView;


-(void)loadView
{
    [super loadView];
    
    self.tableView = [[RCFolderTable alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_leftTableBG"]];
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableView.rowHeight = 50;
    self.tableView.cellBG = [UIImage imageNamed:@"bookmark_cellBG_lv2"];
    self.tableView.selectedCellBG = [UIImage imageNamed:@"bookmark_leftCellSBG"];
    [self.view addSubview:self.tableView];    
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

@end
