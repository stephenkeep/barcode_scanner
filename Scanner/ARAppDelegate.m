//
//  ARAppDelegate.m
//  Scanner
//
//  Created by Stephen Keep on 25/09/2013.
//  Copyright (c) 2013 Red Ant Ltd. All rights reserved.
//

#import "ARAppDelegate.h"
#import "ARViewController.h"

@interface ARAppDelegate ()

@property (nonatomic) ARViewController *viewController;

@end

@implementation ARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ARViewController alloc] initWithNibName:@"ARViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
