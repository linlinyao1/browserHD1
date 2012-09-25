//
//  RCPrivacyViewController.m
//  browserHD
//
//  Created by imac on 12-9-20.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCPrivacyViewController.h"

@interface RCPrivacyViewController ()

@end

@implementation RCPrivacyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"隐私保护声明";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"隐私保护声明HD版" ofType:@"txt"];
    NSString* text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    UITextView* textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.autoresizingMask = RCViewAutoresizingALL;
    textView.font = [UIFont systemFontOfSize:20];
//    textView.contentSize = CGSizeMake(self.view.bounds.size.width, 1000);
    textView.text = text;
    textView.scrollEnabled = YES;
    textView.editable = NO;
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
