//
//  RCFolderAddNewViewController.m
//  browserHD
//
//  Created by imac on 12-9-18.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderAddNewViewController.h"

@interface RCFolderAddNewViewController ()
@property (nonatomic,strong) UITextField* titleField;
//@property (nonatomic,strong) UITextField* urlField;
@end

@implementation RCFolderAddNewViewController

-(void)setFolder:(Folder *)folder
{
    if (_folder != folder) {
        _folder = folder;
        [self.folderButton.button setTitle:folder.title forState:UIControlStateNormal];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.folder = [[CoreDataManager defaultManager] getFolderByUnique:[NSNumber numberWithInt:0]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(handleBackButton:)];
    self.navigationItem.leftBarButtonItem = back;
    
    
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(20, 27, 185, 31)];
    self.titleField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.titleField];
    
//    self.urlField = [[UITextField alloc] initWithFrame:CGRectOffset(self.titleField.frame, 0, 51)];
//    self.urlField.autoresizingMask = self.titleField.autoresizingMask;
//    [self.view addSubview:self.titleField];
    
    self.folderButton = [[RCFolderButton alloc] initWithFrame:CGRectOffset(self.titleField.frame, 0, 60)];
    self.folderButton.autoresizingMask = self.titleField.autoresizingMask;
    [self.folderButton.button addTarget:self action:@selector(handleFolderButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.folderButton];
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

-(void)handleBackButton:(UIBarButtonItem*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
