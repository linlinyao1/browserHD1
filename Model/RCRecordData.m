//
//  RCRecordData.m
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCRecordData.h"
#import "UIView+ScreenShot.h"
#import "EGOCache.h"
#import "JSONKit.h"

@interface RCRecordData ()
+(NSMutableArray*)defaultDataForKey:(NSString*)key;
@end

@implementation RCRecordData


static inline NSString* cachePathForKey(NSString* key) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    return path;
}

+(void)prepareDefaultData
{
    NSString *path = cachePathForKey(RCRD_QUICKLINK);
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        NSMutableArray* quicklinks = [self defaultDataForKey:RCRD_QUICKLINK];
        [self updateRecord:quicklinks ForKey:RCRD_QUICKLINK];
    }
    
    path = cachePathForKey(RCRD_FAV);
    data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        NSMutableArray* commonlinks = [self defaultDataForKey:RCRD_FAV];
        [self updateRecord:commonlinks ForKey:RCRD_FAV];
    }

    path = cachePathForKey(RCRD_HISTORY);
    data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        NSMutableArray* historys = [self defaultDataForKey:RCRD_HISTORY];
        [self updateRecord:historys ForKey:RCRD_HISTORY];
    }
}

+(NSMutableArray *)defaultDataForKey:(NSString *)key
{
    NSMutableArray* result = [NSMutableArray array];
    
    if ([key isEqualToString:RCRD_QUICKLINK]) {
        NSArray* quicklinkDB = [QuickLinkDataBase sharedQuickLinkDB];
        for (NSDictionary* dic in quicklinkDB) {
            NSArray* array = [dic objectForKey:QuickLink_Content];
            for (NSDictionary* quicklink in array) {
                NSString* isdesktop = [quicklink objectForKey:URL_Isdesktop];
                if (isdesktop.boolValue) {
                    NSString *url = [quicklink objectForKey:URL_Link];
                    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [result addObject:[[BookmarkObject alloc] initWithName:[quicklink objectForKey:URL_Title] andURL:[NSURL URLWithString:url]]];
                }
            }
        }        
    }else if ([key isEqualToString:RCRD_FAV]){
        NSArray* commonLinkDB = [CommonLinkDataBase sharedCommonLinkDB];
        for (NSDictionary* commonlink in commonLinkDB) {
            NSString* isdesktop = [commonlink objectForKey:URL_Isdesktop];
            if (isdesktop.boolValue) {
                NSString *url = [commonlink objectForKey:URL_Link];
                url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [result addObject:[[BookmarkObject alloc] initWithName:[commonlink objectForKey:URL_Title] andURL:[NSURL URLWithString:url]]];
            }
        }
    }else if([key isEqualToString:RCRD_BOOKMARK]){
        NSMutableDictionary* root = [NSMutableDictionary dictionary];
        [root setObject:@"我的收藏夹" forKey:BookMark_Title];
        [root setObject:[NSNumber numberWithInt:0] forKey:BookMark_Level];
        [result addObject:root];
    }else if([key isEqualToString:RCRD_HISTORY]){
        result = [self defaultDataForKey:RCRD_FAV];
    }
    
    return result;
}

+(NSMutableArray *)recordDataWithKey:(NSString *)key
{
    NSMutableArray* result = nil;
    NSString *path = cachePathForKey(key);
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (data) {
        result = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }else {
        result = [self defaultDataForKey:key];
    }
    return result;
}

+(void)updateRecord:(NSArray*)record ForKey:(NSString *)key
{
    if (record) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:record];
        [[NSFileManager defaultManager]createFileAtPath:cachePathForKey(key) contents:data attributes:nil];
    }else{
        [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(key) error:nil];
    }
}



inline static NSString* screenShotKeyForURL(NSURL* url) {
    return [NSString stringWithFormat:@"ScreenShot-%u", [[url description] hash]];
}

+(void)saveImageForWeb:(UIWebView *)Web
{    
    if (Web.request.URL.absoluteString.length) {
        NSString* key = screenShotKeyForURL(Web.request.URL);
//        if (![[EGOCache currentCache] hasCacheForKey:key]) {
            UIImage *screenShot = [Web screenShotImage];
            if (screenShot) {
                [[EGOCache currentCache] setImage:screenShot forKey:key withTimeoutInterval:NSTimeIntervalSince1970];
            }
//        };
        
    }
    
}

+(UIImage *)getImageForURL:(NSURL *)url
{
    UIImage *image = nil;
    
    image = [CommonLinkDataBase imageForCommonLink:url];
    if (!image && [url.absoluteString hasSuffix:@"/"]) {
        image = [CommonLinkDataBase imageForCommonLink:[NSURL URLWithString:[url.absoluteString substringToIndex:url.absoluteString.length-1]]];
    }
    if (!image) {
        image = [[EGOCache currentCache] imageForKey:screenShotKeyForURL(url)];
    }
    return image;
}

+(void)clearImageCaches
{
    @autoreleasepool {
        NSMutableArray* historyArray = [self recordDataWithKey:RCRD_HISTORY];
        [historyArray sortUsingComparator:^NSComparisonResult(BookmarkObject *obj1, BookmarkObject *obj2) {
            return [obj2.count compare:obj1.count];
        }];
        for (int i =9; i<historyArray.count; i++) {
            BookmarkObject* historyObj = [historyArray objectAtIndex:i];
            [[EGOCache currentCache] removeCacheForKey:historyObj.url.absoluteString];
        }
    }
}

@end


static NSArray* staticQuickLinkArray = nil;

@implementation QuickLinkDataBase

+(void)addLevelToDB
{
    NSArray* db = [self sharedQuickLinkDB];
    for (id obj in db) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
        }else if ([obj isKindOfClass:[NSArray class]]){
            
        }
    }
}

+(NSArray *)sharedQuickLinkDB
{
    if (!staticQuickLinkArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"quickLink" ofType:@"json"];
        NSArray *quickLinkArray = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] objectFromJSONString];
        if (quickLinkArray) {
            staticQuickLinkArray = [NSArray arrayWithArray:quickLinkArray];
        }
    }
    return staticQuickLinkArray;
}

+(NSDictionary *)quicklinkForUrl:(NSURL *)url
{
    NSArray* db = [self sharedQuickLinkDB];
    for (NSDictionary* dic in db) {
        NSArray* array = [dic objectForKey:QuickLink_Content];
        for (NSDictionary* quicklink in array) {
            NSString *string = [quicklink objectForKey:URL_Link];
            string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([string isEqualToString:url.absoluteString]) {
                return quicklink;
            }
        }
    }
    
    return nil;
}

@end

static NSArray* staticCommonLinkArray = nil;
@implementation CommonLinkDataBase

+(NSArray *)sharedCommonLinkDB
{
    if (!staticCommonLinkArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"commonLink" ofType:@"json"];
        NSArray *commonLinkArray = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] objectFromJSONString];
        if (commonLinkArray) {
            staticCommonLinkArray = [NSArray arrayWithArray:commonLinkArray];
        }
    }
    return staticCommonLinkArray;
}

+(UIImage *)imageForCommonLink:(NSURL *)url
{
    NSArray *db = [self sharedCommonLinkDB];
    for (NSDictionary* commonlink in db) {
        NSString *string = [commonlink objectForKey:URL_Link];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([string isEqualToString:url.absoluteString]) {
            return [UIImage imageNamed:[commonlink objectForKey:URL_Icon]];
        }
    }
    
    return nil;
}

@end



