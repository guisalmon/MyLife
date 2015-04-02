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
    DBHandler * dbHandler;
}

@property (nonatomic, retain) NSMutableArray *postsList;
@property (nonatomic, retain) DBHandler * dbHandler;

+ (id)sharedAppSingleton;
- (void)updatePostList:(Post *)post;
- (void)populatePostList;

@end

<<<<<<< HEAD
#endif
=======
#endif
>>>>>>> b889f6974de7b9bc481db7d57658f0f5d276b82f
