//
//  RCHomePage.h
//  browserHD
//
//  Created by imac on 12-8-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    RCHomePageLunchNomal=0,
    RCHomePageLunchNewTab,
    RCHomePageLunchNewBackgroundTab
}RCHomePageLunchOptions;

@protocol RCHomePageDelegate;


@interface RCHomePage : UIView
@property (nonatomic,assign) NSObject<RCHomePageDelegate>* delegate;
-(void)relayoutWithOrientation:(UIDeviceOrientation)orientation;

-(void)quitEditng;
-(void)reloadData;

-(void)scroll;
@end


@protocol RCHomePageDelegate <NSObject>
-(void)homePage:(RCHomePage*)homePage lunchUrl:(NSURL*)url WithOption:(RCHomePageLunchOptions)option;
-(void)homePageNeedsAddNewNavIcons:(RCHomePage *)homePage;
@end