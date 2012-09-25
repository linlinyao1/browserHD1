//
//  RCSettingViewController.m
//  browserHD
//
//  Created by imac on 12-8-22.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCSettingViewController.h"

@interface RCSettingViewController ()

@end

@implementation RCSettingViewController

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (IBAction)settingComplete {
    [self dismissModalViewControllerAnimated:YES];
}

@end
