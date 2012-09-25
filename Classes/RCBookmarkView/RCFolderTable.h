//
//  RCFolderTable.h
//  browserHD
//
//  Created by imac on 12-9-13.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCTreeTable.h"
#import "CoreDataManager+BookMark.h"

@protocol RCFolderTableDelegate;

@interface RCFolderTable : RCTreeTable
@property (nonatomic,assign) NSObject<RCFolderTableDelegate> *delegate;
@property (nonatomic,strong) Folder* rootFolder;
@property (nonatomic,assign) BOOL isPopup;
@end

@protocol RCFolderTableDelegate <NSObject>

-(void)FolderTable:(RCFolderTable*)table folderSelected:(Folder*)folder isEditing:(BOOL)editing;
-(void)FolderTable:(RCFolderTable*)table folderDeleted:(Folder*)folder;
//-(void)FolderTable:(RCFolderTable*)table filesOfFolder:(NSArray*)files inSelectIndexPath:(NSIndexPath*)indexPath;
//
//-(void)FolderTable:(RCFolderTable*)table folderSelected:(NSDictionary*)folder parentFolder:(NSDictionary*)parent isEditing:(BOOL)editing;

@end