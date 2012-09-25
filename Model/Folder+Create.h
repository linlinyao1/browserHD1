//
//  Folder+Create.h
//  browserHD
//
//  Created by imac on 12-9-14.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "Folder.h"

@interface Folder (Create)
+(Folder*) folderWithTitle:(NSString*)title Unique:(NSNumber*)unique Parent:(Folder*)parent inManagedObjectContext:(NSManagedObjectContext *)context;

@end
