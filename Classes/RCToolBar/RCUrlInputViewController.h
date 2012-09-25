//
//  RCUrlInputViewController.h
//  browserHD
//
//  Created by imac on 12-8-13.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCUrlInputViewControllerDelegate <NSObject>
-(void)urlSuggestionSelected:(NSURL*)url;
@end


@interface RCUrlInputViewController : UITableViewController
@property (nonatomic,unsafe_unretained) NSObject<RCUrlInputViewControllerDelegate> *delegate;

-(void)loadURLSuggestionWithText:(NSString*)text;
@end
