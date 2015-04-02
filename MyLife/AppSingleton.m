//
//  AppSingleton.m
//  MyLife
//
//  Created by Guest User on 01/04/15.
//  Copyright (c) 2015 Guillaume & Zdeněk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppSingleton.h"

@implementation AppSingleton

@synthesize postsList;
@synthesize dbHandler;

#pragma mark Singleton Methods

+ (id)sharedAppSingleton {
    static AppSingleton *sharedAppSingleton = nil;
    static dispatch_once_t onceToken;
    NSLog(@"Singleton created");
    dispatch_once(&onceToken, ^{
        sharedAppSingleton = [[self alloc] init];
    });
    return sharedAppSingleton;
}

- (id)init {
    if (self = [super init]) {
        postsList = [NSMutableArray array];
        dbHandler = [DBHandler getSharedInstance];
        NSLog(@"Singleton init");
    }
    return self;
}

- (void)updatePostList:(Post *)post{
    [postsList addObject:post];
    [dbHandler saveData:post];
}

- (void)populatePostList{
    NSLog(@"populate post list");
    [postsList addObjectsFromArray:[dbHandler retrievePosts]];
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end