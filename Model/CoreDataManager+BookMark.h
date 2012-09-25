//
//  CoreDataManager+BookMark.h
//  browserHD
//
//  Created by imac on 12-9-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "CoreDataManager.h"
#import "Folder+Create.h"
#import "Bookmark+Create.h"


@interface CoreDataManager (BookMark)

-(NSMutableArray*)sharedFolderList;
//-(NSMutableArray*)reloadSharedFolderList;

-(NSNumber*)generateValidFolderUnique;
-(Folder*)getFolderByUnique:(NSNumber*)unique;
-(NSArray*)getAllFolders;
-(Folder*)creatFolderWithTitle:(NSString*)title Unique:(NSNumber*)unique Parent:(Folder*)parent;


//-(Bookmark*)getBookmarkByUrl:(NSString*)url;
-(Bookmark*)createBookmarkWithTitle:(NSString*)title
                          Url:(NSString*)url
                         Folder:(Folder*)folder;
@end
