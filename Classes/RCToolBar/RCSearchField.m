//
//  RCSearchField.m
//  browserHD
//
//  Created by imac on 12-8-28.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCSearchField.h"
#import "QuartzCore/QuartzCore.h"
#import "UIColor+HexValue.h"

@interface RCSearchField ()
@property (nonatomic,strong) CALayer *innerShadow;
@end

@implementation RCSearchField
@synthesize innerShadow = _innerShadow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexValue:@"9f9fa6"].CGColor;
    CALayer *innerShadow =  [CALayer layer];
    innerShadow.contents = (id)[UIImage imageNamed: @"innerShadow"].CGImage;
    [self.layer addSublayer:innerShadow];
    self.innerShadow = innerShadow;
}

//-(CGRect)leftViewRectForBounds:(CGRect)bounds
//{
//    return CGRectOffset(self.leftView.bounds, 2, 1);
//}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(self.leftView.bounds.size.width-5, 0, bounds.size.width-self.leftView.bounds.size.width-10, bounds.size.height);
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

-(void)layoutSubviews
{
    self.innerShadow.frame = CGRectMake(0, 0, self.bounds.size.width, 12);

    [super layoutSubviews];
}
@end
