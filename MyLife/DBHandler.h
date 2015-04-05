//
//  DBHandler.h
//  MyLife
//
//  This class handles creation and access to the database.
//
//  Created by Guillaume Salmon on 31/03/15.
//  Copyright (c) 2015 Guillaume & Zdeněk. All rights reserved.
//

#ifndef MyLife_DBHandler_h
#define MyLife_DBHandler_h

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Post.h"

@interface DBHandler : NSObject
{
    NSString *databasePath;
}

/**
 * This function gets the current instance of the database for the app or if none exists creates one
 * @return a DBHandler reference or null
 **/
+ (DBHandler*)getSharedInstance;

/**
 * This function creates a new DB
 * @return true if the DB was created, false otherwise
 **/
- (BOOL) createDB;

/**
 * This function saves one post in the app database
 * @param post to save
 * @return true if the insertion succeded, false otherwise
 **/
- (BOOL) saveData:(Post*)post;

- (BOOL) saveMedia:(Post*)post;

- (NSMutableArray*) retrievePosts;

- (NSMutableArray*) retrieveMediaforPosts:(NSMutableArray*)posts;

- (BOOL) eraseAllData;

@end

#endif
