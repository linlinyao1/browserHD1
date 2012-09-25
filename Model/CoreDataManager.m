//
//  CoreDataManager.m
//  TapRepublic
//
//  Created by Joy Cheng on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager
@synthesize managedObjectContext=_managedObjectContext;//session  
@synthesize managedObjectModel=_managedObjectModel;  
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;  
static CoreDataManager* __sharedCcoreDataManager;


+(CoreDataManager *)defaultManager
{
    if (__sharedCcoreDataManager) {
        return __sharedCcoreDataManager;
    }
    __sharedCcoreDataManager = [[CoreDataManager alloc] init];
    
    return __sharedCcoreDataManager;
}



//相当与持久化方法  
- (void)saveContext  
{  
    NSError *error = nil;  
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;  
    if (managedObjectContext != nil)  
    {  
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {  
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);  
            abort();  
        }   
    }  
}  

/** 
 Returns the managed object context for the application. 
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application. 
 */  
//初始化context对象  
- (NSManagedObjectContext *)managedObjectContext  
{  
    if (_managedObjectContext != nil)  
    {  
        return _managedObjectContext;  
    }  
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];  
    if (coordinator != nil)  
    {  
        _managedObjectContext = [[NSManagedObjectContext alloc] init];  
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];  
    }  
    return _managedObjectContext;  
}  

/** 
 Returns the managed object model for the application. 
 If the model doesn't already exist, it is created from the application's model. 
 */  
- (NSManagedObjectModel *)managedObjectModel  
{  
    if (_managedObjectModel != nil)  
    {  
        return _managedObjectModel;
    }  
    //这里的URLForResource:@"lich" 的url名字（lich）要和你建立datamodel时候取的名字是一样的，至于怎么建datamodel很多教程讲的很清楚  
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BookMark" withExtension:@"momd"];  
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;  
}  

/** 
 Returns the persistent store coordinator for the application. 
 If the coordinator doesn't already exist, it is created and the application's store added to it. 
 */  
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator  
{  
    if (_persistentStoreCoordinator != nil)  
    {  
        return _persistentStoreCoordinator;  
    }  
    
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"BookMark.sqlite"];  
    //    NSLog(@"storeURL == %@",storeURL);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:storePath]) {
//		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"sqlite"];
//		if (defaultStorePath) {
//			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
//		}
	}
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    NSError *error = nil;  
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];  
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])  
    {  
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);  
        abort();  
    }      
    
    return _persistentStoreCoordinator;  
}  

/** 
 Returns the URL to the application's Documents directory. 
 */  
- (NSString *)applicationDocumentsDirectory  
{  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
    //    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];  
}  




@end
