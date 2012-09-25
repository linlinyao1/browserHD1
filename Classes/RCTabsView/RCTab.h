//
//  RCTab.h
//  browserHD
//
//  Created by imac on 12-8-10.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCWebView.h"
#import "EGOImageView.h"

@protocol RCTabDelegate;

@interface RCTab : UIView<UIWebViewDelegate,RCWebViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *closeTabButton;
@property (nonatomic,assign) BOOL selected;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet EGOImageView *favIcon;
@property (nonatomic,unsafe_unretained) IBOutlet UIImageView * backgroundView;
@property (nonatomic,strong) UIImageView * selectedBackgroundView;
@property (nonatomic,assign) NSObject<RCTabDelegate> *delegate;
//webView
@property (nonatomic,strong) RCWebView *webView;
@property (nonatomic,assign) CGFloat loadingProgress;

-(void)setDisableClose:(BOOL)disable;
@end


@protocol RCTabDelegate <NSObject>
-(void)tabNeedsToBeClosed:(RCTab*)tab;
@optional
-(void)RCTab:(RCTab*)tab DidStartLoadingWebView:(RCWebView*)webView;
-(void)RCTab:(RCTab*)tab StartLoadingWebView:(RCWebView*)webView WithRequest:(NSURLRequest*)request;
-(void)RCTab:(RCTab*)tab FinishLoadingWebView:(RCWebView*)webView;
-(void)RCTab:(RCTab*)tab DidFailLoadingWebView:(RCWebView*)webView WithErrorCode:(NSError *)error;

-(void)RCTab:(RCTab *)tab OpenLink:(NSURL*)link;
-(void)RCTab:(RCTab *)tab OpenLinkAtNewTab:(NSURL*)link;
-(void)RCTab:(RCTab *)tab OpenLinkAtBackground:(NSURL*)link;

-(void)RCTab:(RCTab*)tab LoadingProgressChanged:(CGFloat)progress;

@end
