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

@interface AppSingleton : NSObject {
    NSMutableArray *postsList;
}

@property (nonatomic, retain) NSMutableArray *postsList;

+ (id)sharedAppSingleton;

@end

#endif
