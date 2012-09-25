//
//  RCTab.m
//  browserHD
//
//  Created by imac on 12-8-10.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCTab.h"
#import "RCRecordData.h"

@interface RCTab ()
@property (nonatomic,assign) BOOL notFirstLoad;
@property (nonatomic,unsafe_unretained) NSTimer *progressTimer;
@property (nonatomic,assign) NSInteger *webLoadingCount;

@end

@implementation RCTab
@synthesize closeTabButton = _closeTabButton;
@synthesize selected = _selected;
@synthesize titleLabel = _titleLabel;
@synthesize backgroundView = _backgroundView;
@synthesize selectedBackgroundView = _selectedBackgroundView;
@synthesize webView = _webView;
@synthesize notFirstLoad = _notFirstLoad;
@synthesize favIcon = _favIcon;
@synthesize progressTimer = _progressTimer;
@synthesize webLoadingCount = _webLoadingCount;
@synthesize loadingProgress = _loadingProgress;





-(void)setWebView:(RCWebView *)webView
{
    if (_webView != webView) {
        _webView = webView;
        _webView.delegate = self;
        _webView.longPressDelegate = self;
    }
}

-(void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;

        if (_selected) {
            [self.backgroundView addSubview:self.selectedBackgroundView];
//            [self insertSubview:self.selectedBackgroundView aboveSubview:self.backgroundView];
            [self.closeTabButton setImage:[UIImage imageNamed:@"tab_delete_Snormal"] forState:UIControlStateNormal];
            [self.closeTabButton setImage:[UIImage imageNamed:@"tab_delete_Shite"] forState:UIControlStateHighlighted];
            self.titleLabel.textColor = [UIColor blackColor];
        }else{
            [self.selectedBackgroundView removeFromSuperview];
            [self.closeTabButton setImage:[UIImage imageNamed:@"tab_delete_normal"] forState:UIControlStateNormal];
            [self.closeTabButton setImage:[UIImage imageNamed:@"tab_delete_hite"] forState:UIControlStateHighlighted];
            self.titleLabel.textColor = [UIColor whiteColor];
        }
        
    }
}

-(id)init
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RCTab" owner:nil options:nil];
    self = [arr objectAtIndex:0];
    if (self) {
        //
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.backgroundView.bounds];
        self.favIcon.placeholderImage = [UIImage imageNamed:@"tab_newtab"];
        self.loadingProgress = 0;
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        CGRect rect = CGRectMake(-15, 0, self.bounds.size.width+30, self.bounds.size.height);
        self.backgroundView = [[UIImageView alloc] initWithFrame:rect];
        [self addSubview:self.backgroundView];
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.backgroundView.bounds];
        
        self.loadingProgress = 0;
    }
    return self;
}

-(void)setDisableClose:(BOOL)disable
{
    self.closeTabButton.hidden = disable;
}



-(void)handleWebFinishedLoading:(UIWebView*)webView
{
    self.loadingProgress = 1.1; // any number lagger than 1 to make a splash
    
//    [self.progressTimer invalidate];
//    self.progressTimer = nil;
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    if (self.webView.isWebPage) {
        self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSURL *url = [[NSURL alloc] initWithScheme:[webView.request.URL scheme] host:[webView.request.URL host] path:@"/favicon.ico"];
        [self.favIcon setImageURL:url];
    }

    
    if ([self.delegate respondsToSelector:@selector(RCTab:FinishLoadingWebView:)]) {
        [self.delegate RCTab:self FinishLoadingWebView:self.webView];
    }
    
    [[RCRecordData class] performSelector:@selector(saveImageForWeb:) withObject:webView afterDelay:1];
        

    
    
    NSMutableArray *historyArray = [RCRecordData recordDataWithKey:RCRD_HISTORY];
    BOOL saveURL = YES;
    
    // Check that the URL is not already in the history list
    NSString* urlString = webView.request.URL.absoluteString;
    if ([urlString hasSuffix:@"/"]) {
        urlString = [urlString substringToIndex:urlString.length-1];
    }
    for (BookmarkObject * history in historyArray) {
        NSString* historyString = history.url.absoluteString;
        if ([historyString hasSuffix:@"/"]) {
            historyString = [historyString substringToIndex:historyString.length-1];
        }
        
        if ([historyString isEqual:urlString]) {
            history.date = [NSDate date];
            history.count = [NSNumber numberWithInt: history.count.intValue+1];
            saveURL = NO;
            break;
        }
    }
    // Add the new URL in the list
    if (saveURL) {
        BookmarkObject *history = [[BookmarkObject alloc] initWithName:self.titleLabel.text andURL:webView.request.URL];
        [historyArray addObject:history];
    }
    [RCRecordData updateRecord:historyArray ForKey:RCRD_HISTORY];
    
    
    NSArray *favArray = [historyArray sortedArrayUsingComparator:^NSComparisonResult(BookmarkObject *obj1, BookmarkObject *obj2) {
        return [obj2.count compare:obj1.count];
    }];
    favArray = [favArray subarrayWithRange:NSMakeRange(0, MIN(favArray.count, MAX_FAV_COUNT))];
    [RCRecordData updateRecord:favArray ForKey:RCRD_FAV];
}

-(void)handleProgressTimer:(NSTimer*)sender
{
    
    if (!self.progressTimer) {
        [sender invalidate];
        return;
    }
    
    CGFloat progress = floorf(self.loadingProgress*1000)/1000;
    if (progress <=0) {
        self.loadingProgress = 0;
        [sender invalidate];
        self.progressTimer = nil;
        return;
    }else if (progress > 1){
        self.loadingProgress = 1;
    }else if (progress == 1){
        self.loadingProgress = 0;
    }else if (progress < 0.5) {
        self.loadingProgress += 0.012;
    }else if (progress == 0.51){
        [sender invalidate];
        self.loadingProgress += 0.01;
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleProgressTimer:) userInfo:nil repeats:NO];
    }else if (progress < 0.82){
        self.loadingProgress += 0.01;
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(handleProgressTimer:) userInfo:nil repeats:YES];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(RCTab:LoadingProgressChanged:)]) {
        [self.delegate RCTab:self LoadingProgressChanged:self.loadingProgress];
    }
}



#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.webLoadingCount++;
        
    NSLog(@"start :%@",webView.request.URL);

//    if (webView.request.URL.absoluteString.length) {
        if ([self.delegate respondsToSelector:@selector(RCTab:DidStartLoadingWebView:)]) {
            [self.delegate RCTab:self DidStartLoadingWebView:self.webView];
        }
//    }
    
    if(self.progressTimer) {
        self.progressTimer = nil;
    }
    self.loadingProgress = 0.15;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(handleProgressTimer:) userInfo:nil repeats:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleWebFinishedLoading:) object:webView];

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        return NO;
    }
    NSLog(@"should : %@",request.URL);
    
    NSURL *url = [request URL];
    NSString *isBlankInBaseElement = [webView stringByEvaluatingJavaScriptFromString:@"MyIPhoneApp_isBlankInBaseElement()"];
    
    if ([[url scheme] isEqualToString:@"newtab"] || ([isBlankInBaseElement isEqualToString:@"yes"] && navigationType == UIWebViewNavigationTypeLinkClicked) ) {
        NSString *urlString = [[url resourceSpecifier] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:urlString relativeToURL:[(RCWebView*)webView url]];
        [self openlinkAtNewTab:url];
        return NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(RCTab:StartLoadingWebView:WithRequest:)]) {
            [self.delegate RCTab:self StartLoadingWebView:self.webView WithRequest:request];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleWebFinishedLoading:) object:webView];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish :%@",webView.request.URL);
    
    self.webLoadingCount--;
    if (self.webLoadingCount == 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleWebFinishedLoading:) object:webView];
        [self performSelector:@selector(handleWebFinishedLoading:) withObject:webView afterDelay:.5];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webLoadingCount--;
    
    if (self.webLoadingCount == 0) {
        self.loadingProgress = 1.1;
    }
    
    if ([self.delegate respondsToSelector:@selector(RCTab:DidFailLoadingWebView:WithErrorCode:)]) {
        [self.delegate RCTab:self DidFailLoadingWebView:self.webView WithErrorCode:error];
    }
}




#pragma mark - RCWebViewDelegate

-(void)openlink:(NSURL *)link
{
    if ([self.delegate respondsToSelector:@selector(RCTab:OpenLink:)]) {
        [self.delegate RCTab:self OpenLink:link];
    }
}
-(void)openlinkAtNewTab:(NSURL *)link
{
    if ([self.delegate respondsToSelector:@selector(RCTab:OpenLinkAtNewTab:)]) {
        [self.delegate RCTab:self OpenLinkAtNewTab:link];
    }
}
-(void)openlinkAtBackground:(NSURL *)link
{
    if ([self.delegate respondsToSelector:@selector(RCTab:OpenLinkAtBackground:)]) {
        [self.delegate RCTab:self OpenLinkAtBackground:link];
    }
}


#pragma mark - RCTabDelegate
- (IBAction)handleCloseTabButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(tabNeedsToBeClosed:)]) {
        [self.delegate tabNeedsToBeClosed:self];
    }
}


-(void)dealloc
{
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
    
}




@end
