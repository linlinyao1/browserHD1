//
//  RCGridView.h
//  RCWebBrowser
//
//  Created by imac on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCGridViewCell.h"


@protocol RCGridViewDataSource;
@protocol RCGridViewDelegate;

///////////////////RCGridView///////////////////////////////
@interface RCGridView : UIView
@property (nonatomic) CGSize cellSize; //default is 64*64
@property (nonatomic) NSInteger verticalCellGap; //default is 10
@property (nonatomic) NSInteger horizonalCellGap; //default is 10
@property (nonatomic) UIEdgeInsets minEdgeInsets; //default is (5,5,5,5)
@property (nonatomic) BOOL disableEditWhenTapInvalid;
@property (nonatomic,getter = isEditing) BOOL editing;

@property (nonatomic,assign) NSObject<RCGridViewDataSource> *dataSource;
@property (nonatomic,assign) NSObject<RCGridViewDelegate> *delegate;
 
@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,strong) RCGridViewCell *movingCell;

-(void)reloadData;
-(RCGridViewCell*)dequeueReusableCell;

@end



///////////////////RCGridViewDataSource///////////////////////////////
@protocol RCGridViewDataSource <NSObject>

-(NSInteger)numberOfCellsInGridView:(RCGridView*)gridView;
-(RCGridViewCell*)gridView:(RCGridView*)gridView ViewForCellAtIndex:(NSInteger)index;
@optional
-(UIView*)ViewForAddButton:(RCGridView*)gridView ;
@end


@protocol RCGridViewDelegate <NSObject>

-(void)gridView:(RCGridView*)gridView CellWillBeRemovedAtIndex:(NSInteger)index;
-(void)gridView:(RCGridView*)gridView CellAtIndex:(NSInteger)index1 ExchangeWithCellAtIndex:(NSInteger)index2;

@optional
-(void)gridView:(RCGridView*)gridView CellTappedAtIndex:(NSInteger)index;
-(void)gridView:(RCGridView*)gridView CellWillBeMoved:(RCGridViewCell*)cell;
-(void)gridView:(RCGridView*)gridView CellWillEndMoving:(RCGridViewCell *)cell;

-(void)addButtonTapped:(RCGridView*)gridView;
-(void)gridViewStartEditing:(RCGridView*)gridView;
-(void)gridViewEndEditing:(RCGridView*)gridView;
@end