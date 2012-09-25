//
//  RCBookmarkPopoverViewController.m
//  browserHD
//
//  Created by imac on 12-9-17.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCBookmarkPopoverViewController.h"
#import "RCFolderSelectViewController.h"

@interface RCBookmarkPopoverViewController ()

@end

@implementation RCBookmarkPopoverViewController
@synthesize bookmarkTitle = _bookmarkTitle;
@synthesize bookmarkUrl = _bookmarkUrl;
@synthesize bookmarkFolder = _bookmarkFolder;
@synthesize popover = _popover;
@synthesize folder = _folder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"添加收藏";
        self.folder = [[CoreDataManager defaultManager] getFolderByUnique:[NSNumber numberWithInt:0]];
    }
    return self;
}

-(void)setFolder:(Folder *)folder
{
    if (_folder != folder) {
        _folder = folder;
        [self.bookmarkFolder.button setTitle:folder.title forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(handleBackButton:)];
    self.navigationItem.leftBarButtonItem = back;
    
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(handleDoneButton:)];
    self.navigationItem.rightBarButtonItem = done;
    
    self.bookmarkFolder = [[RCFolderButton alloc] initWithFrame:CGRectOffset(self.bookmarkUrl.frame, 0, 60)];
    self.bookmarkFolder.autoresizingMask = self.bookmarkTitle.autoresizingMask;
    [self.bookmarkFolder.button addTarget:self action:@selector(handleFolderButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bookmarkFolder];
    
    [self.bookmarkTitle becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setBookmarkTitle:nil];
    [self setBookmarkUrl:nil];
    [self setBookmarkFolder:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)handleBackButton:(UIBarButtonItem*)sender
{
    [self.popover dismissPopoverAnimated:YES];
}

-(void)handleDoneButton:(UIBarButtonItem*)sender
{
    if (self.bookmarkTitle.text.length == 0) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"标题不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (self.bookmarkUrl.text.length == 0) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"链接不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [[CoreDataManager defaultManager] createBookmarkWithTitle:self.bookmarkTitle.text Url:self.bookmarkUrl.text Folder:self.folder];
    
    [self.popover dismissPopoverAnimated:YES];
}

-(void)handleFolderButton:(UIButton*)sender
{
    RCFolderSelectViewController* vc = [[RCFolderSelectViewController alloc] init];
    vc.mainVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
