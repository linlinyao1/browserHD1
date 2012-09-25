//
//  RCViewController.h
//  browserHD
//
//  Created by imac on 12-8-9.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCHomePage.h"

@interface RCViewController : UIViewController
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *DashBoardFav;

//Home Page
@property (nonatomic, strong) RCHomePage *homePage;


-(void)loadUrlforCurrentTab:(NSURL*)url;

-(void)reloadHomePage;
@end
