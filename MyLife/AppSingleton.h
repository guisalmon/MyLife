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

/**
 *  Creates the AppSingleton instance if it doesn't already exists and returns it.
 **/
+ (id)sharedAppSingleton;

/**
 *  Adds a post to postsList and updates the database.
 *  @param post to add to the app
 **/
- (void)updatePostList:(Post *)post;

/**
 *  Creates and adds a post to postsList and updates the database.
 *  @param title of the post
 *  @param text of the post
 *  @param date assigned to the post
 *  @param path to the voiceover file for the post
 *  @param array containing the paths to all the media files for the post
 **/
- (void)updatePostList:(NSString*)title :(NSString*)text :(NSDate*)date :(NSString*)voiceoverPath :(NSMutableArray*)mediaPaths;

/**
 *  Fills postList with all the post from the database. Must be called at the beginning of the app's life.
 **/
- (void)populatePostList;

@end

#endif