//
//  RCFolderEditngSelectViewController.m
//  browserHD
//
//  Created by imac on 12-9-18.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderEditngSelectViewController.h"
#import "RCFolderTable.h"

@interface RCFolderEditngSelectViewController ()<RCFolderTableDelegate>
@property (nonatomic,strong) UIView *navBar;
@property (nonatomic,strong) RCFolderTable* folderTable;

@end

@implementation RCFolderEditngSelectViewController

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
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    self.navBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_cellBG_lv1"]];
    self.navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.navBar];
    
    
    UIButton* buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    //    buttonAdd.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonCancle.frame = CGRectMake(5, 9, 73, 32);
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"bookmark_navEdit_normal"] forState:UIControlStateNormal];
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"bookmark_navEdit_hite"] forState:UIControlStateHighlighted];
    [buttonCancle setTitle:@"取消" forState:UIControlStateNormal];
    buttonCancle.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonCancle addTarget:self action:@selector(handleButtonCancle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:buttonCancle];
    
    UIButton* buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDone.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonDone.frame = CGRectMake(self.navBar.bounds.size.width-73-5, 9, 73, 32);
    [buttonDone setBackgroundImage:[UIImage imageNamed:@"bookmark_leftDone_normal"] forState:UIControlStateNormal];
    [buttonDone setBackgroundImage:[UIImage imageNamed:@"bookmark_leftDone_hite"] forState:UIControlStateHighlighted];
    [buttonDone setTitle:@"完成" forState:UIControlStateNormal];
    buttonDone.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonDone addTarget:self action:@selector(handleButtonDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:buttonDone];
    
    
    self.folderTable = [[RCFolderTable alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.navBar.frame))];
    self.folderTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.folderTable.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_leftTableBG"]];
    [self.view addSubview:self.folderTable];
    self.folderTable.delegate = self;
    [self.folderTable setUpData:[[CoreDataManager defaultManager] sharedFolderList]];
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

-(void)handleButtonCancle:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleButtonDone:(UIButton*)sender
{
    if (self.folder) {
        if (self.mainVC.editingMode == FolderEditingModeCreat) {
            self.mainVC.folder = self.folder;
        }else{
            if (self.folder.level.intValue > self.mainVC.folder.level.intValue) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"无法放到子文件夹中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            if (self.mainVC.folder != self.folder) {
                Folder* folder = self.mainVC.folder;
                folder.parent = self.folder;
//                self.mainVC.folder.parent = self.folder;
                folder.level = [NSNumber numberWithInt:folder.parent.level.intValue+1];
                self.mainVC.folder = folder;
            }
        }

    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)FolderTable:(RCFolderTable *)table folderSelected:(Folder *)folder isEditing:(BOOL)editing
{
    if (!editing) {
        self.folder = folder;
        //        self.mainVC.folder = folder;
        //        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)FolderTable:(RCFolderTable *)table folderDeleted:(Folder *)folder
{
    
}

@end
