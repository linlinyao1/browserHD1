//
//  RCNavigationPage.h
//  browserHD
//
//  Created by imac on 12-8-17.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCGridNavigationView.h"

@protocol RCNavigationPageDelegate <NSObject>

-(void)navigationPageNeedsConfigure;
-(void)navigationPageOpenLink:(NSURL*)link;
@end

@interface RCNavigationPage : UIView
@property (nonatomic,assign)NSObject<RCNavigationPageDelegate> *delegate;
@property (nonatomic,strong) RCGridNavigationView *gridView;

-(void)reloadData;
@end
