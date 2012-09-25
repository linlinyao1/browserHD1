//
//  CoreDataManager+BookMark.m
//  browserHD
//
//  Created by imac on 12-9-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "CoreDataManager+BookMark.h"


@implementation CoreDataManager (BookMark)


-(NSArray*)performFetchWithEntityName:(NSString*)entityName Unique:(NSNumber*)unique
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];

    NSError *error = nil;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
        return nil;
    } else if ([matches count] == 0) {
        return nil;
    } else {
        return matches;
    }
}

-(Folder *)getFolderByUnique:(NSNumber *)unique
{
    NSArray *matches = [self performFetchWithEntityName:@"Folder" Unique:unique];
    Folder *folder = nil;
    if (matches) {
        folder = [matches lastObject];
    }

    return folder;
}

-(NSArray *)getAllFolders
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Folder"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES selector:@selector(compare:)]];
    
    NSError *error = nil;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return matches;
}

-(Folder*)creatFolderWithTitle:(NSString*)title Unique:(NSNumber*)unique Parent:(Folder *)parent
{
    Folder* folder = [self getFolderByUnique:unique];
    if (folder) {
        return nil;
    }else{
        folder = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:self.managedObjectContext];
        folder.unique = unique;
        folder.title = title;
        folder.parent = parent;
        folder.createDate = [NSDate date];
        if (parent) {
            folder.level = [NSNumber numberWithInt:parent.level.intValue+1];
            [folder.parent addChildObject:folder];
        }else{
            folder.level = [NSNumber numberWithInt:0];
        }
        [self saveContext];
    }
    return folder;
}

-(NSNumber *)generateValidFolderUnique
{
    
    int i = arc4random() % 1000;
    if ([[CoreDataManager defaultManager] getFolderByUnique:[NSNumber numberWithInt:i]]) {
        return [self generateValidFolderUnique];
    }else{
        return [NSNumber numberWithInt:i];
    }
}

//static NSMutableArray* _sharedFolderList = nil;

-(NSMutableArray *)sharedFolderList
{
//    if (!_sharedFolderList) {
        NSMutableArray* sharedFolderList = [NSMutableArray array];
        Folder* root = [self getFolderByUnique:[NSNumber numberWithInt:0]];
        sharedFolderList = [self getAllChildrenWithParent:root];
//    }
    
    return sharedFolderList;
}

//-(NSMutableArray *)reloadSharedFolderList
//{
//    _sharedFolderList = nil;
//    return [self sharedFolderList];
//}

-(NSMutableArray*)getAllChildrenWithParent:(Folder*)parent
{
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:parent];
    NSArray* children = [self sortedChildWithParent:parent];
    if (children) {
        for (Folder* folder in children) {
            NSMutableArray* child = [self getAllChildrenWithParent:folder];
            if (child) {
                [array addObjectsFromArray:child];
            }
        }
    }
    return array;
}
-(NSArray*)sortedChildWithParent:(Folder*)parent
{
    NSArray* array = nil;
    if (parent.child) {
        array = [[parent.child allObjects] sortedArrayUsingComparator:^NSComparisonResult(Folder* obj1, Folder* obj2) {
            return [obj1.createDate compare:obj2.createDate];
        }];
    }
    return array;
}




//-(Bookmark *)getBookmarkByUrl:(NSString *)url
//{
//    NSArray* matches = [self performFetchWithEntityName:@"Bookmark" Unique:unique];
//    Bookmark* bookmark = nil;
//    if (matches) {
//        bookmark = [matches lastObject];
//    }
//    return bookmark;
//}

-(Bookmark *)createBookmarkWithTitle:(NSString *)title Url:(NSString *)url Folder:(Folder *)folder
{
    Bookmark * bookmark = [NSEntityDescription insertNewObjectForEntityForName:@"Bookmark" inManagedObjectContext:self.managedObjectContext];
    bookmark.title = title;
    bookmark.url = url;
    bookmark.folder = folder;
    bookmark.createDate = [NSDate date];
    [folder addBookmarksObject:bookmark];
    [self saveContext];
    return bookmark;
}


@end
