//
//  RCSegment.h
//  browserHD
//
//  Created by imac on 12-9-7.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCSegmentDelegate;

@interface RCSegment : UIImageView
@property (nonatomic,assign) NSObject<RCSegmentDelegate> *delegate;
@property (nonatomic,strong) UIImage *firstImage;
@property (nonatomic,strong) UIImage *secondImage;

-(void) setSelectIndex:(NSInteger)index;
@end


@protocol RCSegmentDelegate <NSObject>

-(void)segment:(RCSegment*)segment selectionChange:(NSInteger)newIndex;

@end