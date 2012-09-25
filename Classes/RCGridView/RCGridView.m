//
//  RCGridView.m
//  RCWebBrowser
//
//  Created by imac on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCGridView.h"
#import "QuartzCore/QuartzCore.h"

#define RCGRIDVIEW_INVALID_INDEX 9999
#define RCGRIDVIEW_ADDBUTTON_INDEX 9998

@interface RCGridView ()<RCGridViewCellDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *addButton;
@property (nonatomic) CGPoint movingPosition;
@property (nonatomic,strong) NSMutableSet *resuePool;
@property (nonatomic,assign) NSInteger numberOfCells;
@property (nonatomic,strong) NSMutableArray *listContent;

@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;

-(NSInteger)indexForCellAtPoint:(CGPoint)point;
-(RCGridViewCell*)cellAtPoint:(CGPoint)point;

-(void)checkMovingCellPosition:(RCGridViewCell*)movingCell;

-(void)queueReusableCell:(RCGridViewCell*)cell;
@end


@implementation RCGridView
//public
@synthesize verticalCellGap = _verticalCellGap;
@synthesize horizonalCellGap = _horizonalCellGap;
@synthesize cellSize = _cellSize;
@synthesize minEdgeInsets = _minEdgeInsets;
@synthesize editing = _editing;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize disableEditWhenTapInvalid = _disableEditWhenTapInvalid;
//private
@synthesize scrollView = _scrollView;
@synthesize addButton = _addButton;
@synthesize longPress = _longPress;
@synthesize tap  = _tap;
@synthesize pan = _pan;
@synthesize movingCell = _movingCell;
@synthesize movingPosition = _movingPosition;
@synthesize resuePool = _resuePool;
@synthesize numberOfCells = _numberOfCells;
@synthesize listContent = _listContent;

#pragma mark - setter & getter
-(void)setDataSource:(NSObject<RCGridViewDataSource> *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    [self reloadData];
}

-(void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        if (_editing) {
            if ([self.delegate respondsToSelector:@selector(gridViewStartEditing:)]) {
                [self.delegate gridViewStartEditing:self];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(gridViewEndEditing:)]) {
                [self.delegate gridViewEndEditing:self];
            }
        }
        
        for (RCGridViewCell *cell in [self.scrollView subviews]) {
            //for addbutton to be complete button
            if (cell == self.addButton) {
                cell.hidden = _editing;
                continue;
            }
            if (![cell isKindOfClass:[RCGridViewCell class]]) {
                continue;
            }
            cell.editing = _editing;
        }
    }
}

//-(UIScrollView *)scrollView
//{
//    
//}


#pragma mark - Main Body

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = RCViewAutoresizingALL;
//        self.scrollView.canCancelContentTouches = NO;
//        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];
        
        self.listContent = [NSMutableArray arrayWithCapacity:1];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
//        longPress.delegate = self;
        self.longPress = longPress;
        [self.scrollView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapped:)];
        tap.delegate = self;
        self.tap = tap;
        [self.scrollView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//        pan.delaysTouchesBegan = YES;
        self.pan = pan;
        pan.delegate = self;
        [self.scrollView addGestureRecognizer:pan];
        
        //default setting
        self.cellSize = CGSizeMake(64, 64);
        self.minEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.verticalCellGap = 10;
        self.horizonalCellGap = 10;
    }
    return self;
}


-(void)reloadData
{    
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.addButton = nil;
    
    NSInteger numberOfCells = [self.dataSource numberOfCellsInGridView:self];
    self.numberOfCells = numberOfCells;
    
    [self.listContent removeAllObjects];
    
    for (int i=0; i<numberOfCells; i++) {
        RCGridViewCell* cell = [self.dataSource gridView:self ViewForCellAtIndex:i];
        [self.listContent addObject:cell];
    }

    if ([self.dataSource respondsToSelector:@selector(ViewForAddButton:)]) {
        UIView *addButton = [self.dataSource ViewForAddButton:self];
        self.addButton = addButton;
    }
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    CGRect rect = CGRectMake(self.minEdgeInsets.left, self.minEdgeInsets.top, self.cellSize.width, self.cellSize.height);
    CGRect newRect = CGRectZero;
    
//    [UIView beginAnimations:nil context:nil];
    for (int i=0; i<self.listContent.count; i++) {
        RCGridViewCell* cell = (RCGridViewCell*)[self.listContent objectAtIndex:i];
        
        cell.frame = rect;
        cell.delegate = self;
        cell.editing = self.isEditing;
        cell.index = i;
        [self.scrollView addSubview:cell];
        
        newRect = CGRectOffset(rect, self.cellSize.width+self.horizonalCellGap, 0);
        if (CGRectGetMaxX(newRect)>(self.frame.size.width-self.minEdgeInsets.right)) {
            rect = CGRectMake(self.minEdgeInsets.left, rect.origin.y+self.cellSize.height+self.verticalCellGap, rect.size.width, rect.size.height);
        }else {
            rect = newRect;
        }
    }
    
    if (self.addButton) {
        self.addButton.frame = rect;
        if (self.isEditing) {
            self.addButton.hidden = YES;
        }
        [self.scrollView addSubview:self.addButton];
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(rect)+self.minEdgeInsets.bottom);
    }else{
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(newRect)+self.minEdgeInsets.bottom);
    }
    
//    [UIView commitAnimations];
}



-(void)queueReusableCell:(RCGridViewCell *)cell
{
    if (!cell) {
        return;
    }
    if (!self.resuePool) {
        self.resuePool = [NSMutableSet setWithCapacity:1];
    }
    [self.resuePool addObject:cell];
}

-(RCGridViewCell *)dequeueReusableCell
{
    RCGridViewCell* cell = [self.resuePool anyObject];
    if (cell) {
        [self.resuePool removeObject:cell];
    }
    return cell;
}


#pragma mark - RCGridViewCellDelegate
-(void)cellNeedToBeRemoved:(RCGridViewCell *)closeCell
{
    int i=0;
    for (RCGridViewCell* cell in self.scrollView.subviews) {
        if ([cell isKindOfClass:[RCGridViewCell class]]) {
            if (CGRectEqualToRect(cell.frame, closeCell.frame)) {
                [self.delegate  gridView:self CellWillBeRemovedAtIndex:i];
                break;
            }
            i++;
        }
    }
//    for (int i=0; i<[self.scrollView subviews].count; i++) {
//        RCGridViewCell *cell = [[self.scrollView subviews] objectAtIndex:i];
//        if ([cell isKindOfClass:[RCGridViewCell class]]) {
//            if (CGRectEqualToRect(cell.frame, closeCell.frame)) {
//                [self.delegate  gridView:self CellWillBeRemovedAtIndex:i];
//                break;
//            }
//        }
//
//    }
        [self reloadData];
//    [self.listContent removeObject:closeCell];
//    [UIView beginAnimations:nil context:nil];
//    [self layoutSubviews];
//    [UIView commitAnimations];

}


-(void)cellTappedWhenEditing:(RCGridViewCell *)cell
{
    self.editing = NO;
}

#pragma mark - GestureRecognizer
                                       
-(void)handleLongPressed:(UILongPressGestureRecognizer*)Gesture
{
    switch (Gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"long begain");
            CGPoint location = [Gesture locationInView:self.scrollView];
            NSInteger index = [self indexForCellAtPoint:location];
            if (index != RCGRIDVIEW_INVALID_INDEX && index!=RCGRIDVIEW_ADDBUTTON_INDEX) {
                self.movingCell = [self cellAtPoint:location];
                self.movingPosition = self.movingCell.center;
                if (!self.isEditing) {
                    self.editing = YES;
                }
                if ([self.delegate respondsToSelector:@selector(gridView:CellTappedAtIndex:)]) {
                    [self.delegate gridView:self CellWillBeMoved:self.movingCell];
                }
//                self.movingCell.layer.shadowOpacity = 0.3;
//                self.movingCell.layer.shadowOffset = CGSizeMake(0, 7);

            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
//            NSLog(@"long change");
        }
            break;
        case UIGestureRecognizerStateFailed:{
            NSLog(@"long fail");
        }
        case UIGestureRecognizerStateEnded:{
            [UIView beginAnimations:nil context:nil];
            self.movingCell.transform = CGAffineTransformIdentity;
            self.movingCell.center = self.movingPosition;
            [UIView commitAnimations];
            
            if ([self.delegate respondsToSelector:@selector(gridView:CellWillEndMoving:)]) {
                [self.delegate gridView:self CellWillEndMoving:self.movingCell];
            }
//            self.movingCell.layer.shadowOpacity = 0;
//            self.movingCell.layer.shadowOffset = CGSizeZero;

            self.movingCell = nil;
            self.movingPosition = CGPointZero;
        }
        default:
            break;
    }
    
}

-(void)handleTapped:(UITapGestureRecognizer*)Gesture
{
    if (Gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [Gesture locationInView:self.scrollView];
        NSInteger index = [self indexForCellAtPoint:location];
        if (index == RCGRIDVIEW_INVALID_INDEX) {
            if (self.disableEditWhenTapInvalid && self.isEditing) {
                self.editing = NO;
            }
        }else if (index == RCGRIDVIEW_ADDBUTTON_INDEX){
            if ([self.delegate respondsToSelector:@selector(addButtonTapped:)]) {
                [self.delegate addButtonTapped:self];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(gridView:CellTappedAtIndex:)]) {
                [self.delegate gridView:self CellTappedAtIndex:index];
            }
        }
    }
}
                                       

-(void)handlePan:(UIPanGestureRecognizer*)Gesture
{
    if (!self.isEditing ) {//|| self.pan != Gesture
        return;
    }
    if (Gesture.state == UIGestureRecognizerStateBegan) {
        RCGridViewCell *cell = [self cellAtPoint:[Gesture locationInView:self.scrollView]];
        if (cell) {
//            self.scrollView.scrollEnabled = NO;
//            if ([self.delegate respondsToSelector:@selector(gridView:CellTappedAtIndex:)]) {
//                [self.delegate gridView:self CellWillBeMoved:cell];
//            }
//            self.movingCell = cell;
//            self.movingPosition = cell.center;
            [self.scrollView bringSubviewToFront:cell];
            
        }else {
            self.movingCell = nil;
        }
    }
    if (Gesture.state == UIGestureRecognizerStateChanged) {
        if (self.movingCell) {
            CGPoint translation = [Gesture translationInView:self.scrollView];
            self.movingCell.transform = CGAffineTransformMakeTranslation(translation.x, translation.y);
            [self checkMovingCellPosition:self.movingCell];
        }
    }
    if (Gesture.state == UIGestureRecognizerStateEnded || Gesture.state == UIGestureRecognizerStateCancelled || Gesture.state == UIGestureRecognizerStateFailed) {
        [UIView beginAnimations:nil context:nil];
        self.movingCell.transform = CGAffineTransformIdentity;
        self.movingCell.center = self.movingPosition;
        [UIView commitAnimations];
//        self.scrollView.scrollEnabled = YES;
    }
}
                                       
                                       
                                       
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.tap) {
        if (self.isEditing && [self indexForCellAtPoint:[gestureRecognizer locationInView:self.scrollView]] != RCGRIDVIEW_INVALID_INDEX){
            return NO;
        }
    }
//    if (gestureRecognizer == self.pan) {//[gestureRecognizer isKindOfClass:[UIPanGestureRecognizer]]
//        NSLog(@"my pan");
//    }else {
//        NSLog(@"not my pan");
//    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark -private method

-(void)checkMovingCellPosition:(RCGridViewCell *)movingCell
{
    for (RCGridViewCell *cell in [self.scrollView subviews]) {
        if (![cell isKindOfClass:[RCGridViewCell class]] || [cell isEqual:movingCell] || cell == self.addButton) {
            continue;
        }
        if (CGRectContainsPoint(movingCell.frame, cell.center)) {
            CGPoint point = cell.center;
            [UIView beginAnimations:nil context:nil];
            cell.center = self.movingPosition;
            [UIView commitAnimations];
            self.movingPosition = point;
            [self.delegate gridView:self CellAtIndex:movingCell.index ExchangeWithCellAtIndex:cell.index];
            NSInteger index = cell.index;
            cell.index = movingCell.index;
            movingCell.index = index;
            return;
        }
    }
}

-(NSInteger)indexForCellAtPoint:(CGPoint)point
{
    for (RCGridViewCell *cell in [self.scrollView subviews]) {
        if (cell == self.addButton && CGRectContainsPoint(cell.frame, point)) {
            return self.isEditing?RCGRIDVIEW_INVALID_INDEX:RCGRIDVIEW_ADDBUTTON_INDEX;
        }
        if ([cell isKindOfClass:[RCGridViewCell class]]) {
            if (CGRectContainsPoint(cell.frame, point) || CGRectContainsPoint(cell.closeButton.frame, [cell convertPoint:point fromView:self.scrollView])) {//|| CGRectContainsPoint(, point)
                return cell.index;
            }
        }
//        NSLog(@"point : %@",NSStringFromCGPoint([cell convertPoint:point fromView:self.scrollView]));

    }
    return RCGRIDVIEW_INVALID_INDEX;
}

-(RCGridViewCell *)cellAtPoint:(CGPoint)point
{
    for (RCGridViewCell *cell in [self.scrollView subviews]) {
        if ([cell isKindOfClass:[RCGridViewCell class]]) {
            if (CGRectContainsPoint(cell.frame, point)) {
                return cell;
            }
        }
    }
    return nil;
}



@end
