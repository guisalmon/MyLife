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
                NSLog(@"Failed to create table");
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
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        const char *sql_stmt = "drop table if exists postDetail";
        if (sqlite3_prepare_v2(database, sql_stmt,-1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE){
                sqlite3_finalize(statement);
                sqlite3_close(database);
                return YES;
            } else {
                NSLog(@"Failed to erase data");
            }
        } else {
            sqlite3_finalize(statement);
        }
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
                return YES;
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


- (Post*) findByIdNumber:(NSString*)idNumber {
    
    const char *dbpath = [databasePath UTF8String];
    
    NSLog(@"dbpath: %@", [[NSString alloc] initWithUTF8String:dbpath]);
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select date, title, text, voiceoverpath from postDetail where idno=\"%@\"",idNumber];
        const char *query_stmt = [querySQL UTF8String];
        Post* post = [Post alloc];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                [post setDateFromString:date];
                NSString *title = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                [post setTitle:title];
                NSString *text = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                [post setText:text];
                NSString *voiceoverpath = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                [post setVoiceoverPath:voiceoverpath];
                sqlite3_finalize(statement);
                NSLog(@"retrieved in post : %@ %@ at %@, voice: %@", title, text, date, voiceoverpath);
                return post;
                
            } else {
                NSLog(@"Not found");
                sqlite3_finalize(statement);
                return nil;
            }
        } else {
            sqlite3_finalize(statement);
        }
    }
    return nil;
}

- (NSMutableArray*) retrievePosts {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select date, title, text, voiceoverpath from postDetail"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            NSMutableArray * posts = [NSMutableArray array];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Post * post = [Post alloc];
                NSString *date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                [post setDateFromString:date];
                NSString *title = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                [post setTitle:title];
                NSString *text = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                [post setText:text];
                NSString *voiceoverpath = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                [post setVoiceoverPath:voiceoverpath];
                sqlite3_finalize(statement);
                NSLog(@"retrieved in post : %@ %@ at %@, voice: %@", title, text, date, voiceoverpath);
                [posts addObject:post];
                return posts;
            }
        }
    }
    sqlite3_finalize(statement);
    return nil;
}


@end

