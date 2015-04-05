//
//  DBHandler.m
//  MyLife
//
//  Created by Guest User on 31/03/15.
//  Copyright (c) 2015 Guillaume & Zdeněk. All rights reserved.
//

#import "DBHandler.h"

static DBHandler *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBHandler

+(DBHandler*)getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}



-(BOOL) createDB {
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"mylife.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == YES) {
        [self eraseAllData];
    }

        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "create table if not exists postDetail (idno integer primary key autoincrement, date text, title text, text text, voiceoverpath text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table postDetail");
            }
            
            sql_stmt = "create table if not exists postMedia (id integer primary key autoincrement, idpost integer, mediapath text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table postMedia");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    return isSuccess;
}

- (BOOL) eraseAllData {
    const char *dbpath = [databasePath UTF8String];
    BOOL isSuccess = NO;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        const char *sql_stmt = "drop table if exists postDetail";
        if (sqlite3_prepare_v2(database, sql_stmt,-1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE){
                sqlite3_finalize(statement);
                isSuccess = YES;
            } else {
                NSLog(@"Failed to erase data");
            }
        } else {
            NSLog(@"Erase data : Failed to prepare");
            sqlite3_finalize(statement);
        }
        sql_stmt = "drop table if exists postMedia";
        if (sqlite3_prepare_v2(database, sql_stmt,-1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE){
                sqlite3_finalize(statement);
                sqlite3_close(database);
                return isSuccess;
            } else {
                NSLog(@"Failed to erase media data");
            }
        } else {
            NSLog(@"DB: %s", sqlite3_errmsg(database));
            NSLog(@"Erase media data : Failed to prepare");
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    } else {
        NSLog(@"Failed to open database");
    }
    return NO;
}

- (BOOL) saveData:(Post*)post {
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into postDetail (date, title, text, voiceoverpath) values (\"%@\", \"%@\", \"%@\", \"%@\")", [post mDateToString], [post mTitle], [post mText], [post mVoiceOverPath]];
        const char *insert_stmt = [insertSQL UTF8String];
        if (sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL) == SQLITE_OK){
        
            if (sqlite3_step(statement) == SQLITE_DONE){
                
                sqlite3_finalize(statement);
                [post setIdno:sqlite3_last_insert_rowid(database)];
                
                return [self saveMedia:post];
            } else {
                NSLog(@"DB: %s", sqlite3_errmsg(database));
                sqlite3_finalize(statement);
                NSLog(@"Saving failed");
                return NO;
            }
        }else{
            sqlite3_finalize(statement);
             //NSLog(@"DB: %@ - %s", statement, sqlite3_errmsg(database));
            NSLog(@"Preparing saving failed");
        }
        
    }
    return NO;
}

- (BOOL) saveMedia:(Post*)post {
    const char *dbpath = [databasePath UTF8String];
    BOOL isSuccess = YES;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        for (NSString *mediapath in [post mMediaPaths]){
            NSString *querySQL = [NSString stringWithFormat: @"insert into postMedia (idpost, mediapath) values (%lli, \"%@\")", [post mIdno], mediapath];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE){
                    sqlite3_finalize(statement);
                    isSuccess = YES;
                } else {
                    NSLog(@"DB: %s", sqlite3_errmsg(database));
                    sqlite3_finalize(statement);
                    NSLog(@"Saving media failed");
                    isSuccess = NO;
                }
            }else{
                sqlite3_finalize(statement);
                //NSLog(@"DB: %@ - %s", statement, sqlite3_errmsg(database));
                NSLog(@"Preparing saving media failed");
                isSuccess = NO;
            }
        }
    } else return NO;
    return isSuccess;
}

- (NSMutableArray*) retrievePosts {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select rowid, date, title, text, voiceoverpath from postDetail"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            NSMutableArray * posts = [NSMutableArray array];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Post * post = [Post alloc];
                long long idno = sqlite3_column_int64(statement, 0);
                [post setIdno:idno];
                NSString *date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                [post setDateFromString:date];
                NSString *title = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                [post setTitle:title];
                NSString *text = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                [post setText:text];
                NSString *voiceoverpath = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                [post setVoiceoverPath:voiceoverpath];
                NSLog(@"retrieved in post %lli : %@ %@ at %@, voice: %@", idno, title, text, date, voiceoverpath);
                [posts addObject:post];
            }
            sqlite3_finalize(statement);
            return [self retrieveMediaforPosts:posts];
        }
    }
    sqlite3_finalize(statement);
    return nil;
}

- (NSMutableArray*) retrieveMediaforPosts: (NSMutableArray*) posts {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        for (Post *post in posts){
            NSString *querySQL = [NSString stringWithFormat: @"select mediapath from postMedia where idpost=%lli", [post mIdno]];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    NSString *mediapath = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                    [post addMediaPath:mediapath];
                    NSLog(@"retrieved mediapath for post %lli: %@", [post mIdno], mediapath);
                }
                sqlite3_finalize(statement);
            }else{
                NSLog(@"Retrieve media: %@ failed", querySQL);
            }
        }

    }else{
        NSLog(@"Retrieve media: connection to DB failed");
    }
    return posts;
}


@end

