//
//  RCNavigationPage.m
//  browserHD
//
//  Created by imac on 12-8-17.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCNavigationPage.h"
#import "RCRecordData.h"
#import "QuartzCore/QuartzCore.h"
#import "UIColor+HexValue.h"
#import "UIView+ScreenShot.h"


#define NAV_ICON_SIZE 73


@interface RCNavigationPage ()<RCGridViewDataSource,RCGridViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong) NSMutableArray *listContent;
@property (nonatomic,strong) NSArray *quicklinks;
@property (nonatomic,strong) UIImageView* quicklinkHint;
@end


@implementation RCNavigationPage
@synthesize gridView = _gridView;
@synthesize listContent = _listContent;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = RCViewAutoresizingALL;
        // Initialization code
        
        RCGridNavigationView *gridView = [[RCGridNavigationView alloc] initWithFrame:self.bounds];
        gridView.navWeb.delegate = self;
        gridView.autoresizingMask = RCViewAutoresizingALL;
        gridView.cellSize = CGSizeMake(NAV_ICON_SIZE, NAV_ICON_SIZE);
//        gridView.minEdgeInsets = UIEdgeInsetsMake(40, 145, 0, 50);

        gridView.disableEditWhenTapInvalid = YES;
        gridView.dataSource = self;
        gridView.delegate =self;
        self.gridView = gridView;
        [self addSubview:gridView];
        
    }
    return self;
}

-(void)reloadData
{
    self.listContent = [RCRecordData recordDataWithKey:RCRD_QUICKLINK];

    [self.gridView reloadData];
    
}


#pragma mark - RCGridViewDataSource,RCGridViewDelegate

-(RCGridViewCell *)gridView:(RCGridView *)gridView ViewForCellAtIndex:(NSInteger)index
{
//    NSArray *quickLinkDB = [QuickLinkDataBase sharedQuickLinkDB];
    RCGridViewCell* cell = [[RCGridViewCell alloc] initWithFrame:CGRectMake(0, 0, NAV_ICON_SIZE, NAV_ICON_SIZE)];
//    cell.contentView.backgroundColor = [UIColor clearColor];
    
    BookmarkObject *obj = [self.listContent objectAtIndex:index];
    NSDictionary *info = [QuickLinkDataBase quicklinkForUrl:obj.url];
    
    UIView *contentView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[info objectForKey:URL_Icon]]];
    img.frame = CGRectMake(0, 0, NAV_ICON_SIZE, 47);
    if (!img.image) {
        img.image = [UIImage imageNamed:@"quicklink_default"];
    }
    [contentView addSubview:img];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)-1, NAV_ICON_SIZE, NAV_ICON_SIZE-46)];

    label.text = [obj name];//[info  objectForKey:URL_Title];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithHexValue:@"545454"];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor colorWithHexValue:@"f6f6f6"];
    label.layer.borderColor = [UIColor colorWithHexValue:@"cecece"].CGColor;
    label.layer.borderWidth = 1;
    [contentView addSubview:label];
    contentView.layer.borderColor = [UIColor colorWithHexValue:@"C3c3c3"].CGColor;
    contentView.layer.borderWidth = 1;
    
    cell.backgroundView.image = [contentView screenShotImageWithRoundConor:8];

    return cell;
}

-(NSInteger)numberOfCellsInGridView:(RCGridView *)gridView
{
    return self.listContent.count;
}

-(UIView *)ViewForAddButton:(RCGridView *)gridView
{
    UIImageView *addButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quicklink_add"]];
    addButton.frame = CGRectMake(0, 0, NAV_ICON_SIZE, NAV_ICON_SIZE);
//    UIView *addButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NAV_ICON_SIZE, NAV_ICON_SIZE)];
//    addButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"quicklink_add"]];
    return addButton;
}

-(void)gridView:(RCGridView *)gridView CellWillBeRemovedAtIndex:(NSInteger)index
{
    [self.listContent removeObjectAtIndex:index];
    [RCRecordData updateRecord:self.listContent ForKey:RCRD_QUICKLINK];
}

-(void)gridView:(RCGridView *)gridView CellAtIndex:(NSInteger)index1 ExchangeWithCellAtIndex:(NSInteger)index2
{
    [self.listContent exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    [RCRecordData updateRecord:self.listContent ForKey:RCRD_QUICKLINK];
}

-(void)gridView:(RCGridView *)gridView CellTappedAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(navigationPageOpenLink:)]) {
        BookmarkObject *obj = [self.listContent objectAtIndex:index];
        [self.delegate navigationPageOpenLink:obj.url];
    }
}

-(void)gridView:(RCGridView *)gridView CellWillBeMoved:(RCGridViewCell *)cell
{
    cell.layer.shadowOpacity = 0.3;
    cell.layer.shadowOffset = CGSizeMake(0, 8);
    //    [cell.contentButton setHighlighted:YES];
    //    [cell.contentButton performSelector:@selector(setHighlighted:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.0];
}

-(void)gridView:(RCGridView *)gridView CellWillEndMoving:(RCGridViewCell *)cell
{
    cell.layer.shadowOpacity = 0.3;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    //    [cell.contentButton setHighlighted:NO];
}

-(void)addButtonTapped:(RCGridView *)gridView
{
    if ([self.delegate respondsToSelector:@selector(navigationPageNeedsConfigure)]) {
        [self.delegate navigationPageNeedsConfigure];
    }
}

-(void)removeHint{
    [self.quicklinkHint removeFromSuperview];
    self.quicklinkHint = nil;
}

-(void)gridViewStartEditing:(RCGridView *)gridView
{
    BOOL notFirstQuickLinkHint = [[NSUserDefaults standardUserDefaults] boolForKey:@"notFirstQuickLinkHint"];
    if (!notFirstQuickLinkHint) {
        UIImageView* quicklinkHint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quicklinkHint"]];
        quicklinkHint.frame = CGRectMake(0,0, 278, 74);
        quicklinkHint.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.quicklinkHint = quicklinkHint;
        [self addSubview:quicklinkHint];
        [self performSelector:@selector(removeHint) withObject:nil afterDelay:3];
//        [quicklinkHint performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstQuickLinkHint"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}
-(void)gridViewEndEditing:(RCGridView *)gridView
{

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.quicklinkHint.superview) {
        self.quicklinkHint.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.quicklinkHint = self.quicklinkHint;
    }
}

#pragma mark - UIWebViewDelegate

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
////    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
////    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
////    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.ontouchMove='none';"];
////    [self.gridView setNeedsLayout];
//}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self.delegate navigationPageOpenLink:request.URL];
        return NO;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *jsCodePath = [[NSBundle mainBundle] pathForResource:@"JSTool" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:jsCodePath encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString: jsCode];
}




@end
