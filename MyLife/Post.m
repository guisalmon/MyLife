//
//  Post.m
//  MyLife
//
//  Created by Guest User on 01/04/15.
//  Copyright (c) 2015 Guillaume & Zdeněk. All rights reserved.
//

#import "Post.h"

@implementation Post

- (void) setDate: (NSDate*) date{
    mDate = date;
}

- (void) setTitle: (NSString*) title{
    mTitle = title;
}

- (void) setText: (NSString*) text{
    mText = text;
}

- (void) setVoiceoverPath: (NSString*) path{
    mVoiceoverPath = path;
}

- (bool) addMediaPath: (NSString*) path{
    if (path == nil) return NO;
    if ([mMediaPaths count] == 0) {
        mMediaPaths = [NSMutableArray init];
    }
    [mMediaPaths addObject:(path)];
    return YES;
}

@end

