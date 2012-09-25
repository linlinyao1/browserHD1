//
//  RCFolderSelectViewController.m
//  browserHD
//
//  Created by imac on 12-9-17.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderSelectViewController.h"

@interface RCFolderSelectViewController ()<RCFolderTableDelegate>
@property (nonatomic,strong) RCFolderTable* folderTable;
@end

@implementation RCFolderSelectViewController
@synthesize folderTable = _folderTable;
@synthesize mainVC = _mainVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.folderTable = [[RCFolderTable alloc] initWithFrame:self.view.bounds];
    self.folderTable.isPopup = YES;
    [self.view addSubview:self.folderTable];
    self.folderTable.delegate = self;
    [self.folderTable setUpData:[[CoreDataManager defaultManager] sharedFolderList]];
    
//    UIBarButtonItem* add = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleBordered target:self action:@selector(handleAddNew:)];
//    self.navigationItem.rightBarButtonItem = add;
    
}


-(void)handleAddNew:(UIButton*)button
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)FolderTable:(RCFolderTable *)table folderSelected:(Folder *)folder isEditing:(BOOL)editing
{
    if (!editing) {
        self.mainVC.folder = folder;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)FolderTable:(RCFolderTable *)table folderDeleted:(Folder *)folder
{
    
}

@end
