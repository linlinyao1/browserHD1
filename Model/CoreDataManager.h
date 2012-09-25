//
//  CoreDataManager.h
//  TapRepublic
//
//  Created by Joy Cheng on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"

@interface CoreDataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;  
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;  
+(CoreDataManager*)defaultManager;
- (void)saveContext;  
- (NSString *)applicationDocumentsDirectory; 

@end

