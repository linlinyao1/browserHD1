//
//  RCSegment.m
//  browserHD
//
//  Created by imac on 12-9-7.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCSegment.h"

@interface RCSegment ()<UIGestureRecognizerDelegate>
@end

@implementation RCSegment
@synthesize delegate = _delegate;
@synthesize firstImage = _firstImage;
@synthesize secondImage = _secondImage;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)awakeFromNib
{
    [self commonInit];
}

-(void)commonInit{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [self addGestureRecognizer:tap];
    
    self.firstImage = [UIImage imageNamed:@"segment_fav"];
    self.secondImage = [UIImage imageNamed:@"segment_nav"];
    
//    [self setSelectIndex:0];
}

-(void)tapGestureHandler:(UITapGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self];
    NSInteger index = 0;
    if (location.x<=self.bounds.size.width/2) {
        index = 0;
    }else{
        index = 1;
    }
    
    [self setSelectIndex:index];
    [self.delegate segment:self selectionChange:index];
}

-(void)setSelectIndex:(NSInteger)index
{
    if (index == 0) {
        self.image = self.firstImage;
    }else if (index == 1){
        self.image = self.secondImage;
    }
    

}


@end
