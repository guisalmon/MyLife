//
//  Post.h
//  MyLife
//
//  Created by Guest User on 01/04/15.
//  Copyright (c) 2015 Guillaume & Zdeněk. All rights reserved.
//

#ifndef MyLife_Post_h
#define MyLife_Post_h

#import <Foundation/Foundation.h>
#import <stdlib.h>

@interface Post : NSObject {
    @private
    NSDate *mDate ;
    NSString *mTitle ;
    NSString *mText ;
    NSString *mVoiceoverPath ;
    NSMutableArray *mMediaPaths ;
}

- (void) setDate: (NSDate*) date;
- (void) setTitle: (NSString*) title;
- (void) setText: (NSString*) text;
- (void) setVoiceoverPath: (NSString*) path;
- (bool) addMediaPath: (NSString*) path;
@end

#endif
