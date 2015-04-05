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

@interface Post : NSObject {
    @private
    long long mIdno;
    NSDate *mDate ;
    NSString *mTitle ;
    NSString *mText ;
    NSString *mVoiceoverPath ;
    NSMutableArray *mMediaPaths ;
}

- (void) setIdno: (long long) idno;
- (long long) mIdno;
- (void) setDate: (NSDate*) date;
- (void) setDateFromString: (NSString*) date;
- (NSString*) mDateToString;
- (void) setTitle: (NSString*) title;
- (NSString*) mTitle;
- (void) setText: (NSString*) text;
- (NSString*) mText;
- (void) setVoiceoverPath: (NSString*) path;
- (NSString*) mVoiceOverPath;
- (bool) addMediaPath: (NSString*) path;
- (NSString*) toString;
- (NSMutableArray*) mMediaPaths;
@end

#endif
