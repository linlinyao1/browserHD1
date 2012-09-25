//
//  Bookmark+Create.m
//  browserHD
//
//  Created by imac on 12-9-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "Bookmark+Create.h"

@implementation Bookmark (Create)

+(Bookmark *)bookmarkWithTitle:(NSString *)title
                           Url:(NSString *)url
                      IconPath:(NSString *)iconPath
                        Unique:(NSNumber *)unique
                        Folder:(Folder *)folder
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Bookmark *bookmark = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bookmark"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        bookmark = [NSEntityDescription insertNewObjectForEntityForName:@"Bookmark" inManagedObjectContext:context];
        bookmark.title = title;
        bookmark.url = url;
        bookmark.folder = folder;
    } else {
        bookmark = [matches lastObject];
    }
    
    return bookmark;
}
@end
