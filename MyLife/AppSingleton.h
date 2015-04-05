//
//  AppSingleton.h
//  MyLife
//
//  Created by Guest User on 01/04/15.
//  Copyright (c) 2015 Guillaume & Zdeněk. All rights reserved.
//

#ifndef MyLife_AppSingleton_h
#define MyLife_AppSingleton_h

#import <Foundation/Foundation.h>
#import "DBHandler.h"

@interface AppSingleton : NSObject {
    NSMutableArray * postsList;
}

@property (nonatomic, retain) NSMutableArray *postsList;

+ (id)sharedAppSingleton;
- (void)updatePostList:(Post *)post;
- (void)updatePostList:(NSString*)title :(NSString*)text :(NSDate*)date :(NSString*)voiceoverPath :(NSMutableArray*)mediaPaths;
- (void)populatePostList;

@end

#endif