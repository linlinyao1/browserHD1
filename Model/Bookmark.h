//
//  Bookmark.h
//  browserHD
//
//  Created by imac on 12-9-17.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Folder;

@interface Bookmark : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) Folder *folder;

@end
