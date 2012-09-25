//
//  RCRecordData.h
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookmarkObject.h"

#define MAX_FAV_COUNT 9


#define RCRD_FAV @"favorite"
#define RCRD_HISTORY @"history"
#define RCRD_BOOKMARK @"bookmark"
#define RCRD_QUICKLINK @"quicklink"


#define QuickLink_Title @"title"
#define QuickLink_Content @"content"
#define URL_Title @"urltitle"
#define URL_Link @"urllink"
#define URL_Icon @"urlico"
#define URL_Intro @"intro"
#define URL_Isdesktop @"isdesktop"

#define BookMark_Title @"title"
#define BookMark_URL @"Url"
#define BookMark_Level @"level"
#define BookMark_Content @"content"


@interface RCRecordData : NSObject

+(void)prepareDefaultData;

+(NSMutableArray*)recordDataWithKey:(NSString*)key;
+(void)updateRecord:(NSArray*)record ForKey:(NSString*)key; // pass record nil to delete file

+(void)saveImageForWeb:(UIWebView*)Web;
+(UIImage*)getImageForURL:(NSURL*)url;

+(void)clearImageCaches;
//+(void)updateFavoriteWithHistory;



@end



@interface QuickLinkDataBase : NSObject
+(NSArray*)sharedQuickLinkDB;
+(NSDictionary*)quicklinkForUrl:(NSURL*)url;
@end

@interface CommonLinkDataBase : NSObject
+(NSArray*)sharedCommonLinkDB;
+(UIImage*)imageForCommonLink:(NSURL*)url;
@end