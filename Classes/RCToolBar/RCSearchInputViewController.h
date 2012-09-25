//
//  RCSearchInputViewController.h
//  browserHD
//
//  Created by imac on 12-8-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCSearchInputViewControllerDelegate <NSObject>

-(void)loadSearchResult:(NSURL*)url keyWord:(NSString*)key;
@end

@interface RCSearchInputViewController : UITableViewController
@property (nonatomic,assign) NSObject<RCSearchInputViewControllerDelegate> *searchDelegate;

-(void)loadSearchSuggestionWithText:(NSString*)text;
@end
