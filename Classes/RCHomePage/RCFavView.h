//
//  RCFavView.h
//  browserHD
//
//  Created by imac on 12-8-30.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
#define title_hight 15
#define title_gap 11

@interface RCFavView : UIView
@property (nonatomic,strong) UIImageView* screenShot;
@property (nonatomic,strong) UILabel* titleLabel;
@property (nonatomic,assign,getter = isEditing) BOOL editing;
@property (nonatomic,strong) UIButton *closeButton;

@end
