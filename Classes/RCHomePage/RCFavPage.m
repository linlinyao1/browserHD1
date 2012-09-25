//
//  RCFavPage.m
//  browserHD
//
//  Created by imac on 12-8-16.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFavPage.h"
#import "RCRecordData.h"
#import "RCFavView.h"

//#define kFavScreenShotButtonTag 301
//#define kFavTitleLabelTag 302
#define kFavPageInvalidIndex 9999
#define kFavPageIndexBase 800


@interface RCFavPage ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSMutableArray *listContent;
@property (nonatomic,strong) NSMutableArray *listViews;
@property (nonatomic,strong) NSMutableArray *listImages;

-(NSInteger)itemIndexForLocation:(CGPoint)location;
@end

@implementation RCFavPage
@synthesize listContent = _listContent;
@synthesize delegate = _delegate;
@synthesize listViews = _listViews;
@synthesize listImages = _listImages;
@synthesize editing = _editing;

-(void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        for (RCFavView *favView in self.listViews) {
            if (!CGRectIsEmpty(favView.frame)) {
                favView.editing = _editing;
            }
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = RCViewAutoresizingALL;
        // Initialization code
        self.listViews = [NSMutableArray arrayWithCapacity:9];
        self.listImages = [NSMutableArray arrayWithCapacity:9];
        for (int i=0 ; i<9; i++) {
            RCFavView *favView = [[RCFavView alloc] initWithFrame:CGRectZero];
            [favView.closeButton addTarget:self action:@selector(handleCloseButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.listViews addObject:favView];
            [self addSubview:favView];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGeusture:)];
        tap.cancelsTouchesInView = NO;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isKindOfClass:[UIButton class]]) {
//        return NO;
//    }
//    return YES;
//}

-(NSInteger)itemIndexForLocation:(CGPoint)location
{
    for (int i=0; i<self.listViews.count; i++) {
        RCFavView* favView = [self.listViews objectAtIndex:i];
        if (CGRectContainsPoint(favView.frame, location)) {
            CGPoint detailLocation = [favView convertPoint:location fromView:self];
            if (CGRectContainsPoint(favView.screenShot.frame, detailLocation)) {
//                NSLog(@"item tapped at index: 3 : %d",i);
                return i;
            }

            break;
        }
    }
//    NSLog(@"item tapped at index: invalid");
    return kFavPageInvalidIndex;

}

-(void)handleTapGeusture:(UITapGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self];
    NSInteger index = [self itemIndexForLocation:location];
    
    if (index == kFavPageInvalidIndex) {
        if (self.isEditing) {
            self.editing = NO;
        }
    }else{
        if (!self.isEditing) {
            NSLog(@"lunch url");
            BookmarkObject *favObj = [self.listContent objectAtIndex:index];
            if ([self.delegate respondsToSelector:@selector(favariteWebsiteSelected:)]) {
                [self.delegate favariteWebsiteSelected:favObj.url];
            }
        }
    }
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [gesture locationInView:self];
        NSInteger index = [self itemIndexForLocation:location];
        if (index!= kFavPageInvalidIndex && !self.isEditing) {
            self.editing = YES;
        }
    }
}

-(void)handleCloseButton:(UIButton*)sender
{
    NSInteger index = kFavPageInvalidIndex;
    for (int i=0; i<self.listViews.count; i++) {
        RCFavView* favView = [self.listViews objectAtIndex:i];
        if (favView.closeButton == sender) {
            index = i;
            break;
        }
    }
    if (index != kFavPageInvalidIndex) {
        BookmarkObject *favObj = [self.listContent objectAtIndex:index];

        NSMutableArray *historyArray = [RCRecordData recordDataWithKey:RCRD_HISTORY];
        for (BookmarkObject* history in historyArray) {
            if ([history.url.absoluteString isEqualToString:favObj.url.absoluteString]) {
                history.count = [NSNumber numberWithInt:0];
                break;
            }
        }

        [RCRecordData updateRecord:historyArray ForKey:RCRD_HISTORY];

        NSArray *favArray = [historyArray sortedArrayUsingComparator:^NSComparisonResult(BookmarkObject *obj1, BookmarkObject *obj2) {
            return [obj2.count compare:obj1.count];
        }];
        favArray = [favArray subarrayWithRange:NSMakeRange(0, MIN(favArray.count, MAX_FAV_COUNT))];
        [RCRecordData updateRecord:favArray ForKey:RCRD_FAV];
        
        [self reloadData];
    }

}

-(void)reloadData
{
    if (self.listContent) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.listContent = [RCRecordData recordDataWithKey:RCRD_FAV];
            [self.listImages removeAllObjects];
            for (BookmarkObject *favObj in self.listContent) {
                UIImage *img = [RCRecordData getImageForURL:favObj.url];
                if (img) {
                    [self.listImages addObject:img];
                }else{
                    [self.listImages addObject:[UIImage imageNamed:@"defaultFav"]];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setNeedsLayout];
            });
        });
    }else{
        self.listContent = [RCRecordData recordDataWithKey:RCRD_FAV];
        [self.listImages removeAllObjects];
        for (BookmarkObject *favObj in self.listContent) {
            UIImage *img = [RCRecordData getImageForURL:favObj.url];
            if (img) {
                [self.listImages addObject:img];
            }else{
                [self.listImages addObject:[UIImage imageNamed:@"defaultFav"]];
            }
        }
        [self setNeedsLayout];
    }
}

-(CGSize)sizeForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        return CGSizeMake(222, 141+title_gap+title_hight);
    }
    else
    {
        return CGSizeMake(198, 191+title_gap+title_hight);
    }
}

-(void)layoutSubviews
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize size = [self sizeForInterfaceOrientation:orientation];
    NSInteger leftMargin,topMargin,Vgap,Hgap;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        leftMargin = 112;
        topMargin = 41;
        Vgap = 48-title_gap-title_hight;
        Hgap = 48;
    }else{
        leftMargin = 50;
        topMargin = 63;
        Vgap = 48-title_gap-title_hight;
        Hgap = 35;
    }
    
    
    CGRect rect = CGRectMake(leftMargin, topMargin, size.width, size.height);
    for (int i=0 ; i<MIN(self.listViews.count, self.listContent.count); i++) {
        BookmarkObject *favObj = [self.listContent objectAtIndex:i];

        RCFavView *favView = [self.listViews objectAtIndex:i];
        favView.frame = rect;
        favView.titleLabel.text = favObj.name;
        favView.screenShot.image = [self.listImages objectAtIndex:i];
        
        favView.editing = self.isEditing;
        
        rect = CGRectOffset(rect, rect.size.width+Hgap, 0);
        if (CGRectGetMaxX(rect) > self.bounds.size.width) {
            rect = CGRectMake(leftMargin, CGRectGetMaxY(rect)+Vgap , size.width, size.height);
        }
    }
}




//#pragma mark - GMGridViewDataSource
//
//- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
//{
//    return  self.listContent.count;//MAX_FAV_COUNT;
//}
//- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//        return CGSizeMake(285, 205);
//    }
//    else
//    {
//        return CGSizeMake(230, 275);
//    }
//}
//- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
//{
//    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//    
//    GMGridViewCell *cell = [gridView dequeueReusableCell];
//    
//    if (!cell)
//    {
//        cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
//        cell.deleteButtonOffset = CGPointMake(-15, -15);
//        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//        view.backgroundColor = [UIColor clearColor];
////        view.autoresizingMask = RCViewAutoresizingALL;
////        view.layer.masksToBounds = NO;
////        view.layer.cornerRadius = 8;
//        cell.contentView = view;
//        
//    }
//    
//    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    
//    BookmarkObject *favObj = [self.listContent objectAtIndex:index];
//
//    
////    UIButton *favScreenShot = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *screenShot = [RCRecordData getImageForURL:favObj.url];
//    UIImageView *favScreenShot = [[UIImageView alloc] initWithImage:screenShot];
//    favScreenShot.clipsToBounds = YES;
//    favScreenShot.contentMode = UIViewContentModeScaleAspectFill;
//    favScreenShot.autoresizingMask = RCViewAutoresizingALL;
//    favScreenShot.tag = kFavScreenShotButtonTag;
//    [cell.contentView addSubview:favScreenShot];
//    favScreenShot.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height*0.8);
//    
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(favScreenShot.frame), size.width, size.height*0.2)];
//    titleLabel.autoresizingMask = RCViewAutoresizingInternal|UIViewAutoresizingFlexibleTopMargin;//RCViewAutoresizingInternal | UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//    titleLabel.tag = kFavTitleLabelTag;
//    titleLabel.text = favObj.name;
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textAlignment = UITextAlignmentCenter;
//    [cell.contentView addSubview:titleLabel];
//    
//    return cell;
//}
//- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)index
//{
//    NSLog(@"Did tap at index %d", index);
//    BookmarkObject *favObj = [self.listContent objectAtIndex:index];
//    if ([self.delegate respondsToSelector:@selector(favariteWebsiteSelected:)]) {
//        [self.delegate favariteWebsiteSelected:favObj.url];
//    }
//}
//
//
//- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
//{
//    NSLog(@"delete");
//    BookmarkObject *favObj = [self.listContent objectAtIndex:index];
//    
//    NSMutableArray *historyArray = [RCRecordData recordDataWithKey:RCRD_HISTORY];
//    for (BookmarkObject* history in historyArray) {
//        if ([history.url.absoluteString isEqualToString:favObj.url.absoluteString]) {
//            history.count = [NSNumber numberWithInt:0];
//            break;
//        }
//    }
//    
//    [RCRecordData updateRecord:historyArray ForKey:RCRD_HISTORY];
//    
//    NSArray *favArray = [historyArray sortedArrayUsingComparator:^NSComparisonResult(BookmarkObject *obj1, BookmarkObject *obj2) {
//        return [obj2.count compare:obj1.count];
//    }];
//    favArray = [favArray subarrayWithRange:NSMakeRange(0, MIN(favArray.count, MAX_FAV_COUNT))];
//    [RCRecordData updateRecord:favArray ForKey:RCRD_FAV];
//    
//    [self reloadData];
//}
//
//- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
//{
//    return YES;
//}


@end
