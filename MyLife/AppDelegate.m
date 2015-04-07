//
//  AppDelegate.m
//  MyLife
//
//  Created by Guest User on 31/03/15.
//  Copyright (c) 2015 Guillaume & Zdeněk. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"App: launch finished");
    [[AppSingleton sharedAppSingleton] populatePostList];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"App: enters foreground");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"App: active");
    
    NSMutableArray * m = [NSMutableArray array];
    [m addObject:@"media 11"];
    [m addObject:@"media 12"];
    [m addObject:@"media 13"];
    [[AppSingleton sharedAppSingleton] updatePostList:@"test1" :@"test1 text" :[NSDate date] :@"" :m];
    
    m = [NSMutableArray array];
    [m addObject:@"media 21"];
    [m addObject:@"media 22"];
    [m addObject:@"media 23"];
    [[AppSingleton sharedAppSingleton] updatePostList:@"test2" :@"test2 text" :[NSDate date] :@"Voiceover here 2" :m];
    
    m = [NSMutableArray array];
    [m addObject:@"media 31"];
    [m addObject:@"media 32"];
    [m addObject:@"media 33"];
    [[AppSingleton sharedAppSingleton] updatePostList:@"test3" :@"test3 text" :[NSDate date] :@"Voiceover here 3" :m];
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
