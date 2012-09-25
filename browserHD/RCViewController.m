//
//  RCViewController.m
//  browserHD
//
//  Created by imac on 12-8-9.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCViewController.h"
#import "EasyTableView.h"
#import "RCTab.h"
#import "RCUrlInputViewController.h"
#import "RCSearchInputViewController.h"
#import "RCSearchEngineSwitchViewController.h"
#import "RCConfigueNavIconsViewController.h"
#import "RCSettingViewController.h"
#import "RCUrlField.h"
#import "RCBookmarkView.h"
#import "RCBookmarkPopoverViewController.h"
#import "RCFolderEditingViewController.h"
#import "QuartzCore/QuartzCore.h"


#define TITLE_FOR_NEWTAB @"新建标签页"


//@interface UIToolbar (Addition)
//
//@end
//@implementation UIToolbar (Addition)
//
//- (void) drawRect:(CGRect)rect {
//    UIImage *barImage = [UIImage imageNamed:@"DashBoard_BG"];
//    [barImage drawInRect:rect];
//}
//
//@end



#pragma mark - Declaration Section

@interface RCViewController ()<EasyTableViewDelegate,RCTabDelegate,UITextFieldDelegate,UIPopoverControllerDelegate,RCUrlInputViewControllerDelegate,RCHomePageDelegate,UIActionSheetDelegate,RCSearchEngineSwitchViewControllerDelegate,RCSearchInputViewControllerDelegate>
@property (nonatomic,strong) EasyTableView *tabsView;
@property (nonatomic,strong) NSMutableArray *listContent; //of tabs
@property (nonatomic,strong) NSMutableArray *listWebViews; //
@property (nonatomic,copy) NSString *JSToolCode;
@property (nonatomic,strong) NSMutableArray *webRestorePool; //for restore
@property (nonatomic,strong) RCWebView *preloadWeb;
@property (nonatomic,strong) UIButton* addNew;
@property (nonatomic,assign) BOOL closing;
@property (nonatomic,strong) UIImageView* restoreHint;
//dashBoard
@property (unsafe_unretained, nonatomic) IBOutlet UIView *DashBoard;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *DashBoardBack;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *DashBoardForward;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *DashBoardHome;
@property (unsafe_unretained, nonatomic) IBOutlet RCUrlField *DashBoardUrlField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *DashBoardSearchField;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *DashBoardSetting;


@property (nonatomic,strong) UIButton *restoreTabButton;


@property (strong, nonatomic) IBOutlet UIView *urlInputKeyboardAccessory;

@property (nonatomic,strong) UIButton *reloadStopButton;

@property (nonatomic,unsafe_unretained) NSTimer *loadingTimer;

@property (nonatomic,strong) UIPopoverController *urlInputPopover;
@property (nonatomic,strong) UIPopoverController *searchInputPopover;
@property (nonatomic,strong) UIPopoverController *searchEnginePopover;
@property (nonatomic,strong) UIActionSheet *bookMarkActionSheet;
@property (nonatomic,strong) UIPopoverController* bookmarkPopover;
///////////////////
///////////////////
@property (unsafe_unretained, nonatomic) IBOutlet UIView *browserView;



///////private method/////
-(void)homePageQuitEditingIfNeeded;

-(RCTab*)currentTab;

-(void)addNewTab;
-(void)addNewBackgroundTab;
-(void)resumeLastWeb;

-(void)loadUrl:(NSURL*)url ForTab:(RCTab*)tab;

-(void)preloadWebView;

-(void)clearAllPopovers;
-(void)updateLoadingState;

-(void)restoreHomePage;
-(void)updateBackForwardButtonWithTab:(RCTab*)tab;

//-(void)updateSearchEngine;

//-(void)processLoadingProgressWithInfo:(NSMutableDictionary*)info;
-(void)searchFieldActive:(BOOL)active;


@end

@implementation RCViewController
//private
@synthesize browserView = _browserView;
@synthesize tabsView = _tabsView;
@synthesize listContent = _listContent;
@synthesize DashBoard = _DashBoard;
@synthesize DashBoardBack = _DashBoardBack;
@synthesize DashBoardForward = _DashBoardForward;
@synthesize DashBoardHome = _DashBoardHome;
@synthesize DashBoardFav = _DashBoardFav;
@synthesize DashBoardUrlField = _DashBoardUrlField;
@synthesize DashBoardSearchField = _DashBoardSearchField;
@synthesize DashBoardSetting = _DashBoardSetting;
@synthesize urlInputKeyboardAccessory = _urlInputKeyboardAccessory;
@synthesize urlInputPopover = _urlInputPopover;
@synthesize searchInputPopover = _searchInputPopover;
@synthesize listWebViews = _listWebViews;
@synthesize homePage = _homePage;
@synthesize reloadStopButton = _reloadStopButton;
@synthesize searchEnginePopover = _searchEnginePopover;
@synthesize JSToolCode = _JSToolCode;
@synthesize bookMarkActionSheet = _bookMarkActionSheet;
@synthesize webRestorePool = _webRestorePool;
@synthesize preloadWeb = _preloadWeb;
@synthesize loadingTimer = _loadingTimer;
@synthesize restoreTabButton = _restoreTabButton;

@synthesize bookmarkPopover = _bookmarkPopover;
//public




#pragma mark - Lift Circle



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.listContent = [NSMutableArray arrayWithObjects:TITLE_FOR_NEWTAB, nil];
    self.listWebViews = [NSMutableArray arrayWithObject:[[RCWebView alloc] initWithFrame:self.browserView.bounds]];
    [self preloadWebView];
    
    self.homePage = [[RCHomePage alloc] initWithFrame:self.browserView.bounds];
    self.homePage.delegate =self;
//
    
    NSString *jsCodePath = [[NSBundle mainBundle] pathForResource:@"JSTool" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:jsCodePath encoding:NSUTF8StringEncoding error:nil];
    self.JSToolCode = jsCode;
    
    
    
    CGRect frameRect	= CGRectMake(0, 0, 720, 38);
	EasyTableView *view	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:12 ofWidth:201];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabViewBG"]];
	self.tabsView = view;
	view.delegate						= self;
    view.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
	view.tableView.backgroundColor	= [UIColor clearColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabViewBG"]];
	view.tableView.allowsSelection	= YES;
    view.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	view.autoresizingMask				= UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:view];
    view.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    UIButton* restoreTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    restoreTabButton.backgroundColor = [UIColor clearColor];
    restoreTabButton.frame = CGRectMake(720, 0, 48, 38);
    [restoreTabButton setBackgroundImage:[UIImage imageNamed:@"tab_restore_normal"] forState:UIControlStateNormal];
    [restoreTabButton setBackgroundImage:[UIImage imageNamed:@"tab_restore_hite"] forState:UIControlStateHighlighted];
    [restoreTabButton setBackgroundImage:[UIImage imageNamed:@"tab_restore_disable"] forState:UIControlStateDisabled];
    
    restoreTabButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [restoreTabButton addTarget:self action:@selector(resumeLastWeb) forControlEvents:UIControlEventTouchUpInside];
    [restoreTabButton setEnabled:NO];
    [self.view addSubview:restoreTabButton];
    self.restoreTabButton = restoreTabButton;
    
    self.DashBoard.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashboardBG"]];
    
    self.DashBoardUrlField.frame = CGRectMake(self.DashBoardUrlField.frame.origin.x, 6, 390, 31);
//    self.DashBoardUrlField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"urlField_BG_long_Portrait"]];
    self.DashBoardUrlField.progressImage = [UIImage imageNamed:@"urlField_PB_Portrait"];
    self.DashBoardSearchField.frame = CGRectMake(CGRectGetMaxX(self.DashBoardUrlField.frame)+15, 6, 126, 31);
//    self.DashBoardSearchField.background = [UIImage imageNamed:@"searchField_BG_short_Portrait"];
    self.DashBoardSetting.frame = CGRectMake(CGRectGetMaxX(self.DashBoardSearchField.frame)+10, 0, 44, 44);
    

//    
    UIView *keyboardAccessory = [[[NSBundle mainBundle] loadNibNamed:@"RCUrlInputKeyBoardAccessory" owner:self options:nil] objectAtIndex:0];
    keyboardAccessory.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"keyBoardAccessoryBG"]];
    self.DashBoardUrlField.inputAccessoryView = keyboardAccessory;
    self.urlInputKeyboardAccessory = keyboardAccessory;
//
    UIButton *stopReloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopReloadButton.bounds = CGRectMake(0, 0, 26, 30);
    [stopReloadButton setImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
    [stopReloadButton setImage:[UIImage imageNamed:@"stopload"] forState:UIControlStateSelected];
//    [stopReloadButton setImage:[UIImage imageNamed:@"CIALBrowser.bundle/images/AddressViewReload.png"] forState:UIControlStateHighlighted];
    stopReloadButton.showsTouchWhenHighlighted = NO;
    [stopReloadButton addTarget:self action:@selector(reloadOrStop:) forControlEvents:UIControlEventTouchUpInside];
    self.DashBoardUrlField.rightView = stopReloadButton;
    self.DashBoardUrlField.rightViewMode = UITextFieldViewModeUnlessEditing;
    self.reloadStopButton = stopReloadButton;
//
//    
    UITextField *searchInput = self.DashBoardSearchField;
    UIButton *searchEngineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchEngineButton addTarget:self action:@selector(handleSearchEngineButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    searchEngineButton.frame = CGRectMake(5, 5, 62, 28);
    searchInput.leftView = searchEngineButton;
    searchInput.leftViewMode = UITextFieldViewModeAlways;
    [self updateSearchEngine];
}


- (void)viewDidUnload
{
    self.tabsView = nil;
    [self setBrowserView:nil];
    [self setUrlInputKeyboardAccessory:nil];
    [self setDashBoard:nil];
    [self setDashBoardBack:nil];
    [self setDashBoardForward:nil];
    [self setDashBoardHome:nil];
    [self setDashBoardFav:nil];
    [self setDashBoardUrlField:nil];
    [self setDashBoardSearchField:nil];
    [self setDashBoardSetting:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.DashBoardUrlField.frame = CGRectMake(self.DashBoardUrlField.frame.origin.x, 6, 510, 31);
//        self.DashBoardUrlField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"urlField_BG_long_Landscape"]];
        self.DashBoardUrlField.progressImage = [UIImage imageNamed:@"urlField_PB_Landscape"];
        self.DashBoardSearchField.frame = CGRectMake(CGRectGetMaxX(self.DashBoardUrlField.frame)+15, 6, 255, 31);
//        self.DashBoardSearchField.background = [UIImage imageNamed:@"searchField_BG_short_Landscape"];
        self.DashBoardSetting.frame = CGRectMake(CGRectGetMaxX(self.DashBoardSearchField.frame)+10, 0, 44, 44);
        

    }else{
        self.DashBoardUrlField.frame = CGRectMake(self.DashBoardUrlField.frame.origin.x, 6, 390, 31);
//        self.DashBoardUrlField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"urlField_BG_long_Portrait"]];
        self.DashBoardUrlField.progressImage = [UIImage imageNamed:@"urlField_PB_Portrait"];
        self.DashBoardSearchField.frame = CGRectMake(CGRectGetMaxX(self.DashBoardUrlField.frame)+15, 6, 126, 31);
//        self.DashBoardSearchField.background = [UIImage imageNamed:@"searchField_BG_short_Portrait"];
        self.DashBoardSetting.frame = CGRectMake(CGRectGetMaxX(self.DashBoardSearchField.frame)+10, 0, 44, 44);
    }
    
    if (self.searchInputPopover) {
        [self searchFieldActive:YES];
        [self.searchInputPopover presentPopoverFromRect:self.DashBoardSearchField.frame inView:self.DashBoard permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    
    if (self.urlInputPopover) {
        CGSize size = self.urlInputPopover.popoverContentSize;
        size.width = self.DashBoardUrlField.frame.size.width;
        self.urlInputPopover.popoverContentSize = size;
        
        [self.urlInputPopover presentPopoverFromRect:self.DashBoardUrlField.frame inView:self.DashBoard permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    
    if (self.searchEnginePopover) {
        [self.searchEnginePopover presentPopoverFromRect:self.DashBoardSearchField.leftView.frame inView:self.DashBoardSearchField permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    
    if (self.restoreHint) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            self.restoreHint.frame = CGRectMake(800, 38, 230, 73);
        }else{
            self.restoreHint.frame = CGRectMake(545, 38, 230, 73);
        }
    }

    
    [self.homePage relayoutWithOrientation:toInterfaceOrientation];
    
    ////////////////////////////////////////
//    if (self.urlInputPopover) {
//        CGSize size = self.urlInputPopover.popoverContentSize;
//        size.width = self.dashBoardURLInput.width;
//        self.urlInputPopover.popoverContentSize = size;
//    }
//    
//    if (self.searchEnginePopover) {
//        [self.searchEnginePopover presentPopoverFromRect:[(UITextField*)self.dashBoardSearchInput.customView leftView].frame inView:self.dashBoardSearchInput.customView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    }
}


-(void)didReceiveMemoryWarning
{
    [self.webRestorePool makeObjectsPerformSelector:@selector(stopLoading) withObject:nil];
    [self.webRestorePool makeObjectsPerformSelector:@selector(setDelegate:) withObject:nil];
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)reloadHomePage
{
    [self.homePage reloadData];
}

-(void)homePageQuitEditingIfNeeded
{
    [self.homePage quitEditng];
}

-(void)loadUrlforCurrentTab:(NSURL *)url
{
    NSIndexPath *currentIndex = self.tabsView.selectedIndexPath;
    RCTab *tab = (RCTab *)[self.tabsView viewAtIndexPath:currentIndex];
    if (!tab.webView) {
        return;
    }
    
    if (!url.scheme.length) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:url.absoluteString]];
    }
    
    [tab.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.DashBoardUrlField.text = url.absoluteString;
    tab.webView.isWebPage = YES;
    tab.webView.autoresizingMask = RCViewAutoresizingALL;
    [self.homePage removeFromSuperview];
    [self.browserView addSubview:tab.webView];
    tab.webView.frame = self.browserView.bounds;
}

-(void)loadUrl:(NSURL *)url ForTab:(RCTab *)tab
{
    if (!tab.webView) {
        return;
    }
    if (!url.scheme.length) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:url.absoluteString]];
    }
    [tab.webView loadRequest:[NSURLRequest requestWithURL:url]];
    tab.webView.isWebPage = YES;
    tab.webView.autoresizingMask = RCViewAutoresizingALL;
    tab.webView.frame = self.browserView.bounds;
}


-(void)clearAllPopovers
{
    if (self.urlInputPopover) {
        [self.urlInputPopover dismissPopoverAnimated:YES];
        self.urlInputPopover = nil;
    }
    if (self.searchInputPopover) {
        [self searchFieldActive:NO];
        [self.searchInputPopover dismissPopoverAnimated:YES];
        self.searchInputPopover = nil;
    }
    if (self.searchEnginePopover) {
        [self.searchEnginePopover dismissPopoverAnimated:YES];
        self.searchEnginePopover = nil;

    }
    if (self.bookMarkActionSheet) {
        [self.bookMarkActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}


-(RCTab *)currentTab
{
    return (RCTab *)[self.tabsView viewAtIndexPath:self.tabsView.selectedIndexPath];
}

-(void)resumeLastWeb
{
    [self homePageQuitEditingIfNeeded];

    if (self.webRestorePool.count>0) {
        RCWebView *web = [self.webRestorePool lastObject];
        self.preloadWeb = web;
        [self.webRestorePool removeObject:web];
        //    [self.listContent addObject:TITLE_FOR_NEWTAB];
        //    [self.listWebViews addObject:web];
        [self addNewTab];
    }
    if (self.webRestorePool.count <=0) {
        self.restoreTabButton.enabled = NO;
    }
}




-(void)preloadWebView
{
    self.preloadWeb = nil;
    self.preloadWeb = [[RCWebView alloc] initWithFrame:self.browserView.bounds];
}

-(void)updateBackForwardButtonWithTab:(RCTab *)tab
{
    if (tab.webView.isWebPage) {
//        self.DashBoardHome.enabled = YES;
        self.DashBoardBack.enabled = YES;
        self.DashBoardForward.enabled = [tab.webView canGoForward];
    }else{
//        self.DashBoardHome.enabled = NO;
        self.DashBoardBack.enabled = NO;
        if (tab.webView.request) {
            self.DashBoardForward.enabled = YES;
        }else{
            self.DashBoardForward.enabled = NO;
        }
    }
}

-(void)updateNetworkActive
{
    BOOL networkActive = NO;
    for (RCWebView* webView in self.listWebViews) {
        if (webView.isLoading) {
            networkActive = YES;
            break;
        }
    }
    if (networkActive) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}


-(void)searchFieldActive:(BOOL)active
{    
    
    [UIView animateWithDuration:.3 animations:^{
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            if (active) {
                self.DashBoardUrlField.frame = CGRectMake(self.DashBoardUrlField.frame.origin.x, 6, 255, 31);
                self.DashBoardSearchField.frame = CGRectMake(CGRectGetMaxX(self.DashBoardUrlField.frame)+15, 6, 510, 31);
//                self.DashBoardSearchField.background = [UIImage imageNamed:@"searchField_BG_long_Landscape"];
            }else{
                self.DashBoardUrlField.frame = CGRectMake(self.DashBoardUrlField.frame.origin.x, 6, 510, 31);
                self.DashBoardSearchField.frame = CGRectMake(CGRectGetMaxX(self.DashBoardUrlField.frame)+15, 6, 255, 31);
//                self.DashBoardSearchField.background = [UIImage imageNamed:@"searchField_BG_short_Landscape"];
            }

        }else{
            if (active) {
                self.DashBoardUrlField.frame = CGRectMake(self.DashBoardUrlField.frame.origin.x, 6, 126, 31);
                self.DashBoardSearchField.frame = CGRectMake(CGRectGetMaxX(self.DashBoardUrlField.frame)+15, 6, 390, 31);
//                self.DashBoardSearchField.background = [UIImage imageNamed:@"searchField_BG_long_Portrait"];
            }else{
                self.DashBoardUrlField.frame = CGRectMake(self.DashBoardUrlField.frame.origin.x, 6, 390, 31);
                self.DashBoardSearchField.frame = CGRectMake(CGRectGetMaxX(self.DashBoardUrlField.frame)+15, 6, 126, 31);
//                self.DashBoardSearchField.background = [UIImage imageNamed:@"searchField_BG_short_Portrait"];
            }

        }
        
        CGSize size = self.searchInputPopover.popoverContentSize;
        size.width = self.DashBoardSearchField.frame.size.width;
        self.searchInputPopover.popoverContentSize = size;
    }];
}




#pragma mark -
#pragma mark ADD/REMOVE NEW TAB

-(void)addNewBackgroundTab
{
    [self.listContent addObject:TITLE_FOR_NEWTAB];
//    [self.listWebViews addObject:[[RCWebView alloc] initWithFrame:self.browserView.bounds]];
    [self.listWebViews addObject:self.preloadWeb];
    [self performSelector:@selector(preloadWebView) withObject:nil afterDelay:.5];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.listContent.count-1 inSection:0];
    [self.tabsView.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    RCTab *firstTab = (RCTab *)[self.tabsView viewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [firstTab setDisableClose:NO];
}
-(void)addNewTab
{
    if (self.listContent.count>=20) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"标签卡过多" message:@"打开太多标签影响性能，请关闭没用的标签！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    for (UIView* view in [self.browserView subviews]) {
        if ([view isKindOfClass:[RCBookmarkView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self.listContent addObject:TITLE_FOR_NEWTAB];
//    [self.listWebViews addObject:[[RCWebView alloc] initWithFrame:self.browserView.bounds]];
    [self.listWebViews addObject:self.preloadWeb];
    [self performSelector:@selector(preloadWebView) withObject:nil afterDelay:.5];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.listContent.count-1 inSection:0];
    
    [self.tabsView.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    self.tabsView.selectedIndexPath = newIndexPath;
    [self.tabsView.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    RCTab *firstTab = (RCTab *)[self.tabsView viewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [firstTab setDisableClose:NO];
}
-(void)handleAddNewTab:(UIButton *)sender
{
    [self addNewTab];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addNewTab) object:nil];
//    [self performSelector:@selector(addNewTab) withObject:nil afterDelay:.05];
}

-(void)removeHint{
    [self.restoreHint removeFromSuperview];
    self.restoreHint = nil;
}
-(void)tabNeedsToBeClosed:(RCTab *)tab
{
//    [tab.webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//    return;
    
    if (self.closing || self.listContent.count<=1) {
        return;
    }
    self.closing = YES;
    
    BOOL notFirstRestorTab = [[NSUserDefaults standardUserDefaults] boolForKey:@"notFirstRestorTab"];
    if (!notFirstRestorTab) {
        UIImageView* restoreHint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restoreHint"]];
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            restoreHint.frame = CGRectMake(800, 38, 230, 73);
        }else{
            restoreHint.frame = CGRectMake(545, 38, 230, 73);
        }
        [self.view addSubview:restoreHint];
        [self performSelector:@selector(removeHint) withObject:nil afterDelay:3];
//        [restoreHint performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];
        self.restoreHint = restoreHint;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstRestorTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    NSIndexPath *indexPath = [self.tabsView indexPathForView:tab];
    if (!indexPath) {
        return;
    }
    [tab.webView stopLoading];
    
    //for restore
    if (!self.webRestorePool) {
        self.webRestorePool = [NSMutableArray arrayWithCapacity:1];
    }
    [tab.webView performSelector:@selector(reload) withObject:nil afterDelay:.1];
//    [tab.webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    //    [tab.webView goBack];
    
    [self.webRestorePool addObject:tab.webView];
    
    self.restoreTabButton.enabled = YES;
    if (self.webRestorePool.count >= 12) {
        RCWebView* web = [self.webRestorePool objectAtIndex:0];
        [web stopLoading];
        web.delegate = nil;
        [self.webRestorePool removeObjectAtIndex:0];
    }

    
    [self.listContent removeObjectAtIndex:indexPath.row];
    [self.listWebViews removeObjectAtIndex:indexPath.row];
    
    [self.tabsView.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

    
    if (indexPath.row <= self.tabsView.selectedIndexPath.row) {
        self.tabsView.closing = YES;
        self.tabsView.selectedIndexPath = [NSIndexPath indexPathForRow:MAX(self.tabsView.selectedIndexPath.row-1, 0) inSection:0];
        self.tabsView.closing = NO;
    }
//    if (self.tabsView.selectedIndexPath.row < 0) {
//        self.tabsView.selectedIndexPath = [NSIndexPath indexPathForRow: 0 inSection:0];
//    }
    
    if (self.listContent.count<=1) {
        RCTab *lastTab = (RCTab *)[self.tabsView viewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        if (!lastTab.webView.isWebPage) {
            [lastTab setDisableClose:YES];
//        }
    }
    
    [tab.webView reload];
    self.closing = NO;
}


#pragma mark -
#pragma mark Updating loading state && RCTabDelegate
-(void)updateLoadingState
{
    RCTab* tab = [self currentTab];
    //    if (tab.webView.isLoading) {
    [self.reloadStopButton setSelected:tab.webView.isLoading];
    //    }
}

-(void)RCTab:(RCTab *)tab LoadingProgressChanged:(CGFloat)progress
{
//    NSIndexPath *indexPath = [self.tabsView indexPathForView:tab];
//    if ([indexPath isEqual:self.tabsView.selectedIndexPath]) {
    if (tab == [self currentTab]) {
        RCTab *tab = [self currentTab];
        if (tab.webView.isWebPage) {
            [self updateBackForwardButtonWithTab:tab];
            self.DashBoardUrlField.loadingProgress = [NSNumber numberWithFloat:progress];
        }
        return;
    }

}


-(void)RCTab:(RCTab *)tab StartLoadingWebView:(RCWebView *)webView WithRequest:(NSURLRequest *)request
{
//    NSIndexPath *indexPath = [self.tabsView indexPathForView:tab];
    //    if ([indexPath isEqual:self.tabsView.selectedIndexPath] && tab.webView.isWebPage) {
    if (webView == [self currentTab].webView && tab.webView.isWebPage) {
        [self updateLoadingState];
        [self updateBackForwardButtonWithTab:tab];
//        if ([[webView url].absoluteString isEqualToString:@"about:blank"]) {
        self.DashBoardUrlField.text = request.mainDocumentURL.absoluteString;//request.URL.absoluteString;
//        }else{
//            self.DashBoardUrlField.text = [webView url].absoluteString;
//        }
    }
}

-(void)RCTab:(RCTab *)tab FinishLoadingWebView:(RCWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString: self.JSToolCode];    
    [webView stringByEvaluatingJavaScriptFromString:@"MyIPhoneApp_ModifyLinkTargets()"];
    NSIndexPath *indexPath = [self.tabsView indexPathForView:tab];
    if (indexPath) {
        [self.listContent replaceObjectAtIndex:indexPath.row withObject:tab.titleLabel.text];
    }
    
//    if ([indexPath isEqual:self.tabsView.selectedIndexPath] && tab.webView.isWebPage) {
    if (webView == [self currentTab].webView && tab.webView.isWebPage) {
        [self updateBackForwardButtonWithTab:tab];
        
        self.DashBoardUrlField.text = webView.request.URL.absoluteString;
        [self updateLoadingState];
    }
    
    [self updateNetworkActive];
    
}

//-(void)updateUrlForWebStart:(UIWebView*)webView{
//    NSLog(@"22222222 :%@",webView.request.URL);
//    self.DashBoardUrlField.text = webView.request.URL.absoluteString;
//}

-(void)RCTab:(RCTab *)tab DidStartLoadingWebView:(RCWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString: self.JSToolCode];

//    NSIndexPath *indexPath = [self.tabsView indexPathForView:tab];
    //    if ([indexPath isEqual:self.tabsView.selectedIndexPath] && tab.webView.isWebPage) {
    if (webView == [self currentTab].webView && tab.webView.isWebPage) {
        if (webView.request.URL.absoluteString.length) {
//            [self performSelector:@selector(updateUrlForWebStart:) withObject:webView afterDelay:.1];
//            [self.DashBoardUrlField performSelector:@selector(setText:) withObject:webView.request.URL.absoluteString afterDelay:.1];
//            if (!webView.canGoBack) {
//                self.DashBoardUrlField.text = webView.request.URL.absoluteString;//[webView url].absoluteString; //webView.request.URL.absoluteString;  // keeped to comment out
//            }
        }
        [self updateLoadingState];
    }
    [self updateNetworkActive];
}

-(void)RCTab:(RCTab *)tab DidFailLoadingWebView:(RCWebView *)webView WithErrorCode:(NSError *)error
{
    NSLog(@"fail");
    switch ([error code]) {
        case kCFURLErrorCancelled :
        {
            // Do nothing in this case
            break;
        }
        default:
        {
            NSLog(@"fail error: %@",error);
            break;
        }
    }
    [self updateLoadingState];
    [self updateNetworkActive];


}

-(void)RCTab:(RCTab *)tab OpenLink:(NSURL *)link
{
    [self loadUrlforCurrentTab:link];
}
-(void)RCTab:(RCTab *)tab OpenLinkAtNewTab:(NSURL *)link
{
    [self addNewTab];
    [self loadUrlforCurrentTab:link];
}
-(void)RCTab:(RCTab *)tab OpenLinkAtBackground:(NSURL *)link
{
    [self addNewBackgroundTab];
    RCTab *lastTab = (RCTab *)[self.tabsView viewAtIndexPath:[NSIndexPath indexPathForRow:self.listContent.count-1 inSection:0]];

    [self loadUrl:link ForTab:lastTab];
}

#pragma mark -
#pragma mark EasyTableViewDelegate

// These delegate methods support both example views - first delegate method creates the necessary views

- (UIView*)easyTableView:(EasyTableView*)easyTableView viewForFooterInSection:(NSInteger)section;
{
//    UIView *backgound = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 79, 28)];
//    backgound.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_add_BG"]];
//    backgound.transform = CGAffineTransformMakeRotation(M_PI);
    
    UIButton* addNew = [UIButton buttonWithType:UIButtonTypeCustom];
    addNew.frame = CGRectMake(0, 0, 60, 36);
    [addNew setBackgroundImage:[UIImage imageNamed:@"tab_add_BG"] forState:UIControlStateNormal];
    [addNew setBackgroundImage:[UIImage imageNamed:@"tab_add_BG"] forState:UIControlStateHighlighted];

//    addNew.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_add_BG"]];
    [addNew setImage:[UIImage imageNamed:@"tab_add_normal"] forState:UIControlStateNormal];
    [addNew setImage:[UIImage imageNamed:@"tab_add_hite"] forState:UIControlStateHighlighted];
    [addNew addTarget:self action:@selector(handleAddNewTab:) forControlEvents:UIControlEventTouchUpInside];
    self.addNew = addNew;
//    [backgound addSubview:addNew];
    
    return addNew;
}


-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section
{
    return self.listContent.count;
}


- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
    RCTab *tab = [[RCTab alloc]init];
    tab.delegate = self;
    tab.backgroundView.image = [UIImage imageNamed:@"tabBG_normal"];
    tab.selectedBackgroundView.image = [UIImage imageNamed:@"tabBG_hite"];
    return tab;
}

// Second delegate populates the views with data from a data source
- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath {
    RCTab *tab = (RCTab *)view;
    if ([easyTableView.selectedIndexPath isEqual: indexPath]) {
        [tab setSelected:YES];
    }else{
        [tab setSelected:NO];
    }
    tab.webView = [self.listWebViews objectAtIndex:indexPath.row];
//    tab.webView.longPressDelegate = tab;
//    tab.webView.delegate = tab;
    if (tab.webView.isWebPage) {
        tab.titleLabel.text = [tab.webView title];
        NSURL *url = [[NSURL alloc] initWithScheme:[tab.webView.request.URL scheme] host:[tab.webView.request.URL host] path:@"/favicon.ico"];
        [tab.favIcon setImageURL:url];
    }else{
        tab.titleLabel.text = [self.listContent objectAtIndex:indexPath.row];
        [tab.favIcon setImageURL:nil];
    }
}

// Optional delegate to track the selection of a particular cell
- (void)easyTableView:(EasyTableView *)easyTableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)newIndex deselectedView:(UIView *)deselectedView AtIndexPath:(NSIndexPath *)oldIndex{
    [self homePageQuitEditingIfNeeded];
    
    RCTab *dsbackgroundView = (RCTab *)deselectedView;
    [dsbackgroundView setSelected:NO];
    
    RCTab *sbackgroundView = (RCTab *)selectedView;
    [sbackgroundView setSelected:YES];

 
    

    
//    [easyTableView.tableView insertSubview:[easyTableView.tableView cellForRowAtIndexPath:newIndex] belowSubview:easyTableView.tableView.tableHeaderView];
    [easyTableView.tableView bringSubviewToFront:[easyTableView.tableView cellForRowAtIndexPath:newIndex]];
    [easyTableView.tableView bringSubviewToFront:easyTableView.sectionFooter];
    
    
    [dsbackgroundView.webView removeFromSuperview];
    
    if (sbackgroundView.webView.isWebPage) {
        [self.homePage removeFromSuperview];
        sbackgroundView.webView.autoresizingMask = RCViewAutoresizingALL;
        [self.browserView addSubview:sbackgroundView.webView];
        sbackgroundView.webView.frame = self.browserView.bounds;
    }else{
        [self restoreHomePage];
    }
    
    
    RCUrlField *urlInput = self.DashBoardUrlField;
    if (sbackgroundView.webView.isWebPage) {
        urlInput.text = sbackgroundView.webView.request.URL.absoluteString;
        if (sbackgroundView.loadingProgress <=0 || sbackgroundView.loadingProgress>=1) {
            urlInput.loadingProgress = 0;
        }
    }else{
        urlInput.text = nil;
        urlInput.loadingProgress = 0;
    }
    
    [self updateBackForwardButtonWithTab:sbackgroundView];
    
    [easyTableView.tableView scrollToRowAtIndexPath:newIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


-(void)easyTableView:(EasyTableView *)easyTableView WillDisplayCell:(UITableViewCell *)cell AtIndex:(NSIndexPath *)indexPath
{
    RCTab *tab = (RCTab *)[cell viewWithTag:CELL_CONTENT_TAG];
    tab.clipsToBounds = NO;
    
    if (self.listContent.count <=1 && indexPath.row == 0) {
        [tab setDisableClose:YES];
    }

    if ([indexPath isEqual:easyTableView.selectedIndexPath]) {
        [easyTableView.tableView bringSubviewToFront:cell];
    }
}




#pragma mark -
#pragma mark DashBoard Section


-(void)updateSearchEngine
{
    UIButton * searchEngineButton = (UIButton *)self.DashBoardSearchField.leftView;
    NSNumber *searchEngine = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchEngine"];
    if (!searchEngine) {
        searchEngine = [NSNumber numberWithInt:0];
        [[NSUserDefaults standardUserDefaults] setObject:searchEngine forKey:@"searchEngine"];
    }
//    NSString *imgName = [NSString stringWithFormat:@"%@_full",searchEngine];
    [searchEngineButton setBackgroundImage:[RCSearchEngineSwitchViewController imageForSEtype:searchEngine.intValue isFull:YES] forState:UIControlStateNormal];
    if (self.searchEnginePopover) {
        [self.searchEnginePopover dismissPopoverAnimated:YES];
        self.searchEnginePopover = nil;
    }
}

-(void)reloadOrStop:(UIButton*)sender;
{
    [self homePageQuitEditingIfNeeded];
    
    RCTab* tab = [self currentTab];
    if (tab.webView.isWebPage) {
        if (tab.webView.loading){
            [tab.webView stopLoading];
        }
        else {
            [tab.webView stopLoading];
            [tab.webView reload];
        }
    }
}


-(void)handleSearchEngineButtonPress:(UIButton*)sender
{
    [self homePageQuitEditingIfNeeded];

    if (self.searchEnginePopover) {
        [self clearAllPopovers];
        return;
    }else{
//        [self clearAllPopovers];
//        [self.DashBoardUrlField resignFirstResponder];
//        [self.DashBoardSearchField resignFirstResponder];
        
        RCSearchEngineSwitchViewController *searchEngineSwitchViewController = [[RCSearchEngineSwitchViewController alloc] initWithStyle:UITableViewStylePlain];
        searchEngineSwitchViewController.engineDelegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchEngineSwitchViewController];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        self.searchEnginePopover = popover;
        popover.delegate = self;
        [popover presentPopoverFromRect:sender.frame inView:self.DashBoardSearchField permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    
}




- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == self.urlInputPopover) {
        [self.DashBoardUrlField resignFirstResponder];
        self.urlInputPopover = nil;
    }else if (popoverController == self.searchInputPopover) {
        [self.DashBoardSearchField resignFirstResponder];
        [self searchFieldActive:NO];
        self.searchInputPopover = nil;
    }else if (popoverController == self.searchEnginePopover)
    {
        self.searchEnginePopover = nil;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSURL *url = nil;
    if (textField == self.DashBoardUrlField) {
        url = [NSURL URLWithString:textField.text];
        [self loadUrlforCurrentTab:url];
    }else if (textField == self.DashBoardSearchField){
        NSString* searchWords = textField.text;
        NSNumber *searchEngine = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchEngine"];
        [self loadSearchResult:[RCSearchEngineSwitchViewController searchUrlForSEtype:searchEngine.intValue keyWord:searchWords] keyWord:searchWords];
    }
    
    [textField resignFirstResponder];
    [self clearAllPopovers];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self homePageQuitEditingIfNeeded];

//    CGRect rect = textField.frame;
//    rect.size.width = 600;
//    textField.frame = rect;
//    return YES;
    
    [self clearAllPopovers];
    RCTab* tab = [self currentTab];
    if (tab.webView.isLoading) {
        [tab.webView stopLoading];
    }
    if (textField == self.DashBoardUrlField) {
        
        RCUrlInputViewController *urlInputViewController = [[RCUrlInputViewController alloc] initWithStyle:UITableViewStylePlain];
        urlInputViewController.delegate = self;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:urlInputViewController];
        popover.delegate =self;
        CGSize size = popover.popoverContentSize;
        size.width = textField.frame.size.width;
        popover.popoverContentSize = size;
        popover.passthroughViews = @[textField];
        [popover presentPopoverFromRect:textField.frame inView:self.DashBoard permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [urlInputViewController loadURLSuggestionWithText:textField.text];
        self.urlInputPopover = popover;
        
        return YES;
    }else if (textField == self.DashBoardSearchField){

        RCSearchInputViewController *searchInputViewController = [[RCSearchInputViewController alloc] initWithStyle:UITableViewStylePlain];
        searchInputViewController.searchDelegate = self;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:searchInputViewController];
        popover.delegate =self;
        popover.passthroughViews = @[textField];
        [searchInputViewController loadSearchSuggestionWithText:textField.text];
        self.searchInputPopover = popover;
        [self searchFieldActive:YES];
        [popover presentPopoverFromRect:textField.frame inView:self.DashBoard permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

        return YES;
    }
    
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.DashBoardUrlField) {
        RCUrlInputViewController *VC = (RCUrlInputViewController *)self.urlInputPopover.contentViewController;
        [VC loadURLSuggestionWithText:newString];
    }else if (textField == self.DashBoardSearchField){
        RCSearchInputViewController *VC = (RCSearchInputViewController *)self.searchInputPopover.contentViewController;
        [VC loadSearchSuggestionWithText:newString];
    }
    return YES;
}



-(IBAction)handleKeyBoardAccessoryInput:(UIButton *)sender {
    UITextField *urlInput = self.DashBoardUrlField;
    RCUrlInputViewController *VC = (RCUrlInputViewController *)self.urlInputPopover.contentViewController;
    
    if ([sender.titleLabel.text isEqualToString:@"www."] ||
        [sender.titleLabel.text isEqualToString:@"hd."]) {
        urlInput.text = [sender.titleLabel.text stringByAppendingString:urlInput.text];
    }else if ([sender.titleLabel.text isEqualToString:@".com"]||
              [sender.titleLabel.text isEqualToString:@".cn"]||
              [sender.titleLabel.text isEqualToString:@".net"]){
        urlInput.text = [urlInput.text stringByAppendingString:sender.titleLabel.text];
    }else if ([sender.titleLabel.text isEqualToString:@"清空"]){
        urlInput.text = nil;
    }
    [VC loadURLSuggestionWithText:urlInput.text];
}



- (IBAction)handleBackButtonPress:(UIButton *)sender {
    [self homePageQuitEditingIfNeeded];

    RCTab *tab = (RCTab *)[self.tabsView viewAtIndexPath:self.tabsView.selectedIndexPath];
    //    UITextField *urlInput = (UITextField *)self.dashBoardURLInput.customView;
    if ([tab.webView canGoBack]) {
        [tab.webView goBack];
    }else{
        [self handleHomeButtonPress:nil];
    }
}


- (IBAction)handleForwardButtonPress:(UIButton *)sender {
    [self homePageQuitEditingIfNeeded];

    RCTab *tab = (RCTab *)[self.tabsView viewAtIndexPath:self.tabsView.selectedIndexPath];
    if (tab.webView.isWebPage) {
        [tab.webView goForward];
    }else{
        [self.homePage removeFromSuperview];
        [self.browserView addSubview:tab.webView];
        tab.webView.frame = self.browserView.bounds;
        tab.webView.isWebPage = YES;
        
        NSString* title = [tab.webView title];
        [self.listContent replaceObjectAtIndex:self.tabsView.selectedIndexPath.row withObject:title];
        tab.titleLabel.text = title;
        
        self.DashBoardUrlField.text = tab.webView.request.URL.absoluteString;
        NSURL *url = [[NSURL alloc] initWithScheme:[tab.webView.request.URL scheme] host:[tab.webView.request.URL host] path:@"/favicon.ico"];
        [tab.favIcon setImageURL:url];
        [self updateBackForwardButtonWithTab:tab];
    }
}

- (IBAction)handleHomeButtonPress:(UIButton *)sender {

    for (UIView *view in self.browserView.subviews) {
        if ([view isKindOfClass:[RCBookmarkView class]]) {
            [view removeFromSuperview];
            return;
        }
    }
    
    
    if (self.homePage.superview) {
        [self.homePage scroll];
    }
    
    [self homePageQuitEditingIfNeeded];

    RCTab *tab = (RCTab *)[self.tabsView viewAtIndexPath:self.tabsView.selectedIndexPath];
    if (tab.webView.isWebPage) {
        [tab.webView removeFromSuperview];
        tab.webView.isWebPage = NO;
        if (tab.webView.isLoading) {
            [tab.webView stopLoading];
        }
    }
    [self.listContent replaceObjectAtIndex:self.tabsView.selectedIndexPath.row withObject:TITLE_FOR_NEWTAB];
    tab.titleLabel.text = TITLE_FOR_NEWTAB;
    [tab.favIcon setImageURL:nil];
    
    [self restoreHomePage];
    [self updateBackForwardButtonWithTab:tab];
    [self updateNetworkActive];
    
}

- (IBAction)handleFavButtonPress:(UIButton *)sender {
    [self homePageQuitEditingIfNeeded];


    if (self.bookMarkActionSheet) {
        [self clearAllPopovers];
        self.bookMarkActionSheet = nil;
        return;
    }
    [self clearAllPopovers];
    
    UIActionSheet *FavButtonActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if (!self.homePage.superview) {
        
        [FavButtonActionSheet addButtonWithTitle:@"添加到收藏夹"];
    }
    [FavButtonActionSheet addButtonWithTitle:@"打开网址收藏夹"];
    [FavButtonActionSheet showFromRect:self.DashBoardFav.frame inView:self.DashBoard animated:YES];
    
    self.bookMarkActionSheet = FavButtonActionSheet;
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex<0) {
        return;
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"添加到收藏夹"]) {
        RCBookmarkPopoverViewController* bookmarkAdd = [[RCBookmarkPopoverViewController alloc] initWithNibName:@"RCBookmarkPopoverViewController" bundle:nil];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:bookmarkAdd];
        self.bookmarkPopover = [[UIPopoverController alloc] initWithContentViewController:nav];
        [self.bookmarkPopover presentPopoverFromRect:self.DashBoardFav.frame inView:self.DashBoard permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        bookmarkAdd.popover = self.bookmarkPopover;
        
        bookmarkAdd.bookmarkTitle.text = [self.currentTab.webView title];
        bookmarkAdd.bookmarkUrl.text = [self.currentTab.webView url].absoluteString;
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"打开网址收藏夹"]){
        RCBookmarkView *bookmarkView = [[RCBookmarkView alloc] init];
//        [self.view.superview insertSubview:bookmarkView belowSubview:self.view];
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.5;
//        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        animation.type = kCATransitionMoveIn;
//        animation.subtype = kCATransitionFromLeft;
//        NSUInteger view1 = [[self.view.superview subviews] indexOfObject:self.view];
//        NSUInteger view2 = [[self.view.superview subviews] indexOfObject:bookmarkView];
//        [self.view.superview exchangeSubviewAtIndex:view2 withSubviewAtIndex:view1];
//        [[self.view.superview layer] addAnimation:animation forKey:@"animation"];

        bookmarkView.frame = self.browserView.bounds;
        bookmarkView.rootVC = self;
        [self.browserView addSubview:bookmarkView];
        RCTab* tab = [self currentTab];
        if (tab.webView.isLoading) {
            [tab.webView stopLoading];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.bookMarkActionSheet = nil;
}



- (IBAction)handleSettingButtonPress:(id)sender {
    [self homePageQuitEditingIfNeeded];

    RCSettingViewController *settingViewController = [[RCSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingViewController.mainVC = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
}


//////popovers' delegates/////
-(void)urlSuggestionSelected:(NSURL *)url
{
    [self.urlInputPopover dismissPopoverAnimated:YES];
    self.urlInputPopover = nil;
    [self.DashBoardUrlField resignFirstResponder];
    [self loadUrlforCurrentTab:url];
}

-(void)loadSearchResult:(NSURL *)url keyWord:(NSString *)key
{
    [self.searchInputPopover dismissPopoverAnimated:YES];
    self.searchInputPopover = nil;
    [self.DashBoardSearchField resignFirstResponder];
    self.DashBoardSearchField.text = key;
    [self searchFieldActive:NO];
    [self loadUrlforCurrentTab:url];
}

#pragma mark -
#pragma mark HomePage Section
-(void)restoreHomePage
{
    if (!self.homePage.superview) {
        [self.browserView addSubview:self.homePage];
        self.homePage.frame = self.browserView.bounds;
    }
    
    for (UIView* view in [self.browserView subviews]) {
        if ([view isKindOfClass:[RCBookmarkView class]]) {
            [view removeFromSuperview];
        }
    }

    
    self.DashBoardUrlField.loadingProgress = [NSNumber numberWithFloat:0];
    self.DashBoardUrlField.text = nil;
    
    [self updateLoadingState];
}


-(void)homePage:(RCHomePage *)homePage lunchUrl:(NSURL *)url WithOption:(RCHomePageLunchOptions)option
{
    switch (option) {
        case RCHomePageLunchNewBackgroundTab:{
            [self addNewBackgroundTab];
            RCTab *lastTab = (RCTab *)[self.tabsView viewAtIndexPath:[NSIndexPath indexPathForRow:self.listContent.count-1 inSection:0]];
            
            [self loadUrl:url ForTab:lastTab];
        }
            break;
        case RCHomePageLunchNewTab:{
            [self addNewTab];
            [self loadUrlforCurrentTab:url];
        }
            break;
        case RCHomePageLunchNomal:
        default:
            [self loadUrlforCurrentTab:url];
            break;
    }
}

-(void)homePageNeedsAddNewNavIcons:(RCHomePage *)homePage
{
    RCConfigueNavIconsViewController *configueNavIconsViewController = [[RCConfigueNavIconsViewController alloc] init];
    configueNavIconsViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:configueNavIconsViewController animated:YES];
    CGPoint center = configueNavIconsViewController.view.superview.center;
    configueNavIconsViewController.view.superview.frame = CGRectMake(0, 0, 701, 620);//it's important to do this after presentModalViewController
    configueNavIconsViewController.view.superview.center = center;
    configueNavIconsViewController.mainVC =self;
}



@end
