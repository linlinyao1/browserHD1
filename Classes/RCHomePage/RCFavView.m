//
//  RCFavView.m
//  browserHD
//
//  Created by imac on 12-8-30.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFavView.h"
#import "QuartzCore/QuartzCore.h"
#import "UIColor+HexValue.h"

@interface RCFavView ()
@end

@implementation RCFavView
@synthesize screenShot = _screenShot;
@synthesize titleLabel = _titleLabel;
@synthesize editing = _editing;
@synthesize closeButton = _closeButton;



-(void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        
        self.closeButton.hidden = !_editing;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = RCViewAutoresizingALL;
        // Initialization code        
        
        self.screenShot = [[UIImageView alloc] init];
//        self.screenShot.autoresizingMask = RCViewAutoresizingALL;
        self.screenShot.contentMode = UIViewContentModeScaleAspectFill;
//        self.screenShot.layer.cornerRadius = 8;
        self.screenShot.layer.masksToBounds = YES;
        self.screenShot.layer.borderWidth = 1;
        self.screenShot.layer.borderColor = [UIColor colorWithHexValue:@"#C9C9C9"].CGColor;
//        self.screenShot.clipsToBounds = YES;
        [self addSubview:self.screenShot];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.autoresizingMask = RCViewAutoresizingInternal|UIViewAutoresizingFlexibleTopMargin;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.textColor = [UIColor colorWithHexValue:@"323232"];
        [self addSubview:self.titleLabel];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(-13, -13, 40, 40);
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"close_x"] forState:UIControlStateNormal];
//        self.closeButton.center = ;
        self.closeButton.hidden = YES;
        [self addSubview: self.closeButton];
    }
    return self;
}

-(void)layoutSubviews
{
    self.screenShot.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-title_hight-title_gap);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.screenShot.frame)+title_gap, self.bounds.size.width, title_hight);
}


@end
