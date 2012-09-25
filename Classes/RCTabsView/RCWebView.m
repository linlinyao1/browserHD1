//
//  RCWebView.m
//  browserHD
//
//  Created by imac on 12-8-15.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCWebView.h"
#import "UnpreventableUILongPressGestureRecognizer.h"

@interface RCWebView ()<UIActionSheetDelegate>
@property (nonatomic,strong) UIView * goBackIndicate;
@property (nonatomic,assign) NSInteger openLinkIndex;
@property (nonatomic,assign) NSInteger openLinkAtNewTabIndex;
@property (nonatomic,assign) NSInteger openLinkAtBackgroundIndex;
@property (nonatomic,assign) NSInteger copyLinkIndex;
@property (nonatomic,strong) NSURL * urlToHandle;

@end


@implementation RCWebView
@synthesize isWebPage = _isWebPage;
@synthesize goBackIndicate;
@synthesize openLinkIndex = _openLinkIndex;
@synthesize openLinkAtNewTabIndex = _openLinkAtNewTabIndex;
@synthesize openLinkAtBackgroundIndex = _openLinkAtBackgroundIndex;
@synthesize copyLinkIndex = _copyLinkIndex;
@synthesize urlToHandle = _urlToHandle;
@synthesize longPressDelegate = _longPressDelegate;

- (CGSize)windowSize {
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    return size;
}

- (CGPoint)scrollOffset {
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}

- (NSURL*)url
{
    NSString *urlString = [self stringByEvaluatingJavaScriptFromString:@"location.href"];
    if (urlString) {
        return [NSURL URLWithString:urlString];
    } else {
        return nil;
    }
}

- (NSString*)title
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}




-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scalesPageToFit = YES;
        
        UnpreventableUILongPressGestureRecognizer *longPressRecognizer = [[UnpreventableUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
        longPressRecognizer.allowableMovement = 20;
        longPressRecognizer.minimumPressDuration = 1.0f;
        [self addGestureRecognizer:longPressRecognizer];
        
//        self.goBackIndicate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//        self.goBackIndicate.center = CGPointMake(0, self.bounds.size.height/2);
//        self.goBackIndicate.backgroundColor = [UIColor yellowColor];        
//        [self addSubview:self.goBackIndicate];
//        
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGoBackPan:)];
//        [self.goBackIndicate addGestureRecognizer:pan];
    }
    return self;
}

- (void)longPressRecognized:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gestureRecognizer locationInView:self];
        
        // convert point from view to HTML coordinate system
        CGSize viewSize = [self frame].size;
        CGSize windowSize = [self windowSize];
        
        CGFloat f = windowSize.width / viewSize.width;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.) {
            point.x = point.x * f;
            point.y = point.y * f;
        } else {
            // On iOS 4 and previous, document.elementFromPoint is not taking
            // offset into account, we have to handle it
            CGPoint offset = [self scrollOffset];
            point.x = point.x * f + offset.x;
            point.y = point.y * f + offset.y;
        }
//        NSString *jsCodePath = [[NSBundle mainBundle] pathForResource:@"JSTool" ofType:@"js"];
//        NSString *jsCode = [NSString stringWithContentsOfFile:jsCodePath encoding:NSUTF8StringEncoding error:nil];
//        [self stringByEvaluatingJavaScriptFromString: jsCode];
        
        NSString *tags = [self stringByEvaluatingJavaScriptFromString:
                          [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)point.x,(NSInteger)point.y]];
        
        NSString *tagsHREF = [self stringByEvaluatingJavaScriptFromString:
                              [NSString stringWithFormat:@"MyAppGetLinkHREFAtPoint(%i,%i);",(NSInteger)point.x,(NSInteger)point.y]];
        
        NSString *tagsSRC = [self stringByEvaluatingJavaScriptFromString:
                             [NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%i,%i);",(NSInteger)point.x,(NSInteger)point.y]];
        
        NSLog(@"tags : %@",tags);
        NSLog(@"href : %@",tagsHREF);
        NSLog(@"src : %@",tagsSRC);

        NSString *url = nil;
        if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
            url = tagsSRC;
        }
        if ([tags rangeOfString:@",A,"].location != NSNotFound) {
            url = tagsHREF;
        }
        NSLog(@"url : %@",url);

        NSArray *urlArray = [[url lowercaseString] componentsSeparatedByString:@"/"];
        NSString *urlBase = nil;
        if ([urlArray count] > 2) {
            urlBase = [urlArray objectAtIndex:2];
        }
        NSLog(@"urlBase : %@",urlBase);
        
        if ((url != nil) &&
            ([url length] != 0)) {
            
            self.urlToHandle = [NSURL URLWithString:url];
            if ([[self.urlToHandle scheme] isEqualToString:@"newtab"]) {
                NSString *urlString = [[self.urlToHandle resourceSpecifier] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                self.urlToHandle = [NSURL URLWithString:urlString relativeToURL:[self url]];
            }
            
            UIActionSheet * longPressActionSheet = [[UIActionSheet alloc] initWithTitle:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
            longPressActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            
            self.openLinkAtNewTabIndex = [longPressActionSheet addButtonWithTitle:@"新标签页打开"];
            self.openLinkIndex = [longPressActionSheet addButtonWithTitle:@"打开"];
            self.openLinkAtBackgroundIndex = [longPressActionSheet addButtonWithTitle:@"后台打开"];
            self.copyLinkIndex = [longPressActionSheet addButtonWithTitle:@"复制链接"];

            CGPoint touchPosition = [gestureRecognizer locationInView:self];
            [longPressActionSheet showFromRect:CGRectMake(touchPosition.x, touchPosition.y, 1, 1)
                                         inView:self
                                       animated:YES];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma mark UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == self.copyLinkIndex) {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        [pasteBoard setValue:self.urlToHandle.absoluteString forPasteboardType:@"public.utf8-plain-text"];
    }else if (buttonIndex == self.openLinkIndex){
        [self.longPressDelegate openlink:self.urlToHandle];
    }else if (buttonIndex == self.openLinkAtNewTabIndex){
        [self.longPressDelegate openlinkAtNewTab:self.urlToHandle];
    }else if (buttonIndex == self.openLinkAtBackgroundIndex){
        [self.longPressDelegate openlinkAtBackground:self.urlToHandle];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{

}

//-(void)handleGoBackPan:(UIPanGestureRecognizer*)gesture
//{
//    CGPoint point = [gesture translationInView:self];
//    switch (gesture.state) {
//        case UIGestureRecognizerStateChanged:
//        {
//            self.goBackIndicate.transform = CGAffineTransformMakeTranslation(point.x, 0);
//        }
//            break;
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled:
//        case UIGestureRecognizerStateFailed:
//        {
//            self.goBackIndicate.transform = CGAffineTransformIdentity;
//        }
//            break;
//        default:
//            break;
//    }
//
//}




@end
