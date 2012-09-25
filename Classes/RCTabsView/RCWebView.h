//
//  RCWebView.h
//  browserHD
//
//  Created by imac on 12-8-15.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCWebViewDelegate <NSObject>
-(void)openlink:(NSURL*)link;
-(void)openlinkAtNewTab:(NSURL*)link;
-(void)openlinkAtBackground:(NSURL*)link;

@end


@interface RCWebView : UIWebView
@property (nonatomic,assign) BOOL isWebPage;

@property(nonatomic,assign) NSObject<RCWebViewDelegate>* longPressDelegate;

-(NSURL*)url;
-(NSString*)title;

@end
