//
//  RCHistoryView.h
//  browserHD
//
//  Created by imac on 12-9-18.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCHistoryViewDelegate <NSObject>

-(void)historyURLSelected:(NSURL*)url;

@end

@interface RCHistoryView : UIView
@property (nonatomic,assign) NSObject<RCHistoryViewDelegate>* delegate;

-(void)clearHistory;
@end
