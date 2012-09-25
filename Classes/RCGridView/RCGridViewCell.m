//
//  RCGridViewCell.m
//  RCWebBrowser
//
//  Created by imac on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCGridViewCell.h"
#import "QuartzCore/QuartzCore.h"

@interface RCGridViewCell ()
@end


@implementation RCGridViewCell
@synthesize contentView = _contentView;
@synthesize backgroundView = _backgroundView;
@synthesize closeButton = _closeButton;
@synthesize editing = _editing;
@synthesize delegate = _delegate;
@synthesize index = _index;
@synthesize disableCloseButton = _disableCloseButton;

-(void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        if (!self.disableCloseButton) {
            self.closeButton.hidden = !_editing;
            
            if (_editing) {
                self.layer.shadowOpacity = 0.3;
                self.layer.shadowOffset = CGSizeMake(0, 1);
            }else{
                self.layer.shadowOpacity = 0;
                self.layer.shadowOffset = CGSizeZero;
            }
            
        }
    }
}

-(void)setIndex:(NSInteger)index
{
    if (_index != index) {
        _index = index;
//        self.title.text = [NSString stringWithFormat:@"%d",index];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
        
        self.contentView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(0, 0, 40, 40);
        self.closeButton.center = CGPointMake(5, 5);
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"close_x"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        self.closeButton.hidden = YES;
        
    }
    return self;
}



-(void)closeButtonPressed:(UIButton*)sender
{
    [self.delegate cellNeedToBeRemoved:self];
}

-(void)contentButtonPressed:(UIButton*)sender
{
    [self.delegate cellTappedWhenEditing:self];
}




@end
