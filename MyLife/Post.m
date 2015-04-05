//
//  Post.m
//  MyLife
//
//  Created by Guest User on 01/04/15.
//  Copyright (c) 2015 Guillaume & Zdeněk. All rights reserved.
//

#import "Post.h"

@implementation Post

- (long long) mIdno {
    return mIdno;
}

- (NSString *)mDateToString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd-MM-yyyy HH:mm:ss"];
    return [formatter stringFromDate:mDate];
}

- (NSString *)mVoiceOverPath {
    return mVoiceoverPath;
}

- (NSString *)mText {
    return mText;
}

- (NSString *)mTitle {
    return mTitle;
}

- (NSMutableArray*) mMediaPaths{
    return mMediaPaths;
}

- (void) setIdno:(long long)idno {
    mIdno = idno;
}

- (void) setDate: (NSDate*) date {
    mDate = date;
}

- (void) setDateFromString:(NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd-MM-yyyy HH:mm:ss"];
    mDate = [formatter dateFromString:date];
}

- (void) setTitle: (NSString*) title {
    mTitle = title;
}

- (void) setText: (NSString*) text {
    mText = text;
}

- (void) setVoiceoverPath: (NSString*) path {
    mVoiceoverPath = path;
}

- (bool) addMediaPath: (NSString*) path {
    if (path == nil) return NO;
    if ([mMediaPaths count] == 0) {
        mMediaPaths = [NSMutableArray array];
    }
    [mMediaPaths addObject:(path)];
    return YES;
}

- (NSString *) toString{
    NSMutableString* medias = [NSMutableString stringWithString:@""];
    for(NSString *s in mMediaPaths){
        [medias appendFormat:@"%@, ", s];
    }
    return [NSString stringWithFormat:@"#%lli: %@ %@ at %@, voice here %@ \nMedias: %@", mIdno, mTitle, mText, [self mDateToString], mVoiceoverPath, medias];
}

@end

