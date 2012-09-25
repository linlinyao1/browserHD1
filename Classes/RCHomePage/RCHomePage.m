//
//  RCHomePage.m
//  browserHD
//
//  Created by imac on 12-8-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCHomePage.h"
#import "RCFavPage.h"
#import "RCNavigationPage.h"
#import "UIColor+HexValue.h"
#import "RCSegment.h"


@interface RCHomePage ()<RCFavPageDelegate,RCNavigationPageDelegate,UIScrollViewDelegate,RCSegmentDelegate,RCWebViewDelegate>
@property (nonatomic,strong) RCFavPage *favPage;
@property (nonatomic,strong) RCNavigationPage *navPage;
@property (nonatomic,strong) UIScrollView *scrollBoard;
@property (nonatomic,strong) RCSegment *segmentIndicator;
@end


@implementation RCHomePage
@synthesize favPage = _favPage;
@synthesize delegate = _delegate;
@synthesize scrollBoard = _scrollBoard;
@synthesize navPage = _navPage;
@synthesize segmentIndicator = _segmentIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = RCViewAutoresizingALL;
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homePageBG"]];
        //    UIImage *img = [UIImage imageNamed:@"homePageBG"];

        
        self.scrollBoard = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollBoard.pagingEnabled = YES;
        self.scrollBoard.autoresizingMask = RCViewAutoresizingALL;
        self.scrollBoard.delegate = self;
        self.scrollBoard.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollBoard];
        
        RCFavPage *favPage = [[RCFavPage alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-85)];
        favPage.delegate = self;
        [self.scrollBoard addSubview:favPage];
        self.favPage = favPage;
        
        
//        RCNavigationPage* navPage = [[RCNavigationPage alloc] initWithFrame:CGRectOffset(favPage.frame, self.bounds.size.width, 0)];
        RCNavigationPage* navPage = [[RCNavigationPage alloc] initWithFrame:CGRectOffset(self.bounds, self.bounds.size.width, 0)];

//        self.navPage.frame = CGRectOffset(self.bounds, self.bounds.size.width, 0);

        navPage.delegate = self;
        [self.scrollBoard addSubview:navPage];
        self.navPage = navPage;
        self.navPage.gridView.navWeb.longPressDelegate = self;
        self.scrollBoard.contentSize = CGSizeMake(CGRectGetMaxX(navPage.frame), self.bounds.size.height);
        
        
        
        UIImageView *segmentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(favPage.frame), self.bounds.size.width, 85)];
        segmentView.userInteractionEnabled = YES;
        segmentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        segmentView.image = [UIImage imageNamed:@"segmentViewBG"];
//        segmentView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"segmentViewBG"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
        [self addSubview:segmentView];
        
        RCSegment* segment = [[RCSegment alloc] initWithFrame:CGRectMake(0, segmentView.bounds.size.height-14-32, 199, 32)];
        segment.center = CGPointMake(segmentView.bounds.size.width/2, segment.center.y);
        segment.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        [segmentView addSubview:segment];
        segment.delegate = self;
        self.segmentIndicator = segment;
        [segment setSelectIndex:1];
        
        [self.scrollBoard scrollRectToVisible:self.navPage.frame animated:NO];
        
    }
    return self;
}

-(void)segment:(RCSegment *)segment selectionChange:(NSInteger)newIndex
{
    if (!self.favPage.superview) {
        self.favPage.frame = self.bounds;
        [self.scrollBoard addSubview:self.favPage];
        if (self.favPage.isEditing) {
            self.favPage.editing = NO;
        }
    }
    if (!self.navPage.superview) {
        self.navPage.frame = CGRectOffset(self.bounds, self.bounds.size.width, 0);
        [self.scrollBoard addSubview:self.navPage];
        if (self.navPage.gridView.isEditing) {
            self.navPage.gridView.editing = NO;
        }
    }
    
    if (newIndex == 0) {
        [self.scrollBoard scrollRectToVisible:self.favPage.frame animated:YES];
    }else if (newIndex == 1){
        [self.scrollBoard scrollRectToVisible:self.navPage.frame animated:YES];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"orientation: %d,frame: %@",UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]),NSStringFromCGSize(self.scrollBoard.contentSize));
    self.scrollBoard.frame = self.bounds;
    self.scrollBoard.contentSize = CGSizeMake(self.scrollBoard.bounds.size.width*2, self.scrollBoard.bounds.size.height);
    if (self.scrollBoard.contentOffset.x>0) {
        self.scrollBoard.contentOffset = CGPointMake(self.scrollBoard.bounds.size.width, 0);
    }else{
        self.scrollBoard.contentOffset = CGPointMake(0, 0);
    }
//    self.scrollBoard.contentSize = CGSizeMake(CGRectGetMaxX(self.navPage.frame), self.bounds.size.height);
//    NSLog(@"self.scrollBoard.contentOffset.x :%f",self.scrollBoard.contentOffset.x);
////    if (self.scrollBoard.contentOffset.x>0) {
////        self.scrollBoard.contentOffset = CGPointMake(self.scrollBoard.bounds.size.width, 0);
////    }else{
////        self.scrollBoard.contentOffset = CGPointMake(0, 0);
////    
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    self.scrollBoard.frame = self.bounds;
//
//    if (UIDeviceOrientationIsLandscape(orientation)) {
//        self.scrollBoard.contentSize = CGSizeMake(1024*2, self.bounds.size.height);
//    }else{
//        self.scrollBoard.contentSize = CGSizeMake(768*2, self.bounds.size.height);
//    }
//    
//    
//    if (self.scrollBoard.contentOffset.x>0) {
//        self.scrollBoard.contentOffset = CGPointMake(self.scrollBoard.bounds.size.width, 0);
//    }else{
//        self.scrollBoard.contentOffset = CGPointMake(0, 0);
//    }
}

-(void)quitEditng
{
    if (self.favPage.isEditing) {
        self.favPage.editing = NO;
    }

}

-(void)relayoutWithOrientation:(UIDeviceOrientation)orientation
{
//    self.scrollBoard.frame = self.bounds;
//    if (UIDeviceOrientationIsLandscape(orientation)) {
//        self.scrollBoard.contentSize = CGSizeMake(1024*2, self.bounds.size.height);
//    }else{
//        self.scrollBoard.contentSize = CGSizeMake(768*2, self.bounds.size.height);
//    }
//    
//    
//    if (self.scrollBoard.contentOffset.x>0) {
//        self.scrollBoard.contentOffset = CGPointMake(self.scrollBoard.bounds.size.width, 0);
//    }else{
//        self.scrollBoard.contentOffset = CGPointMake(0, 0);
//    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self reloadData];
        if (self.scrollBoard.contentOffset.x>0) {
            self.scrollBoard.contentOffset = CGPointMake(self.scrollBoard.bounds.size.width, 0);
        }else{
            self.scrollBoard.contentOffset = CGPointMake(0, 0);
        }
    }
}

-(void)reloadData
{
    [self.favPage reloadData];
    [self.navPage reloadData];
}

//-(void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    UIImage *img = [UIImage imageNamed:@"homePageBG"];
//    [img drawInRect:rect];
//}


-(void)scroll
{
    if (self.scrollBoard.contentOffset.x > 0) {
        [self segment:self.segmentIndicator selectionChange:0];
//        [self.scrollBoard scrollRectToVisible:self.favPage.frame animated:YES];
    }else{
        [self segment:self.segmentIndicator selectionChange:1];
//        [self.scrollBoard scrollRectToVisible:self.navPage.frame animated:YES];
    }
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>0) {
        [self.favPage removeFromSuperview];
        [self.segmentIndicator setSelectIndex:1];
    }else{
        [self.navPage removeFromSuperview];
        [self.segmentIndicator setSelectIndex:0];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (self.favPage.isEditing) {
//        self.favPage.editing = NO;
//    }
//    if (!self.favPage.superview) {
//        self.favPage.frame = self.bounds;
//        [self.scrollBoard addSubview:self.favPage];
//        if (self.favPage.isEditing) {
//            self.favPage.editing = NO;
//        }
//    }
//    if (!self.navPage.superview) {
//        self.navPage.frame = CGRectOffset(self.bounds, self.bounds.size.width, 0);
//        [self.scrollBoard addSubview:self.navPage];
//    }
//}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.favPage.superview) {
        self.favPage.frame = self.bounds;
        [self.scrollBoard addSubview:self.favPage];
    }
    if (self.favPage.isEditing) {
        self.favPage.editing = NO;
    }
    
    if (!self.navPage.superview) {
        self.navPage.frame = CGRectOffset(self.bounds, self.bounds.size.width, 0);
        [self.scrollBoard addSubview:self.navPage];
    }
    if (self.navPage.gridView.isEditing) {
        self.navPage.gridView.editing = NO;
    }
}


#pragma mark - RCFavPageDelegate
-(void)favariteWebsiteSelected:(NSURL *)url
{
    if (url && url.absoluteString.length>0) {
        [self.delegate homePage:self lunchUrl:url WithOption:RCHomePageLunchNomal];
    }
}

#pragma mark - RCNavigationPageDelegate
-(void)navigationPageNeedsConfigure
{
    if ([self.delegate respondsToSelector:@selector(homePageNeedsAddNewNavIcons:)]) {
        [self.delegate homePageNeedsAddNewNavIcons:self];
    }
}

-(void)navigationPageOpenLink:(NSURL *)link
{
    if ([self.delegate respondsToSelector:@selector(homePage:lunchUrl:WithOption:)]) {
        [self.delegate homePage:self lunchUrl:link WithOption:RCHomePageLunchNomal];
    }
}


-(void)openlink:(NSURL *)link
{
    if ([self.delegate respondsToSelector:@selector(homePage:lunchUrl:WithOption:)]) {
        [self.delegate homePage:self lunchUrl:link WithOption:RCHomePageLunchNomal];
    }
}
-(void)openlinkAtBackground:(NSURL *)link
{
    if ([self.delegate respondsToSelector:@selector(homePage:lunchUrl:WithOption:)]) {
        [self.delegate homePage:self lunchUrl:link WithOption:RCHomePageLunchNewBackgroundTab];
    }
}
-(void)openlinkAtNewTab:(NSURL *)link
{
    if ([self.delegate respondsToSelector:@selector(homePage:lunchUrl:WithOption:)]) {
        [self.delegate homePage:self lunchUrl:link WithOption:RCHomePageLunchNewTab];
    }
}

@end
