//
//  Bookmark+Create.h
//  browserHD
//
//  Created by imac on 12-9-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "Bookmark.h"

@interface Bookmark (Create)

+(Bookmark*)bookmarkWithTitle:(NSString*)title
                          Url:(NSString*)url
                     IconPath:(NSString*)iconPath
                       Unique:(NSNumber*)unique
                       Folder:(Folder*)folder
       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
