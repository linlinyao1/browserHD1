//
//  Folder.h
//  browserHD
//
//  Created by imac on 12-9-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmark, Folder;

@interface Folder : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) Folder *parent;
@property (nonatomic, retain) NSSet *child;
@end

@interface Folder (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmark *)value;
- (void)removeBookmarksObject:(Bookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;
- (void)addChildObject:(Folder *)value;
- (void)removeChildObject:(Folder *)value;
- (void)addChild:(NSSet *)values;
- (void)removeChild:(NSSet *)values;
@end
