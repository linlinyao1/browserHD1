//
//  RCUrlEditingViewController.m
//  browserHD
//
//  Created by imac on 12-9-12.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCUrlEditingViewController.h"
#import "RCFolderButton.h"

@interface RCUrlEditingViewController ()
@property (nonatomic,strong) UIView *navBar;
@property (nonatomic,strong) UITextField *titleField;
@property (nonatomic,strong) UITextField *urlField;
@property (nonatomic,strong) UIButton *folderButton;
@end

@implementation RCUrlEditingViewController
@synthesize navBar = _navBar;
@synthesize titleField = _titleField;
@synthesize folderButton = _folderButton;


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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_rightTableBG"]];
    
    ////////////start of navBar////////////
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    self.navBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookmark_rightNavBG"]];// 
    self.navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.navBar];
    
    UIButton* buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancle setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    buttonCancle.frame = CGRectMake(5, 9, 73, 32);
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"bookmark_rightEdit_normal"] forState:UIControlStateNormal];
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"bookmark_rightEdit_hite"] forState:UIControlStateHighlighted];
    [buttonCancle setTitle:@"取消" forState:UIControlStateNormal];
    buttonCancle.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonCancle addTarget:self action:@selector(handleButtonCancle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:buttonCancle];
    
    UIButton* buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDone.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    buttonDone.frame = CGRectMake(self.navBar.bounds.size.width-73-5, 9, 73, 32);
    [buttonDone setBackgroundImage:[UIImage imageNamed:@"bookmaek_rightDone_normal"] forState:UIControlStateNormal];
    [buttonDone setBackgroundImage:[UIImage imageNamed:@"bookmark_rightDone_hite"] forState:UIControlStateHighlighted];
    [buttonDone setTitle:@"完成" forState:UIControlStateNormal];
    buttonDone.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonDone addTarget:self action:@selector(handleButtonDone:) forControlEvents:UIControlEventTouchUpInside];

    [self.navBar addSubview:buttonDone];
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.navBar.bounds.size.width*0.82, 27)];
    self.titleField.placeholder = @"标题";
    self.titleField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleField.center = CGPointMake(self.navBar.bounds.size.width/2, 100);
    [self.view addSubview:self.titleField];
    
    self.urlField = [[UITextField alloc] initWithFrame:CGRectOffset(self.titleField.frame, 0, 55)];
    self.urlField.placeholder = @"地址";
    self.urlField.autoresizingMask = self.titleField.autoresizingMask;
    self.urlField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.urlField];
//    RCFolderButton* folderButton = [[RCFolderButton alloc] initWithFrame:CGRectOffset(self.titleField.frame, 0, 50)];
//    folderButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:folderButton];
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
    if (self.titleField.text.length == 0) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"标题不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
//    if (self.titleField.text.length > 40) {
//        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"标题不能超过20字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    if (self.urlField.text.length == 0) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"链接不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString* string = self.urlField.text;
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:string];
    BOOL valid = NO;
    if (!url) {
        NSLog(@"invalid url");
    }else{
        if (!url.scheme.length) {
            url = [NSURL URLWithString:[@"http://" stringByAppendingString:url.absoluteString]];
        }
        if (url.host.length) {
            NSString * regex        =  @"^([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?$";//@"^(\\w)+(\\.)+(\\w)+$";//
            NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([pred evaluateWithObject:url.host]) {
                NSLog(@"valid url");
                valid = YES;
            }else{
                NSLog(@"invalid url");
            }
        }
    }

    if (valid) {
        [[CoreDataManager defaultManager] createBookmarkWithTitle:self.titleField.text Url:self.urlField.text Folder:self.folder];
        self.mainVC.folder = self.folder;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入有效的网址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    

}


@end
