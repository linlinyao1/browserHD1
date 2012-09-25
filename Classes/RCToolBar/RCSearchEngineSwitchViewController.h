//
//  RCSearchEngineSwitchViewController.h
//  browserHD
//
//  Created by imac on 12-8-20.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>
enum  {
    SETypeBaidu = 0,
    SETypeGoogle = 1,
    SETypeSoso = 2,
    SETypeSougou = 3,
    SETypeTaobao = 4,
    
    SETypeCount = 5
};
typedef NSInteger SETypes;

@protocol RCSearchEngineSwitchViewControllerDelegate <NSObject>

-(void)updateSearchEngine;

@end


@interface RCSearchEngineSwitchViewController : UITableViewController

@property (nonatomic,assign) NSObject<RCSearchEngineSwitchViewControllerDelegate> *engineDelegate;

+(NSString*)nameForSEtype:(SETypes)type;
+(UIImage*)imageForSEtype:(SETypes)type isFull:(BOOL)full;
+(NSURL*)searchUrlForSEtype:(SETypes)type keyWord:(NSString*)key;

@end
