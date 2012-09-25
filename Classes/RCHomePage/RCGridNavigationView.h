//
//  RCGridNavigationView.h
//  browserHD
//
//  Created by imac on 12-9-3.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCGridView.h"
#import "RCWebview.h"

@protocol RCGridNavigationViewDataSource;


@interface RCGridNavigationView : RCGridView
@property (nonatomic,assign) NSObject<RCGridNavigationViewDataSource> *navDataSource;
@property (nonatomic,strong) RCWebView *navWeb;
@end


@protocol RCGridNavigationViewDataSource <NSObject>


@end