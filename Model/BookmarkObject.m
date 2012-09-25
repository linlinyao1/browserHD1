//
//  BookmarkObject.m
//  CIALBrowser
//
//  Created by Sylver Bruneau on 01/09/10.
//  Copyright 2011 CodeIsALie. All rights reserved.
//

#import "BookmarkObject.h"

@interface BookmarkObject ()
@end

@implementation BookmarkObject

@synthesize name = _name;
@synthesize url = _url;
@synthesize date = _date;
@synthesize count = _count;

- (id) initWithName:(NSString *)aName andURL:(NSURL *)aUrl {
    if (self = [super init]) {
        self.name = aName;
        self.url = aUrl;
        self.date = [NSDate date];
        self.count = [NSNumber numberWithInt:1];
    }
    return self;
}

- (id) initWithCoder: (NSCoder *)coder {
      self = [self init];
    if (self != nil)
    {
        self.name = [coder decodeObjectForKey: @"name"];
        self.url = [coder decodeObjectForKey: @"url"];
        self.date = [coder decodeObjectForKey:@"date"];
        self.count = [coder decodeObjectForKey:@"count"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_url forKey:@"url"];
    [coder encodeObject:_date forKey:@"date"];
    [coder encodeObject:_count forKey:@"count"];

}

@end