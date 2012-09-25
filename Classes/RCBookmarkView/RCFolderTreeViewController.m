//
//  RCFolderTreeViewController.m
//  browserHD
//
//  Created by imac on 12-9-13.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderTreeViewController.h"

@interface RCFolderTreeViewController ()

@end

@implementation RCFolderTreeViewController
@synthesize navBar = _navBar;
@synthesize leftNavButton = _leftNavButton;
@synthesize rightNavButton = _rightNavButton;
@synthesize navTitle = _navTitle;
@synthesize tableTree = _tableTree;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLeftNavButton:nil];
    [self setRightNavButton:nil];
    [self setNavTitle:nil];
    [self setNavBar:nil];
    [self setTableTree:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
