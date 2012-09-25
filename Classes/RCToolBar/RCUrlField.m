//
//  RCUrlField.m
//  browserHD
//
//  Created by imac on 12-8-24.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCUrlField.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexValue.h"


@interface RCUrlField ()
@property (nonatomic,strong) CALayer *innerShadow;
@end

@implementation RCUrlField
@synthesize loadingProgress = _loadingProgress;;
@synthesize progressImage = _progressImage;
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
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexValue:@"9f9fa6"].CGColor;
    
    CALayer *innerShadow =  [CALayer layer];
    innerShadow.contents = (id)[UIImage imageNamed: @"innerShadow"].CGImage;
    //    innerShadow.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    [self.layer addSublayer:innerShadow];
    self.innerShadow = innerShadow;
    
}
- (void)setLoadingProgress:(NSNumber*)loadingProgress {
    if (loadingProgress.floatValue < 0.0f) {
        _loadingProgress = [NSNumber numberWithFloat:0];
        return;
    }
    if (loadingProgress.floatValue > 1.0f) {
        _loadingProgress = [NSNumber numberWithFloat:1];
        return;
    }
    
    _loadingProgress = loadingProgress;
    
    CGRect progressRect = CGRectZero;
    CGSize progressSize = CGSizeMake(_loadingProgress.floatValue * CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    progressRect.size = progressSize;
    
    // Create the background image
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, self.bounds);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithPatternImage:self.progressImage].CGColor);//[UIImage imageNamed:@"urlField_PB_Portrait"]
    CGContextFillRect(context, progressRect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [super setBackground:image];
}

- (void)setBackground:(UIImage *)background {
    // NO-OP
}

- (UIImage *)background {
    return nil;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.size.width-self.rightView.bounds.size.width-5, 0, self.rightView.bounds.size.width, self.rightView.bounds.size.height);
}
-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(10, 0, CGRectGetMinX(self.rightView.frame)-10, bounds.size.height);
//    return CGRectInset( bounds , 20 , 0 );
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.innerShadow.frame = CGRectMake(0, 0, self.bounds.size.width, 13);
}


@end
