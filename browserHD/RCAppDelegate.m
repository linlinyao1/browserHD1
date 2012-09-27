//
//  RCAppDelegate.m
//  browserHD
//
//  Created by imac on 12-8-9.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCAppDelegate.h"

#import "RCViewController.h"
#import "RCRecordData.h"
#import "CoreDataManager+BookMark.h"
#import "MobClick.h"

@implementation RCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[RCViewController alloc] initWithNibName:@"RCViewController" bundle:nil];

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [self.viewController willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];

    //setup screen shot cache clear
//    5056b26e52701527fe000074
    [MobClick startWithAppkey:@"5056b26e52701527fe000074" reportPolicy:REALTIME channelId:nil];
    [MobClick checkUpdate];

    
    [[RCRecordData class] performSelectorInBackground:@selector(clearImageCaches) withObject:nil];
    
    
    BOOL notFirstLoad = [[NSUserDefaults standardUserDefaults] boolForKey:@"notFirstLoad"];
    if (!notFirstLoad) {
        [RCRecordData prepareDefaultData];
        
        Folder* folder = [[CoreDataManager defaultManager] creatFolderWithTitle:@"我的收藏夹" Unique:[NSNumber numberWithInt:0] Parent:nil];
        if (!folder) {
            NSLog(@"error creat default Folder");
        }else{

        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstLoad"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
