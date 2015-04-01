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

#pragma mark Singleton Methods

+ (id)sharedAppSingleton {
    static AppSingleton *sharedAppSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppSingleton = [[self alloc] init];
    });
    return sharedAppSingleton;
}

- (id)init {
    if (self = [super init]) {
        postsList = [NSMutableArray init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end