//
//  RCSettingViewController.m
//  browserHD
//
//  Created by imac on 12-8-30.
//  Copyright (c) 2012年 2345. All rights reserved.
//








#import "RCSettingViewController.h"
#import "RCSearchEngineSwitchViewController.h"
#import "RCRecordData.h"
#import "EGOCache.h"
#import "MobClick.h"
#import "UMFeedback.h"
#import "RCPrivacyViewController.h"

typedef enum {
    OptionSectionSearchEngine = 0,
    OptionSectionPrivate,
    OptionSectionUE,
    OptionSectionAbout,
    
    OptionSectionsCount
} OptionsTypeSections;


typedef enum {
    OptionSearchEngineType = 0,
    
    OptionSearchEngineCount
} OptionSearchEngine;

typedef enum {
    OptionPrivateHistory = 0,
    OptionPrivateCookies,
    OptionPrivateCache,
    
    OptionPrivateCount
} OptionPrivate;


typedef enum {
    OptionUEProtocol = 0,
    OptionUEPrivate,
    OptionUESuggestion,
    
    OptionUECount
} OptionUE;

typedef enum {
    OptionAbout2345 = 0,
    OptionAboutRating,
    OptionAboutUpdate,
    
    OptionAboutCount
} OptionAbout;


@interface RCSettingViewController ()<UIAlertViewDelegate>

@end


@implementation RCSettingViewController
@synthesize mainVC = _mainVC;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"浏览器设置";
    }
    return self;
}

-(void)handleDoneButton:(UIBarButtonItem*)sender{
    if ([self.mainVC respondsToSelector:@selector(reloadHomePage)]) {
        [self.mainVC performSelector:@selector(reloadHomePage)];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(handleDoneButton:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return OptionSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows = 0;
    switch (section) {
        case OptionSectionSearchEngine:
            rows = OptionSearchEngineCount;
            break;
        case OptionSectionPrivate:
            rows = OptionPrivateCount;
            break;
        case OptionSectionUE:
            rows = OptionUECount;
            break;
        case OptionSectionAbout:
            rows = OptionAboutCount;
            break;
    }    
    return rows;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section) {
        case OptionSectionSearchEngine:
            title = @"搜索引擎设置";
            break;
        case OptionSectionPrivate:
            title = @"隐私信息保护";
            break;
        case OptionSectionUE:
            title = @"个人体验";
            break;
//        case OptionSectionAbout:
//            title = OptionAboutCount;
//            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ([indexPath section] == OptionSectionSearchEngine)
//    {
//        static NSString *OptionSectionSearchEngineCellIdentifier = @"OptionSectionSearchEngine";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"value1Cell"];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:OptionSectionSearchEngineCellIdentifier];
//        }
//        
//        switch ([indexPath row])
//        {
//            case OptionSearchEngineType:
//            {
//                cell.textLabel.text = @"当前搜索引擎";
//                NSNumber *searchEngine = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchEngine"];
//                
//                cell.detailTextLabel.text = [RCSearchEngineSwitchViewController nameForSEtype:searchEngine.integerValue];
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }
//                break;
//        }
//        return cell;
//    }
    
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    
    if ([indexPath section] == OptionSectionSearchEngine)
    {
        switch ([indexPath row])
        {
            case OptionSearchEngineType:
            {
                cell.textLabel.text = @"当前搜索引擎";
                NSNumber *searchEngine = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchEngine"];
                
                cell.detailTextLabel.text = [RCSearchEngineSwitchViewController nameForSEtype:searchEngine.integerValue];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
        }
    }else if ([indexPath section] == OptionSectionPrivate) {
        switch ([indexPath row])
        {
            case OptionPrivateHistory:
            {
                cell.textLabel.text = @"清除历史记录";
            }
                break;
            case OptionPrivateCookies:
            {
                cell.textLabel.text = @"清除Cookies";
            }
                break;
            case OptionPrivateCache:
            {
                cell.textLabel.text = @"清除全部缓存";
            }
                break;
        }
    }else if ([indexPath section] == OptionSectionUE) {
        switch ([indexPath row])
        {
            case OptionUEProtocol:
            {
                cell.textLabel.text = @"产品使用许可协议"; // to be continue
                
//                UIImageView *indicator = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuDetailIndicate")] autorelease];
//                cell.accessoryView = indicator;
            }
                break;
            case OptionUEPrivate:
            {
                cell.textLabel.text = @"隐私保护声明"; // to be continue
//                UIImageView *indicator = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuDetailIndicate")] autorelease];
//                cell.accessoryView = indicator;
            }
                break;
            case OptionUESuggestion:
            {
                cell.textLabel.text = @"意见反馈"; // to be continue
            }
                break;
        }
    }else if ([indexPath section] == OptionSectionAbout) {
        switch ([indexPath row])
        {
            case OptionAbout2345:
            {
                cell.textLabel.text = @"关于2345"; // to be continue
//                UIImageView *indicator = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuDetailIndicate")] autorelease];
//                cell.accessoryView = indicator;
            }
                break;
            case OptionAboutRating:
            {
                cell.textLabel.text = @"给2345浏览器打分"; // to be continue
            }
                break;
            case OptionAboutUpdate:
            {
                cell.textLabel.text = @"检查更新"; // to be continue
            }
                break;
        }
    }

    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section] == OptionSectionSearchEngine)
    {
        switch ([indexPath row])
        {
            case OptionSearchEngineType:
            {
                RCSearchEngineSwitchViewController * vc = [[RCSearchEngineSwitchViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                NSLog(@"self.modalViewController: %@",NSStringFromClass([self.navigationController.presentedViewController class]));
                vc.engineDelegate = self.mainVC;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
    }else if ([indexPath section] == OptionSectionPrivate) {
        switch ([indexPath row])
        {
            case OptionPrivateHistory:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空历史记录？" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
                [alert show];
            }
                break;
            case OptionPrivateCookies:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空Cookies？" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
                [alert show];
            }
                break;
            case OptionPrivateCache:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空全部缓存？" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
                [alert show];
            }
                break;
        }
    }else if ([indexPath section] == OptionSectionUE) {
        switch ([indexPath row])
        {
            case OptionUEProtocol:
            {
                UIViewController* ProtocalVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:ProtocalVC animated:YES];
                ProtocalVC.title = @"产品使用许可协议";
                
                NSString* path = [[NSBundle mainBundle] pathForResource:@"隐私保护声明HD版" ofType:@"txt"];
                NSString* text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                UITextView* textView = [[UITextView alloc] initWithFrame:ProtocalVC.view.bounds];
                textView.autoresizingMask = RCViewAutoresizingALL;
                textView.font = [UIFont systemFontOfSize:20];
                textView.text = text;
                textView.scrollEnabled = YES;
                textView.editable = NO;
                [ProtocalVC.view addSubview:textView];

            }
                break;
            case OptionUEPrivate:
            {
                                
                RCPrivacyViewController* PrivacyViewController = [[RCPrivacyViewController alloc] initWithNibName:@"RCPrivacyViewController" bundle:nil];
                [self.navigationController pushViewController:PrivacyViewController animated:YES];

            }
                break;
            case OptionUESuggestion:
            {
                [UMFeedback showFeedback:self withAppkey:@"5056b26e52701527fe000074"];
            }
                break;
        }
    }else if ([indexPath section] == OptionSectionAbout) {
        switch ([indexPath row])
        {
            case OptionAbout2345:
            {
                UIViewController* aboutVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:aboutVC animated:YES];
                aboutVC.title = @"关于2345";
                UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about2345"]];
                image.frame = aboutVC.view.bounds;
                [aboutVC.view addSubview:image];
            }
                break;
            case OptionAboutRating:
            {
                //550416381
                NSString *appId = @"563833448";
                NSString* url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
            }
                break;
            case OptionAboutUpdate:
            {
                [MobClick checkUpdateWithDelegate:self selector:@selector(appUpdate:)];
            }
                break;
        }
    }
}

-(void)checkUpdate
{
    [MobClick checkUpdate];
}

- (void)appUpdate:(NSDictionary *)appInfo
{
    NSLog(@"appInfo: %@",appInfo);
    BOOL update = [[appInfo objectForKey:@"update"] boolValue];
    if (update) {
        [MobClick checkUpdateWithDelegate:nil selector:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"清空"]) {
        if ([alertView.title isEqualToString:@"确认清空历史记录？"]) {
            [RCRecordData updateRecord:nil ForKey:RCRD_HISTORY];
            [RCRecordData updateRecord:nil ForKey:RCRD_FAV];
        }else if ([alertView.title isEqualToString:@"确认清空Cookies？"]){
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies]) {
                [storage deleteCookie:cookie];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if ([alertView.title isEqualToString:@"确认清空全部缓存？"]){
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[RCRecordData class] performSelectorInBackground:@selector(clearImageCaches) withObject:nil];
        }
    }

    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
