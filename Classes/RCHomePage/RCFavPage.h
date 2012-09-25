//
//  RCFavPage.h
//  browserHD
//
//  Created by imac on 12-8-16.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCFavPageDelegate <NSObject>
    
-(void)favariteWebsiteSelected:(NSURL*)url;

@end

@interface RCFavPage : UIView
@property (nonatomic,assign) NSObject<RCFavPageDelegate>* delegate;
@property (nonatomic,assign,getter = isEditing) BOOL editing;

-(void)reloadData;

@end
