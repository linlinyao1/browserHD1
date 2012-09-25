//
//  RCFolderButton.m
//  browserHD
//
//  Created by imac on 12-9-12.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexValue.h"

@interface RCFolderButton ()
@end

@implementation RCFolderButton
@synthesize button = _button;
//@synthesize titleLabel = _titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor whiteColor];

        UIImageView *folderImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark_folderEdit_folder"]];
        folderImg.frame = CGRectMake(0, (self.bounds.size.height-32)/2, 32, 32);
        [self addSubview:folderImg];
        
        UIImageView *folderAccessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark_folderEdit_accessory"]];
        folderAccessory.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
        folderAccessory.frame = CGRectMake(self.bounds.size.width-24, (self.bounds.size.height-24)/2, 24, 24);
        [self addSubview:folderAccessory];

        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.autoresizingMask = RCViewAutoresizingALL;
        self.button.frame = self.bounds;
        [self.button setTitle:@"我的收藏夹" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.button.titleEdgeInsets = UIEdgeInsetsMake(0, folderImg.bounds.size.width, 0, folderAccessory.bounds.size.width);
        [self addSubview:self.button];
        self.button.layer.borderColor = [UIColor colorWithHexValue:@"6b6b6b"].CGColor;
        self.button.layer.borderWidth = 1;
        
    }
    return self;
}



@end
