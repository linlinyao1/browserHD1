//
//  Folder+Create.m
//  browserHD
//
//  Created by imac on 12-9-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "Folder+Create.h"

@implementation Folder (Create)

+(Folder *)folderWithTitle:(NSString *)title Unique:(NSNumber *)unique Parent:(Folder *)parent inManagedObjectContext:(NSManagedObjectContext *)context
{
    Folder* folder = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Folder"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        folder = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
        folder.unique = unique;
        folder.title = title;
        folder.parent = parent;
    } else {
        folder = [matches lastObject];
    }
    
    return folder;
}


@end

