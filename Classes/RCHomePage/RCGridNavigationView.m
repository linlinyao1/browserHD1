//
//  RCGridNavigationView.m
//  browserHD
//
//  Created by imac on 12-9-3.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCGridNavigationView.h"

@interface RCGridNavigationView ()<UIWebViewDelegate>
@property (nonatomic,strong) UIView *seperator;
@end

@implementation RCGridNavigationView
@synthesize navWeb = _navWeb;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.navWeb = [[RCWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1150)];
        self.navWeb.delegate = self;

        NSString *path = [[NSBundle mainBundle] pathForResource:@"html" ofType:nil];
        NSString *fullpath = [NSBundle pathForResource:@"index" ofType:@"htm" inDirectory:path];
        [self.navWeb loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:fullpath]]];
        self.navWeb.backgroundColor = [UIColor clearColor];
        self.navWeb.opaque = NO;
        if ([self.navWeb respondsToSelector:@selector(scrollView)]) {
            self.navWeb.scrollView.bounces = NO;
        }else{
            UIScrollView* sv = nil;
            for(UIView* v in self.navWeb.subviews){
                if([v isKindOfClass:[UIScrollView class] ]){
                    sv = (UIScrollView*) v;
                    sv.bounces = NO;
                }
            }
        }
        
        
        
        self.seperator = [[UIView alloc] init];
        self.seperator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"quicklink_seperator"]];
//        [self.scrollView addSubview:self.seperator];
    }
    return self;
}

-(void)layoutSubviews
{
    CGPoint offset = self.scrollView.contentOffset;

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.minEdgeInsets = UIEdgeInsetsMake(40, 145, 0, 145);
        self.verticalCellGap = 43;
        self.horizonalCellGap = 57;
    }else{
        self.minEdgeInsets = UIEdgeInsetsMake(40, 65, 0, 65);
        self.verticalCellGap = 43;
        self.horizonalCellGap = 37;
    }
    
    [super layoutSubviews];
        
    CGSize size = self.scrollView.contentSize;
//    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        self.seperator.frame = CGRectMake(125, size.height+self.verticalCellGap, 1024-125*2, 2);
//        
//    }else{
//        self.seperator.frame = CGRectMake(45, size.height+self.verticalCellGap, 768-45*2, 2);
//    }
    
    
//    NSString *length = [self.navWeb stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"];
    self.navWeb.frame = CGRectMake(0, size.height+27 , self.bounds.size.width, 1150);
    
    self.scrollView.contentSize = CGSizeMake(size.width, CGRectGetMaxY (self.navWeb.frame)+0);
    NSLog(@"size: %@",NSStringFromCGSize(self.scrollView.contentSize));

    self.scrollView.contentOffset = offset;
}

-(void)reloadData
{
    [super reloadData];
//    [self.scrollView addSubview:self.seperator];
    [self.scrollView addSubview:self.navWeb];
}




@end
